import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/modules/general_user_flow/profile/controller/profile_controller.dart';

class ParentSettingsController extends GetxController {
  final profileController = Get.find<ProfileController>();
  final localService = LocalService.localService;
  final isLoading = false.obs;

  // Alert Preferences
  final flightAlert = true.obs;
  final checkInReminders = true.obs;
  final delayUpdates = true.obs;
  final arriveAlerts = true.obs;
  final marketingEmails = true.obs;
  final passportAlert = true.obs;

  // Notification Channels
  final pushNotifications = true.obs;
  final emailNotifications = true.obs;

  // System/Admin Notifications
  final newUserNotifications = true.obs;
  final tripMilestoneNotifications = true.obs;
  final userSuspensionNotifications = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentSettings();
  }

  // Load parent's current settings from their profile
  void _loadCurrentSettings() async {
    if (profileController.userProfile.value == null) {
      await profileController.getUserProfile();
    }
    final profile = profileController.userProfile.value;
    if (profile != null) {
      flightAlert.value = profile.flightAlert ?? true;
      checkInReminders.value = profile.checkInReminders ?? true;
      delayUpdates.value = profile.delayUpdates ?? true;
      arriveAlerts.value = profile.arriveAlerts ?? true;
      marketingEmails.value = profile.marketingEmails ?? true;
      passportAlert.value = profile.passportAlert ?? true;
      
      pushNotifications.value = profile.pushNotifications ?? true;
      emailNotifications.value = profile.emailNotifications ?? true;

      newUserNotifications.value = profile.newUserNotifications ?? true;
      tripMilestoneNotifications.value = profile.tripMilestoneNotifications ?? true;
      userSuspensionNotifications.value = profile.userSuspensionNotifications ?? true;
    }
  }

  // Toggle methods
  void toggleFlightAlert(bool value) => flightAlert.value = value;
  void toggleCheckInReminders(bool value) => checkInReminders.value = value;
  void toggleDelayUpdates(bool value) => delayUpdates.value = value;
  void toggleArriveAlerts(bool value) => arriveAlerts.value = value;
  void toggleMarketingEmails(bool value) => marketingEmails.value = value;
  void togglePassportAlert(bool value) => passportAlert.value = value;

  void togglePushNotifications(bool value) => pushNotifications.value = value;
  void toggleEmailNotifications(bool value) => emailNotifications.value = value;

  void toggleNewUserNotifications(bool value) => newUserNotifications.value = value;
  void toggleTripMilestoneNotifications(bool value) => tripMilestoneNotifications.value = value;
  void toggleUserSuspensionNotifications(bool value) => userSuspensionNotifications.value = value;

  // Update profile settings via API
  Future<bool> updateProfile() async {
    try {
      isLoading.value = true;
      final request = http.MultipartRequest(
        "PUT",
        Uri.parse("${Urls.baseUrl}/users/profile"),
      );
      String? token = localService.getToken();
      if (token != null) {
        request.headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': token,
        });
      } else {
        AppToast.showError("Please login again");
        return false;
      }
      
      // Create the JSON data for the data field (excluding image field, as requested)
      Map<String, dynamic> updateData = {
        "flightAlert": flightAlert.value,
        "checkInReminders": checkInReminders.value,
        "delayUpdates": delayUpdates.value,
        "arriveAlerts": arriveAlerts.value,
        "marketingEmails": marketingEmails.value,
        "passportAlert": passportAlert.value,
        "pushNotifications": pushNotifications.value,
        "emailNotifications": emailNotifications.value,
      };

      // Add the data field as JSON string to the request
      request.fields["data"] = jsonEncode(updateData);

      log("Updating parent settings with data: ${jsonEncode(updateData)}");

      final streamedRequest = await request.send();
      final response = await http.Response.fromStream(streamedRequest);
      final decodeResponse = jsonDecode(response.body);
      log("Parent settings update response: $decodeResponse");
      log("Status code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppToast.showSuccess("Settings updated successfully!");
        // Refresh the profile controller data
        await profileController.getUserProfile();
        return true;
      } else {
        AppToast.showError(decodeResponse["message"] ?? "Failed to update settings");
        return false;
      }
    } catch (e) {
      log("Parent settings update error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    await updateProfile();
  }
}
