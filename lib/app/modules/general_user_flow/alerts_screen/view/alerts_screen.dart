// views/alerts_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';

import '../controller/alert_controller.dart';
import '../model/alerts_model.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AlertController controller = Get.put(AlertController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        title: Text(
          'Alerts',
          style: globalTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.alerts.length,
          itemBuilder: (context, index) {
            return AlertCardWidget(
              alert: controller.alerts[index],
              onPrimaryPressed: () => controller.onPrimaryButtonPressed(index),
              onSecondaryPressed:
                  controller.alerts[index].secondaryButtonText != null
                  ? () => controller.onSecondaryButtonPressed(index)
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class AlertCardWidget extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const AlertCardWidget({
    Key? key,
    required this.alert,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.notifications,
              color: Color(0xFF666666),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: globalTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    lineHeight: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  alert.description,
                  style: globalTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    lineHeight: 1.5,
                  ),
                ),
                if (alert.showBulletPoints && alert.bulletPoints != null) ...[
                  const SizedBox(height: 8),
                  ...alert.bulletPoints!.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            point,
                            style: globalTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onPrimaryPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        alert.primaryButtonText,
                        style: globalTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (alert.secondaryButtonText != null) ...[
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: onSecondaryPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF6B35),
                          side: const BorderSide(
                            color: Color(0xFFFF6B35),
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          alert.secondaryButtonText!,
                          style: globalTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
