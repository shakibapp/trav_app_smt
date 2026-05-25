import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/home/controller/home_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/visa_ai_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/widget/passport_bottom_sheet.dart';

class TripDetailsController extends GetxController
    implements PriorityReminderHandler {
  final networkConfig = NetworkConfigV1.instance;
  // Observables
  final isLoading = false.obs;
  final selectedTabIndex = 0.obs;
  final expandedStopIndex = (-1).obs;

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

  //Optimize your route
  final RxBool showOptimizeCard = true.obs;
  void dismissOptimizeCard() {
    showOptimizeCard.value = false;
  }

  final RxBool isOptimizeLoading = false.obs;
  Future<void> getOptimize(String tripId) async {
    try {
      isOptimizeLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.GET, "${Urls.baseUrl}/ai/optimize-route/$tripId", {},
          is_auth: true);
      if (response != null && response["success"] == true) {
        await getSingleTripData(tripId);
        log("Optimize route success${response["message"]}");
      } else {
        log("Optimize Route failed ${response["message"]}");
      }
    } catch (e) {
      log("Optimize Route Error ${e.toString()}");
    } finally {
      isOptimizeLoading.value = false;
    }
  }

  //visa summery with AI
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
        Navigator.pop(Get.context!);
        
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

  //Reminders ---
  final RxBool isReminderLoading = false.obs;
  Future<void> reminderStatus(String tripId) async {
    try {
      isReminderLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.PUT,
          "${Urls.baseUrl}/trips/remainder/$tripId/status",
          jsonEncode({"status": "Checked"}),
          is_auth: true);
      if (response != null && response["success"] == true) {
        singleTripData.value;
        AppSnackbar.success("${response["message"]}");
      } else {
        log("Reminder Status failed --${response["message"]}");
        AppSnackbar.failed("${response["message"]}");
      }
    } catch (e) {
      log("reminder status error --${e.toString()}");
    } finally {
      isReminderLoading.value = false;
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

    await sendPriorityReminderUpdate(reminderId, payload);
  }

  // Bottom Sheet Methods
  // trip_details_controller.dart এ এই 3টা method replace করো
  void showPriorityReminderBottomSheet(
      PriorityRemainder reminder, String type) {
    final state = getReminderState(reminder);
    Widget sheet;
    if (type == 'Visa') {
      sheet = VisaBottomSheet(
        reminder: reminder,
        controller: this,
        showAiCard: true, // HomeController এ explicitly false
      );
    } else if (type == 'Travel Insurance') {
      sheet = TravelInsuranceBottomSheet(reminder: reminder, controller: this);
    } else {
      sheet = PassportBottomSheet(
          reminder: reminder, state: state, controller: this);
    }
    Get.bottomSheet(sheet, isScrollControlled: true);
  }
}
