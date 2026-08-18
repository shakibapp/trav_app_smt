import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/model/add_activity_model.dart'
    hide TimeOfDay;
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/model/single_activity_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/validation/add_activity_validation_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/model/tripltinerary_overview_model.dart'
    as itinerary_model;
import 'package:intl/intl.dart';

class AddActivityController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  ItineraryDetailsController? itineraryDetailsController;

  // Form states
  final formKey = GlobalKey<FormState>();
  final activityNameController = TextEditingController();
  final locationController = TextEditingController();
  final expenseController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  // Reactive variables
  final selectedDayNumber = Rx<int?>(null);
  final selectedCategories = RxList<ActivityCategory>();
  final selectedStartDate = Rx<DateTime?>(null);
  final selectedEndDate = Rx<DateTime?>(null);
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final isEdit = false.obs;

  // Field error states
  final activityNameError = RxnString();
  final dayNumberError = RxnString();
  final categoriesError = RxnString();
  final startDateError = RxnString();
  final endDateError = RxnString();
  final startTimeError = RxnString();
  final endTimeError = RxnString();
  final locationError = RxnString();
  final expenseError = RxnString();

  @override
  void onInit() {
    super.onInit();
    _setupValidationListeners();
  }

  void setActivityForEdit(itinerary_model.Activity activity) {
    isEdit.value = true;
    activityNameController.text = activity.name ?? '';
    selectedDayNumber.value = activity.dayNumber;
    selectedCategories.assignAll(activity.type?.map(
            (t) => ActivityCategory.values.firstWhere((e) => e.name == t)) ??
        []);
    selectedStartDate.value = activity.startDate;
    selectedEndDate.value = activity.endDate;
    startTimeController.text = activity.startTime ?? '';
    endTimeController.text = activity.endTime ?? '';
    locationController.text = activity.location ?? '';
    expenseController.text = activity.expense?.toString() ?? '';
  }

  // Setup real-time validation listeners
  void _setupValidationListeners() {
    activityNameController.addListener(_validateActivityName);
    locationController.addListener(_validateLocation);
    expenseController.addListener(_validateExpense);
    startTimeController.addListener(_validateStartTime);
    endTimeController.addListener(_validateEndTimes);
    selectedDayNumber.listen((_) => _validateDayNumber());
    selectedCategories.listen((_) => _validateCategories());
    selectedStartDate.listen((_) => _validateStartDate());
    selectedEndDate.listen((_) => _validateEndDateRange());
  }

  // Individual field validators
  void _validateActivityName() {
    final result = ActivityValidator.validateActivityName(
      activityNameController.text,
    );
    activityNameError.value = result.isValid ? null : result.errorMessage;
  }

  void _validateDayNumber() {
    final result = ActivityValidator.validateDayNumber(selectedDayNumber.value);
    dayNumberError.value = result.isValid ? null : result.errorMessage;
  }

  void _validateCategories() {
    final result = ActivityValidator.validateCategories(selectedCategories);
    categoriesError.value = result.isValid ? null : result.errorMessage;
  }

  void _validateStartDate() {
    final result = ActivityValidator.validateStartDate(selectedStartDate.value);
    startDateError.value = result.isValid ? null : result.errorMessage;

    // Re-validate end date if it exists
    if (selectedEndDate.value != null) {
      _validateEndDateRange();
    }
  }

  void _validateEndDateRange() {
    final result = ActivityValidator.validateEndDate(
      selectedEndDate.value,
      selectedStartDate.value,
    );
    endDateError.value = result.isValid ? null : result.errorMessage;
  }

  void _validateStartTime() {
    final result = ActivityValidator.validateStartTime(
      startTimeController.text,
    );
    startTimeError.value = result.isValid ? null : result.errorMessage;

    // Re-validate end time if it exists
    if (endTimeController.text.isNotEmpty) {
      _validateEndTimes();
    }
  }

  void _validateEndTimes() {
    final result = ActivityValidator.validateEndTime(
      endTimeController.text,
      startTimeController.text,
    );
    endTimeError.value = result.isValid ? null : result.errorMessage;
  }

  void _validateLocation() {
    final result = ActivityValidator.validateLocation(
      locationController.text,
    );
    locationError.value = result.isValid ? null : result.errorMessage;
  }

  void _validateExpense() {
    final result = ActivityValidator.validateExpense(expenseController.text);
    expenseError.value = result.isValid ? null : result.errorMessage;
  }

  // Toggle category selection
  void toggleCategory(ActivityCategory category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      if (selectedCategories.length < 5) {
        selectedCategories.add(category);
      } else {
        _showError('Maximum 5 categories allowed');
      }
    }
  }

  // Date picker handlers
  Future<void> selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      selectedStartDate.value = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    if (selectedStartDate.value == null) {
      _showError('Please select start date first');
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.value ?? selectedStartDate.value,
      firstDate: selectedStartDate.value!,
      lastDate: selectedStartDate.value!.add(Duration(days: 30)),
    );

    if (picked != null) {
      selectedEndDate.value = picked;
    }
  }

  // Time picker handlers
  Future<void> selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      startTimeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    if (startTimeController.text.isEmpty) {
      _showError('Please select start time first');
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      endTimeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  // Validate all fields
  bool validateAllFields() {
    _validateActivityName();
    _validateDayNumber();
    _validateCategories();
    _validateStartDate();
    _validateEndDateRange();
    _validateStartTime();
    _validateEndTimes();
    _validateLocation();
    _validateExpense();

    return activityNameError.value == null &&
        dayNumberError.value == null &&
        categoriesError.value == null &&
        startDateError.value == null &&
        endDateError.value == null &&
        startTimeError.value == null &&
        endTimeError.value == null &&
        locationError.value == null &&
        expenseError.value == null;
  }

  String toIsoDate(DateTime date) {
    return DateTime.utc(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();
  }

  // Submit form
  Future<void> createActivity(String id) async {
    if (!validateAllFields()) return;
    try {
      isLoading.value = true;

      // Create Activity object
      final Map<String, dynamic> activity = {
        "name": activityNameController.text.trim(),
        "dayNumber": int.parse(selectedDayNumber.value.toString()),
        "type": selectedCategories.map((e) => e.name).toList(),
        "startDate": toIsoDate(selectedStartDate.value!),
        "endDate": toIsoDate(selectedEndDate.value!),
        "startTime": startTimeController.text.trim(),
        "endTime": endTimeController.text.trim(),
        "location": locationController.text.trim(),
        "expense": double.parse(expenseController.text),
      };
      log("user input data ---$activity");
      final response = await networkConfig.ApiRequestHandler(RequestMethod.POST,
          "${Urls.activityCreate}/$id", jsonEncode(activity),
          is_auth: true);
      if (response != null && response["success"] == true) {
        // Add the new activity to the local list instead of refetching all data
        final newActivity = itinerary_model.Activity(
          id: response["data"]["id"],
          name: activityNameController.text.trim(),
          dayNumber: selectedDayNumber.value,
          type: selectedCategories.map((e) => e.name).toList(),
          startDate: selectedStartDate.value,
          endDate: selectedEndDate.value,
          startTime: startTimeController.text.trim(),
          endTime: endTimeController.text.trim(),
          location: locationController.text.trim(),
          expense: double.parse(expenseController.text).toInt(),
          status: "Pending",
        );
        itineraryDetailsController?.addActivityToList(newActivity);

        resetForm();
        Get.back();
        AppSnackbar.success("${response["message"]}");
        log("create activity success ${response["message"]}");
      } else {
        AppSnackbar.failed("${response["message"]}");
        log("create activity failed ${response["message"]}");
      }
    } catch (e) {
      log('Failed to add activity: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // get single activity
  final Rx<SingleActivityModel> singleActivity = SingleActivityModel().obs;
  Future<void> getSingleActivity(String id) async {
    final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET, "${Urls.singleActivityById}/$id", {},
        is_auth: true);
    if (response != null && response["success"] == true) {
      singleActivity.value = SingleActivityModel.fromJson(response["data"]);
      activityNameController.text = singleActivity.value.name.toString();
      locationController.text = singleActivity.value.location.toString();
      expenseController.text = singleActivity.value.expense.toString();
    }
  }

  //update activity --
  final RxBool isUpdateActivivtyLoading = false.obs;
  Future<void> updateActivity(String id) async {
    if (!validateAllFields()) return;
    try {
      isUpdateActivivtyLoading.value = true;

      // Create Activity object
      final Map<String, dynamic> activity = {
        "name": activityNameController.text.trim(),
        "dayNumber": int.parse(selectedDayNumber.value.toString()),
        "type": selectedCategories.map((e) => e.name).toList(),
        "startDate": toIsoDate(selectedStartDate.value!),
        "endDate": toIsoDate(selectedEndDate.value!),
        "startTime": startTimeController.text.trim(),
        "endTime": endTimeController.text.trim(),
        "location": locationController.text.trim(),
        "expense": double.parse(expenseController.text),
      };
      log("user input data ---$activity");
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.PUT, "${Urls.activityCreate}/$id", jsonEncode(activity),
          is_auth: true);
      if (response != null && response["success"] == true) {
        // Update the activity in the local list instead of refetching all data
        final updatedActivity = itinerary_model.Activity(
          id: id,
          name: activityNameController.text.trim(),
          dayNumber: selectedDayNumber.value,
          type: selectedCategories.map((e) => e.name).toList(),
          startDate: selectedStartDate.value,
          endDate: selectedEndDate.value,
          startTime: startTimeController.text.trim(),
          endTime: endTimeController.text.trim(),
          location: locationController.text.trim(),
          expense: double.parse(expenseController.text).toInt(),
          status: "Pending",
        );
        itineraryDetailsController?.updateActivityInList(updatedActivity);

        resetForm();
        Get.back();
        AppSnackbar.success("${response["message"]}");
        log("Update activity success ${response["message"]}");
      } else {
        AppSnackbar.failed("${response["message"]}");
        log("Update activity failed ${response["message"]}");
      }
    } catch (e) {
      log('Failed to update activity: ${e.toString()}');
    } finally {
      isUpdateActivivtyLoading.value = false;
    }
  }

  //create activity by useing ai
  final RxBool isCreateAIActivity = false.obs;
  final preferencesTEC = TextEditingController();
  Future<void> createAIActivtity(String id) async {
    try {
      isCreateAIActivity.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.POST,
          "${Urls.aiCreateActivityById}/$id",
          jsonEncode({
            "preferences": preferencesTEC.text,
          }),
          is_auth: true);
      if (response != null && response["success"] == true) {
        AppSnackbar.success("${response["message"]}");
        log("Ai Create activity ---success ${response["message"]}");
      } else {
        AppSnackbar.failed("${response["message"]}");
        log("AI create activity failed --- ${response["message"]}");
      }
    } catch (e) {
      log("Ai create activity error --${e.toString()}");
    } finally {
      isCreateAIActivity.value = false;
    }
  }

//update status
  final RxBool isMissedLoading = false.obs;
  final RxBool isCompletedLoading = false.obs;

  Future<void> statusUpdateActivity(String id, String status) async {
    try {
      if (status == "Missed") {
        isMissedLoading.value = true;
      } else {
        isCompletedLoading.value = true;
      }

      final Map<String, dynamic> activity = {
        "status": status,
      };

      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.PUT, "${Urls.activityCreate}/$id", jsonEncode(activity),
          is_auth: true);

      if (response != null && response["success"] == true) {
        // Update activity status in local list
        itineraryDetailsController?.updateActivityStatus(id, status);
        AppSnackbar.success("${response["message"]}");
      } else {
        AppSnackbar.failed("${response["message"]}");
      }
    } catch (e) {
      log('Failed to update activity: ${e.toString()}');
    } finally {
      isMissedLoading.value = false;
      isCompletedLoading.value = false;
    }
  }

// delete activity
  final RxBool isDeleteActivity = false.obs;
  Future<void> deleteActivity(String id) async {
    try {
      isDeleteActivity.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.DELETE,
          "${Urls.baseUrl}/activities/$id",
          jsonEncode({}),
          is_auth: true);
      if (response != null && response["success"] == true) {
        AppSnackbar.success("${response["message"]}");
        // Delete the activity from the local list
        itineraryDetailsController?.deleteActivityFromList(id);
      } else {
        AppSnackbar.failed("${response["message"]}");
      }
    } catch (e) {
      log("Delete activity error ${e.toString()}");
    } finally {
      isDeleteActivity.value = false;
    }
  }

  // Reset form
  void resetForm() {
    activityNameController.clear();
    locationController.clear();
    expenseController.clear();
    startTimeController.clear();
    endTimeController.clear();

    selectedDayNumber.value = null;
    selectedCategories.clear();
    selectedStartDate.value = null;
    selectedEndDate.value = null;

    activityNameError.value = null;
    dayNumberError.value = null;
    categoriesError.value = null;
    startDateError.value = null;
    endDateError.value = null;
    startTimeError.value = null;
    endTimeError.value = null;
    locationError.value = null;
    expenseError.value = null;
    errorMessage.value = null;
    isEdit.value = false;
  }

  // Cancel action
  void cancel() {
    resetForm();
    Get.back();
  }

  // Helper methods
  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  void _showError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  @override
  void onClose() {
    activityNameController.removeListener(_validateActivityName);
    locationController.removeListener(_validateLocation);
    expenseController.removeListener(_validateExpense);
    startTimeController.removeListener(_validateStartTime);
    endTimeController.removeListener(_validateEndTimes);
    super.onClose();
  }
}
