import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/controller/trip_details_controller.dart';

import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/visa_ai_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/widget/passport_bottom_sheet.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trips/models/trip_model.dart';

class HomeController extends GetxController implements PriorityReminderHandler {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

  final TextEditingController parentEmailController = TextEditingController();
  final RxString selectedTripId = ''.obs;
  final RxString selectedItineraryId = ''.obs;
  final RxBool showVisaReminderPrompt = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingTrips();
  }

  final RxList<AllTripDataModel> upcomingTripsFromApi =
      <AllTripDataModel>[].obs;
  final RxList<AllTripDataModel> ongoingTripsFromApi =
      <AllTripDataModel>[].obs;
  final RxBool isLoadingTrips = false.obs;
  Future<void> fetchUpcomingTrips() async {
    try {
      isLoadingTrips.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.trips,
        null,
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        final allTrips = List<AllTripDataModel>.from(
            response["data"]["data"].map((e) => AllTripDataModel.fromJson(e)));

        upcomingTripsFromApi.value = allTrips
            .where((trip) => trip.status?.toLowerCase() == 'upcoming')
            .toList();

        ongoingTripsFromApi.value = allTrips
            .where((trip) => trip.status?.toLowerCase() == 'ongoing')
            .toList();

        final firstTripId = ongoingTripsFromApi.isNotEmpty
            ? ongoingTripsFromApi.first.id?.toString() ?? ''
            : upcomingTripsFromApi.isNotEmpty
                ? upcomingTripsFromApi.first.id?.toString() ?? ''
                : '';
        if (firstTripId.isNotEmpty && selectedTripId.value.isEmpty) {
          await getTripDetailById(firstTripId);
        }
      } else {
        log(
          "Failed to fetch upcoming trips: ${response?['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      log("Error fetching upcoming trips: $e");
    } finally {
      isLoadingTrips.value = false;
    }
  }

  // get trip details by trip id
  final Rx<SingleTripDetailsModel> tripDetail = SingleTripDetailsModel().obs;
  final RxBool isLoadingTripDetail = false.obs;
  Future<void> getTripDetailById(String tripId) async {
    if (tripId.isEmpty) return;

    selectedTripId.value = tripId;
    selectedItineraryId.value = '';
    showVisaReminderPrompt.value = false;
    // itineraryDetail.value = ItineraryDetailsModel();

    try {
      isLoadingTripDetail.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.tripDetail}/$tripId",
        {},
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        tripDetail.value = SingleTripDetailsModel.fromJson(response['data']);
        tripDetail.refresh();
        log("Trip detail fetched successfully for trip ID: $tripId");
        log("Trip Detail: ${response['data']}");
      } else {
        log(
          "Failed to fetch trip detail: ${response?['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      log("Error fetching trip detail: $e");
    } finally {
      isLoadingTripDetail.value = false;
    }
  }

  final RxBool isPriorityLoading = false.obs;

  bool _isPassportExpiryMissing(DateTime? expiryDate) {
    return expiryDate == null || expiryDate.year <= 1900;
  }

  bool isPassportExpired(DateTime? expiryDate) {
    if (expiryDate == null) return false;
    return expiryDate.isBefore(DateTime.now());
  }

  String getReminderState(PriorityRemainder reminder) {
    if (reminder.passportCountry == null ||
        reminder.passportCountry!.isEmpty ||
        reminder.passportCountry == 'null' ||
        _isPassportExpiryMissing(reminder.passportExpiry)) {
      return 'add';
    }

    if (reminder.passportExpiry != null &&
        isPassportExpired(reminder.passportExpiry)) {
      return 'update';
    }

    if (reminder.isVisaConfirmed == true ||
        reminder.haveInsurance == true ||
        (reminder.noVisaRequired == true && reminder.needsAttention == false)) {
      return 'checked';
    }

    return 'add';
  }

  String? _normalizePassportExpiry(String? expiry) {
    if (expiry == null || expiry.isEmpty) return null;
    try {
      final parsed = DateTime.parse(expiry);
      return parsed.toUtc().toIso8601String();
    } catch (_) {
      return expiry;
    }
  }

  Map<String, dynamic> _buildPriorityReminderData({
    String? passportCountry,
    String? passportExpiry,
    bool? isVisaConfirmed,
    bool? noVisaRequired,
    bool? needsAttention,
    String? visaNotes,
    bool? haveInsurance,
  }) {
    return {
      'passportCountry': passportCountry ?? '',
      'passportExpiry': _normalizePassportExpiry(passportExpiry) ??
          '1900-01-01T00:00:00.000Z',
      'isVisaConfirmed': isVisaConfirmed ?? false,
      'noVisaRequired': noVisaRequired ?? false,
      'needsAttention': needsAttention ?? false,
      'visaNotes': visaNotes ?? '',
      'haveInsurance': haveInsurance ?? false,
    };
  }

  void _printPriorityReminderData(Map<String, dynamic> payload) {
    final pretty = const JsonEncoder.withIndent('  ').convert(payload);
    log('Priority reminder payload:\n$pretty');
  }

  Future<void> sendPriorityReminderUpdate(
    String reminderId,
    Map<String, dynamic> data,
  ) async {
    try {
      isPriorityLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.PUT,
        "${Urls.priorityStatusChange}/$reminderId",
        jsonEncode(data),
        is_auth: true,
      );
      if (response != null && response["success"] == true) {
        AppSnackbar.success("${response["message"]}");
       
        log("Priority reminder updated successfully");
        // Refresh trip detail to reflect updated values
        await getTripDetailById(selectedTripId.value);
         Navigator.pop(Get.context!);
      } else {
        AppSnackbar.failed("${response["message"]}");
        log("Priority reminder update failed ${response["message"]}");
      }
    } catch (e) {
      log("Priority reminder update error: ${e.toString()}");
      AppSnackbar.failed("Error updating reminder");
    } finally {
      isPriorityLoading.value = false;
    }
  }

  final Rx<VisaAiModel> visaAiSummerData = VisaAiModel().obs;

  final RxBool isVisaSummeryLoading = false.obs;
  Future<void> getVisaSummery(String tripId) async {
    try {
      isVisaSummeryLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.GET, "${Urls.baseUrl}/ai/visa-summary/$tripId", {},
          is_auth: true);
      if (response != null && response["success"] == true) {
        visaAiSummerData.value = VisaAiModel.fromJson(response["data"]);
        log("get Visa Ai Summery data success--${response["message"]}");
      } else {
        log("get Visa Ai summery failed ---${response["message"]}");
      }
    } catch (e) {
      log("Get visa Ai error --${e.toString()}");
    } finally {
      isVisaSummeryLoading.value = false;
    }
  }

  /// Main method — merges existing reminder data with new values before sending
  Future<void> changePriority(
    String reminderId, {
    String? passportCountry,
    String? passportExpiry,
    bool? isVisaConfirmed,
    bool? noVisaRequired,
    bool? needsAttention,
    String? visaNotes,
    bool? haveInsurance,
    bool previewOnly = false,
  }) async {
    // Find existing reminder from tripDetail
    final existingReminder = tripDetail.value.priorityRemainders
        ?.firstWhereOrNull((r) => r.id == reminderId);

    final payload = _buildPriorityReminderData(
      passportCountry: passportCountry ?? existingReminder?.passportCountry,
      passportExpiry: passportExpiry ??
          (existingReminder?.passportExpiry != null &&
                  existingReminder!.passportExpiry!.year > 1900
              ? existingReminder.passportExpiry!.toIso8601String()
              : null),
      isVisaConfirmed: isVisaConfirmed ?? existingReminder?.isVisaConfirmed,
      noVisaRequired: noVisaRequired ?? existingReminder?.noVisaRequired,
      needsAttention: needsAttention ?? existingReminder?.needsAttention,
      visaNotes: visaNotes ?? existingReminder?.visaNotes,
      haveInsurance: haveInsurance ?? existingReminder?.haveInsurance,
    );

    _printPriorityReminderData(payload);

    if (previewOnly) {
      AppSnackbar.success('Reminder data preview logged.');
      return;
    }

    await sendPriorityReminderUpdate(reminderId, payload);
  }

  void showPriorityReminderBottomSheet(
      PriorityRemainder reminder, String type) {
    final state = getReminderState(reminder);

    if (type == 'Visa') {
      _showVisaBottomSheet(reminder, state);
    } else if (type == 'Travel Insurance') {
      _showTravelInsuranceBottomSheet(reminder, state);
    } else {
      _showPassportBottomSheet(reminder, state);
    }
  }

  void _showPassportBottomSheet(PriorityRemainder reminder, String state) {
    final countryController = TextEditingController(
      text: reminder.passportCountry ?? '',
    );
    final expiryController = TextEditingController(
      text: reminder.passportExpiry != null &&
              reminder.passportExpiry!.year > 1900
          ? reminder.passportExpiry!.toIso8601String().split('T')[0]
          : '',
    );

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFffe7d9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.document_scanner,
                            color: AppColors.authOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Passport',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              state == 'add'
                                  ? 'Add your passport details'
                                  : state == 'update'
                                      ? 'Update passport details'
                                      : 'Passport verified',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Issuing Country',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: countryController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Bangladesh',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Passport Expiry Date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: expiryController,
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: Get.context!,
                          initialDate: reminder.passportExpiry != null &&
                                  reminder.passportExpiry!.year > 1900
                              ? reminder.passportExpiry!
                              : DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (selectedDate != null) {
                          expiryController.text =
                              selectedDate.toIso8601String().split('T')[0];
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select expiry date',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            borderColor: AppColors.authOrange,
                            bgColor: Colors.transparent,
                            onTap: () => Get.back(),
                            name: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => appButton(
                              textColor: Colors.white,
                              onTap: () {
                                if (isPriorityLoading.value) return;
                                if (countryController.text.isEmpty ||
                                    expiryController.text.isEmpty) {
                                  AppSnackbar.failed('Please fill all fields');
                                  return;
                                }
                                changePriority(
                                  reminder.id ?? '',
                                  passportCountry: countryController.text,
                                  passportExpiry: expiryController.text,
                                  previewOnly: false,
                                );
                               
                              },
                              name: isPriorityLoading.value
                                  ? "Saving..."
                                  : "Save",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showVisaBottomSheet(PriorityRemainder reminder, String state) {
    // ✅ Single RxString instead of 3 separate RxBool
    // _showVisaBottomSheet এর ভেতরে, selectedOption.obs এর পরে add করো:
final hasFetchedSummary = (visaAiSummerData.value.destinations?.isNotEmpty == true).obs;
    String _initialOption = '';
    if (reminder.isVisaConfirmed == true) {
      _initialOption = 'confirmed';
    } else if (reminder.noVisaRequired == true) {
      _initialOption = 'no_visa';
    } else if (reminder.needsAttention == true) {
      _initialOption = 'attention';
    }

    final selectedOption = _initialOption.obs; // ✅ Only one selected at a time
    final notesController =
        TextEditingController(text: reminder.visaNotes ?? '');

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFffe7d9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.badge,
                              color: AppColors.authOrange, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Visa',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Have you checked visa requirements?',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Obx একটাই, selectedOption দিয়ে তিনটা option control হচ্ছে
                    Obx(() => _buildToggleOption(
                          title: 'Visa Confirmed / Obtained',
                          subtitle:
                              'I have the necessary visa(s) or have confirmed I don\'t need one',
                          isSelected: selectedOption.value == 'confirmed',
                          onTap: () => selectedOption.value =
                              'confirmed', // ✅ Select করলে বাকিগুলো auto deselect
                        )),
                    const SizedBox(height: 12),
                    Obx(() => _buildToggleOption(
                          title: 'No Visa Required',
                          subtitle:
                              'My passport allows visa-free entry to all destinations',
                          isSelected: selectedOption.value == 'no_visa',
                          onTap: () => selectedOption.value = 'no_visa',
                        )),
                    const SizedBox(height: 12),
                    Obx(() => _buildToggleOption(
                          title: 'Needs Attention',
                          subtitle:
                              'I still need to apply for or check visa requirements',
                          isSelected: selectedOption.value == 'attention',
                          onTap: () => selectedOption.value = 'attention',
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 80),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: GradientBoxBorder(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF7E40),
                              Color(0xFFFF3366),
                              Color(0xFF3388FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Trav AI - Visa Summary",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              // ✅ Ask Trav AI Button
                              Obx(() => isVisaSummeryLoading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        await getVisaSummery(
                                            selectedTripId.value);
                                        hasFetchedSummary.value = true;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF7E40),
                                              Color(0xFFFF3366),
                                              Color(0xFF3388FF),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          "Ask Trav AI",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // ✅ Result card — only shows after button is tapped
                          Obx(() {
                            if (!hasFetchedSummary.value) {
                              return const Text(
                                "Tap 'Ask Trav AI' to get visa info for your trip.",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              );
                            }
                            if (isVisaSummeryLoading.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final destinations =
                                visaAiSummerData.value.destinations ?? [];
                            if (destinations.isEmpty) {
                              return const Text(
                                "No visa info available.",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${visaAiSummerData.value.generalTips}",
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: destinations.length,
                                  itemBuilder: (context, index) {
                                    final data = destinations[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Text(
                                        "• ${data.city} ${data.country} — ${data.visaType} (${data.processingTime})",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Notes',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Note..',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            borderColor: AppColors.authOrange,
                            bgColor: Colors.transparent,
                            onTap: () => Get.back(),
                            name: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => appButton(
                              textColor: Colors.white,
                              onTap: () {
                                if (isPriorityLoading.value) return;

                                // ✅ selectedOption থেকে bool values বের করা
                                changePriority(
                                  reminder.id ?? '',
                                  isVisaConfirmed:
                                      selectedOption.value == 'confirmed',
                                  noVisaRequired:
                                      selectedOption.value == 'no_visa',
                                  needsAttention:
                                      selectedOption.value == 'attention',
                                  visaNotes: notesController.text,
                                  previewOnly: false,
                                );
                                
                              },
                              name: isPriorityLoading.value
                                  ? "Saving..."
                                  : "Mark as Reviewed",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showTravelInsuranceBottomSheet(
      PriorityRemainder reminder, String state) {
    final hasInsurance = (reminder.haveInsurance ?? false).obs;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFffe7d9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shield,
                            color: AppColors.authOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Travel Insurance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Do you have a travel insurance?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => _buildToggleOption(
                        title: 'Yes, I have insurance',
                        subtitle:
                            'I have travel insurance coverage for this trip',
                        isSelected: hasInsurance.value,
                        onTap: () => hasInsurance.value = true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildToggleOption(
                        title: 'Not yet/ Need to get',
                        subtitle: 'I still need to purchase travel insurance',
                        isSelected: !hasInsurance.value,
                        onTap: () => hasInsurance.value = false,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            borderColor: AppColors.authOrange,
                            bgColor: Colors.transparent,
                            onTap: () => Get.back(),
                            name: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => appButton(
                              textColor: Colors.white,
                              onTap: () {
                                if (isPriorityLoading.value) return;
                                changePriority(
                                  reminder.id ?? '',
                                  haveInsurance: hasInsurance.value,
                                  previewOnly: false,
                                );
                                
                              },
                              name: isPriorityLoading.value
                                  ? "Saving..."
                                  : "Save",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.authOrange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.authOrange : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? AppColors.authOrange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Invite Parent ───────────────────────────────────────────────────────

  final RxBool isInvitingParent = false.obs;
  Future<void> inviteParentByEmail(String tripId) async {
    try {
      isInvitingParent.value = true;

      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.PUT,
        "${Urls.baseUrl}/trips/share-with-parents/$tripId",
        jsonEncode({}),
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        Get.back();
        Get.snackbar(
          'Share Trip',
          'Trip has been shared successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        parentEmailController.clear();
      } else {
        Get.back();
        Get.snackbar(
          'Share Trip',
          response?['message'] ?? 'Unknown error occurred',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Error inviting parent: $e");
    } finally {
      parentEmailController.clear();
      isInvitingParent.value = false;
    }
  }
}
