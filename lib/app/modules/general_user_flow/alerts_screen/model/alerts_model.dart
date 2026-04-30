// models/alert_model.dart
class AlertModel {
  final String title;
  final String description;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final bool showBulletPoints;
  final List<String>? bulletPoints;

  AlertModel({
    required this.title,
    required this.description,
    required this.primaryButtonText,
    this.secondaryButtonText,
    this.showBulletPoints = false,
    this.bulletPoints,
  });
}