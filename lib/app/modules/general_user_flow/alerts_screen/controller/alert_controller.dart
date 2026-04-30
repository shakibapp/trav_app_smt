// controllers/alert_controller.dart
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/alerts_screen/model/alerts_model.dart';


class AlertController extends GetxController {
  final RxList<AlertModel> alerts = <AlertModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAlerts();
  }

  void loadAlerts() {
    alerts.value = [
      AlertModel(
        title: 'Your flight is coming up',
        description: "Don't forget to check in online and prepare for departure to Rome",
        primaryButtonText: 'View Booking Details',
      ),
      AlertModel(
        title: 'Have you arrived in Airport?',
        description: "Let us know once you've arrived in Melbourne Airport so we can keep everything updated.",
        primaryButtonText: 'Yes, Arrived',
        secondaryButtonText: 'Not Yet',
      ),
      AlertModel(
        title: 'Have you arrived safely?',
        description: "Let us know once you've arrived in Rome so we can keep everything updated.",
        primaryButtonText: 'Yes, Arrived',
        secondaryButtonText: 'Not Yet',
      ),
      AlertModel(
        title: 'Check-in reminder',
        description: "It's time to check into your stay. We'll now is expecting you.",
        primaryButtonText: 'Check-in',
        secondaryButtonText: 'Not Yet',
      ),
      AlertModel(
        title: 'Next trip coming up',
        description: 'You have an upcoming journey from Rome to Paris.',
        primaryButtonText: 'View Booking Details',
      ),
      AlertModel(
        title: 'You still have things to book',
        description: 'Complete your bookings to enjoy your trip on track.',
        primaryButtonText: 'Book now',
        showBulletPoints: true,
        bulletPoints: [
          'Accommodation not added',
          'Transport not added',
        ],
      ),
    ];
  }

  void onPrimaryButtonPressed(int index) {
    // Handle primary button action
    print('Primary button pressed for alert: ${alerts[index].title}');
  }

  void onSecondaryButtonPressed(int index) {
    // Handle secondary button action
    print('Secondary button pressed for alert: ${alerts[index].title}');
  }
}