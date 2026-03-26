import 'package:get/get.dart';

class NotificationController extends GetxController {
  final flightAlerts = false.obs;
  final checkInReminders = false.obs;
  final parentUpdates = false.obs;
  final marketingEmails = false.obs;
  final passportAlerts = false.obs;

  final pushNotifications = false.obs;
  final emailNotifications = false.obs;

  final isLoading = false.obs;

  void saveChanges() {
    // TODO: Implement save logic
    print('Save changes');
  }
}
