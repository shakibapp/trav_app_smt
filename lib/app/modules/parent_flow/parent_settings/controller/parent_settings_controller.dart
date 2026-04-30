import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/auth/ui/2_login.dart';
import 'package:hamishphipps/app/routes/app_routes.dart';

class ParentSettingsController extends GetxController {
  // Alert Preferences
  final flightAlerts = true.obs;
  final checkInAlerts = true.obs;
  final delayUpdates = true.obs;
  final arriveAlerts = true.obs;

  // Notification Channels
  final pushNotifications = true.obs;
  final emailNotifications = true.obs;

  void toggleFlightAlerts(bool value) => flightAlerts.value = value;
  void toggleCheckInAlerts(bool value) => checkInAlerts.value = value;
  void toggleDelayUpdates(bool value) => delayUpdates.value = value;
  void toggleArriveAlerts(bool value) => arriveAlerts.value = value;

  void togglePushNotifications(bool value) => pushNotifications.value = value;
  void toggleEmailNotifications(bool value) => emailNotifications.value = value;

  void saveChanges() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
