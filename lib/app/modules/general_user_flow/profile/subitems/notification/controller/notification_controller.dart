import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/modules/general_user_flow/profile/controller/profile_controller.dart';

class NotificationController extends GetxController {
  final profileController = Get.find<ProfileController>();
  final localService = LocalService.localService;
  final isLoading = false.obs;

  // Alert Preferences
  final flightAlert = false.obs;
  final checkInReminders = false.obs;
  final delayUpdates = false.obs;
  final arriveAlerts = false.obs;
  final marketingEmails = false.obs;
  final passportAlert = false.obs;

  // Notification Channels
  final pushNotifications = false.obs;
  final emailNotifications = false.obs;

  // System Notifications
  final newUserNotifications = false.obs;
  final tripMilestoneNotifications = false.obs;
  final userSuspensionNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() async {
    if (profileController.userProfile.value == null) {
      await profileController.getUserProfile();
    }
    final profile = profileController.userProfile.value;
    if (profile != null) {
      flightAlert.value = profile.flightAlert ?? false;
      checkInReminders.value = profile.checkInReminders ?? false;
      delayUpdates.value = profile.delayUpdates ?? false;
      arriveAlerts.value = profile.arriveAlerts ?? false;
      marketingEmails.value = profile.marketingEmails ?? false;
      passportAlert.value = profile.passportAlert ?? false;
      
      pushNotifications.value = profile.pushNotifications ?? false;
      emailNotifications.value = profile.emailNotifications ?? false;

      newUserNotifications.value = profile.newUserNotifications ?? false;
      tripMilestoneNotifications.value = profile.tripMilestoneNotifications ?? false;
      userSuspensionNotifications.value = profile.userSuspensionNotifications ?? false;
    }
  }

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

      request.fields["data"] = jsonEncode(updateData);

      log("Updating notification settings with data: ${jsonEncode(updateData)}");

      final streamedRequest = await request.send();
      final response = await http.Response.fromStream(streamedRequest);
      final decodeResponse = jsonDecode(response.body);
      log("Notification settings update response: $decodeResponse");
      log("Status code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppToast.showSuccess("Settings updated successfully!");
        await profileController.getUserProfile();
        return true;
      } else {
        AppToast.showError(decodeResponse["message"] ?? "Failed to update settings");
        return false;
      }
    } catch (e) {
      log("Notification settings update error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    await updateProfile();
  }
}
