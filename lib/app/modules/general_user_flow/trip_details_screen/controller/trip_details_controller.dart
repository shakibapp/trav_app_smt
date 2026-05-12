import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';

import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';

class TripDetailsController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  // Observables
  final isLoading = false.obs;
  final selectedTabIndex = 0.obs;
  final expandedStopIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    //getSingleTripData("69fc4ba8154098ba82db9081");
  }

  //get single trip data
  final Rx<SingleTripDetailsModel> singleTripData =
      SingleTripDetailsModel().obs;
  final RxBool isTripDetailsLoading = false.obs;
  Future<void> getSingleTripData(String id) async {
    try {
      isTripDetailsLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.GET, "${Urls.tripDetail}/$id", {},
          is_auth: true);
      if (response != null && response["success"] == true) {
        singleTripData.value =
            SingleTripDetailsModel.fromJson(response["data"]);
        log("Get single trip details success ${response['message']}");
      } else {
        log("get Single trip details failed ${response["message"]}");
      }
    } catch (e) {
      log("get single trip details error ${e.toString()}");
    } finally {
      isTripDetailsLoading.value = false;
    }
  }

  void toggleStop(int index) {
    expandedStopIndex.value = expandedStopIndex.value == index ? -1 : index;
  }

  //update priority Remainder
  final RxBool isPriorityLoading = false.obs;
  final Map<String, dynamic> updatedReminderFields = {};
  final RxString selectedReminderId = ''.obs;

  /// Helper method to check if passport is expired
  bool isPassportExpired(DateTime? expiryDate) {
    if (expiryDate == null) return false;
    return expiryDate.isBefore(DateTime.now());
  }

  /// Helper method to get reminder state: "add", "update", or "checked"
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

  /// Clear updated fields before editing
  void startEditingReminder(String reminderId) {
    updatedReminderFields.clear();
    selectedReminderId.value = reminderId;
  }

  /// Track field updates
  void updateReminderField(String fieldName, dynamic value) {
    updatedReminderFields[fieldName] = value;
  }

  bool _isPassportExpiryMissing(DateTime? expiryDate) {
    return expiryDate == null || expiryDate.year <= 1900;
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
    log('Priority reminder preview payload:\n$pretty');
  }

  /// Send priority reminder update to the API
  Future<void> _sendPriorityReminderUpdate(
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
        updatedReminderFields.clear();
        await getSingleTripData(singleTripData.value.id ?? "");
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
    // Find the existing reminder by id
    final existingReminder = singleTripData.value.priorityRemainders
        ?.firstWhereOrNull((r) => r.id == reminderId);

    // Merge: use passed value if provided, otherwise fall back to existing data
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

    await _sendPriorityReminderUpdate(reminderId, payload);
  }

  // Bottom Sheet Methods
  void showPriorityReminderBottomSheet(
      PriorityRemainder reminder, String type) {
    final state = getReminderState(reminder);
    startEditingReminder(reminder.id ?? '');

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
              // Content
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
                      onChanged: (value) =>
                          updateReminderField('passportCountry', value),
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
                    // Buttons
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
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () => Get.back(),
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
    final isVisaConfirmed = (reminder.isVisaConfirmed ?? false).obs;
    final noVisaRequired = (reminder.noVisaRequired ?? false).obs;
    final needsAttention = (reminder.needsAttention ?? false).obs;
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
                            Icons.badge,
                            color: AppColors.authOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Visa',
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
              // Content
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
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => _buildToggleOption(
                        title: 'Visa Confirmed/ Obtained',
                        subtitle:
                            'I have the necessary visa(s) or have confirmed i dont need one',
                        isSelected: isVisaConfirmed.value,
                        onTap: () => isVisaConfirmed.toggle(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildToggleOption(
                        title: 'No Visa Required',
                        subtitle:
                            'My passport allows visa-free entry to all destinations',
                        isSelected: noVisaRequired.value,
                        onTap: () => noVisaRequired.toggle(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildToggleOption(
                        title: 'Needs Attention',
                        subtitle:
                            'I still need to apply for or check visa requirements',
                        isSelected: needsAttention.value,
                        onTap: () => needsAttention.toggle(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'describe',
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
                                  isVisaConfirmed: isVisaConfirmed.value,
                                  noVisaRequired: noVisaRequired.value,
                                  needsAttention: needsAttention.value,
                                  visaNotes: notesController.text,
                                  previewOnly: false,
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () => Get.back(),
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
              // Content
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
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () => Get.back(),
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
}
