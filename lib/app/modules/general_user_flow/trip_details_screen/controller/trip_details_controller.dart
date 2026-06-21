
//   void showPriorityReminderBottomSheet(
//       PriorityRemainder reminder, String type) {
//     final state = getReminderState(reminder);
//     Widget sheet;
//     if (type == 'Visa') {
//       sheet = VisaBottomSheet(
//         reminder: reminder,
//         controller: this,
//         showAiCard: true,
//       );
//     } else if (type == 'Travel Insurance') {
//       sheet = TravelInsuranceBottomSheet(reminder: reminder, controller: this);
//     } else {
//       sheet = PassportBottomSheet(
//           reminder: reminder, state: state, controller: this);
//     }
//     Get.bottomSheet(sheet, isScrollControlled: true);
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/route_optimize_ai_data.dart';
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

  // ─── Single Trip Data ────────────────────────────────────────────────────────
  final Rx<SingleTripDetailsModel> singleTripData =
      SingleTripDetailsModel().obs;
  final RxBool isTripDetailsLoading = false.obs;

  Future<void> getSingleTripData(String id) async {
    try {
      isTripDetailsLoading.value = true;

      // ✅ নতুন trip load হলে আগের optimize data clear করো
      // getOptimize এর ভেতর থেকে call হলে reset করবে না
      if (!isOptimizeLoading.value) {
        _resetOptimizeFields();
      }

      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.GET, "${Urls.tripDetail}/$id", {},
          is_auth: true);
      if (response != null && response["success"] == true) {
        singleTripData.value =
            SingleTripDetailsModel.fromJson(response["data"]);

        // ✅ Reorder list init after data fetch
        initReorderedItineraries();

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

  // ─── Optimize Route ──────────────────────────────────────────────────────────
  final RxBool showOptimizeCard = true.obs;

  void dismissOptimizeCard() {
    showOptimizeCard.value = false;
  }

  final RxBool isOptimizeLoading = false.obs;

  // ✅ আলাদা Rx fields — Obx সবসময় সঠিকভাবে trigger হবে
  final Rx<RouteOptimizeAiData> routeOptimizeAi = RouteOptimizeAiData().obs;
  final RxList<String> optimizeCurrentOrder = <String>[].obs;
  final RxList<String> optimizeOptimizedOrder = <String>[].obs;
  final RxBool optimizeIsAlreadyOptimal = false.obs;
  final RxString optimizeTimeSaved = ''.obs;
  final RxString optimizeReason = ''.obs;
  final RxList<String> optimizeTips = <String>[].obs;
  final RxBool hasOptimizeData = false.obs;

  /// নতুন trip load হলে সব optimize data reset করো
  void _resetOptimizeFields() {
    routeOptimizeAi.value = RouteOptimizeAiData();
    optimizeCurrentOrder.clear();
    optimizeOptimizedOrder.clear();
    optimizeIsAlreadyOptimal.value = false;
    optimizeTimeSaved.value = '';
    optimizeReason.value = '';
    optimizeTips.clear();
    hasOptimizeData.value = false;
  }

  /// Optimize API response থেকে সব Rx field update করে
  void _updateOptimizeFields(RouteOptimizeAiData data) {
    routeOptimizeAi.value = data;
    optimizeCurrentOrder.assignAll(data.currentOrder ?? []);
    optimizeOptimizedOrder.assignAll(data.optimizedOrder ?? []);
    optimizeIsAlreadyOptimal.value = data.isAlreadyOptimal ?? false;
    optimizeTimeSaved.value = data.estimatedTimeSaved ?? '';
    optimizeReason.value = data.reason ?? '';
    optimizeTips.assignAll(data.tips ?? []);
    hasOptimizeData.value = true;
  }

  Future<void> getOptimize(String tripId) async {
    try {
      isOptimizeLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.GET, "${Urls.baseUrl}/ai/optimize-route/$tripId", {},
          is_auth: true);
      if (response != null && response["success"] == true) {
        final data = RouteOptimizeAiData.fromJson(response["data"]);
        // ✅ প্রতিটা field আলাদাভাবে update — Obx সবসময় re-render হবে
        _updateOptimizeFields(data);
        showOptimizeCard.value = true;
        await getSingleTripData(tripId);
        log("Optimize route success ${response["message"]}");
      } else {
        log("Optimize Route failed ${response["message"]}");
      }
    } catch (e) {
      log("Optimize Route Error ${e.toString()}");
    } finally {
      isOptimizeLoading.value = false;
    }
  }

  // ─── Drag & Drop Itinerary Reorder ──────────────────────────────────────────
  final RxList<dynamic> reorderedItineraries = <dynamic>[].obs;

  /// API data আসার পরে এই method call করো
  void initReorderedItineraries() {
    reorderedItineraries.value =
        List.from(singleTripData.value.itineraries ?? []);
  }

  /// ReorderableListView এর onReorder callback এ এটা call হবে
  void reorderItinerary(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = reorderedItineraries.removeAt(oldIndex);
    reorderedItineraries.insert(newIndex, item);
  }

  // ─── Visa Summary with AI ────────────────────────────────────────────────────
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

  // ─── Priority Reminder ───────────────────────────────────────────────────────
  final RxBool isPriorityLoading = false.obs;
  final Map<String, dynamic> updatedReminderFields = {};
  final RxString selectedReminderId = ''.obs;

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

  void startEditingReminder(String reminderId) {
    updatedReminderFields.clear();
    selectedReminderId.value = reminderId;
  }

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

  // ─── Reminders ───────────────────────────────────────────────────────────────
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
    final existingReminder = singleTripData.value.priorityRemainders
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

  // ─── Bottom Sheet ─────────────────────────────────────────────────────────────
  void showPriorityReminderBottomSheet(
      PriorityRemainder reminder, String type) {
    final state = getReminderState(reminder);
    Widget sheet;
    if (type == 'Visa') {
      sheet = VisaBottomSheet(
        reminder: reminder,
        controller: this,
        showAiCard: true,
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