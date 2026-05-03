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
        actions: [
          Obx(() {
            final unreadCount = controller.alerts
                .where((alert) => alert.read == false)
                .length;
            return IconButton(
              icon: controller.isNotificationReadLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.mark_email_read_outlined),
              onPressed:
                  unreadCount > 0 && !controller.isNotificationReadLoading.value
                  ? controller.readNotification
                  : null,
              tooltip: 'Mark all as read',
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isNotificationLoading.value &&
            controller.alerts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.alerts.isEmpty) {
          return Center(
            child: Text(
              'No alerts available',
              style: globalTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getNotification(reset: true),
          child: ListView.builder(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.alerts.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.alerts.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final alert = controller.alerts[index];
              return AlertCardWidget(
                alert: alert,
                onPrimaryPressed: () =>
                    controller.markNotificationAsRead(index),
              );
            },
          ),
        );
      }),
    );
  }
}

class AlertCardWidget extends StatelessWidget {
  final NotificationModel alert;
  final VoidCallback onPrimaryPressed;

  const AlertCardWidget({
    Key? key,
    required this.alert,
    required this.onPrimaryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasRead = alert.read == true;
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.title ?? 'Untitled Alert',
                        style: globalTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                          lineHeight: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hasRead
                            ? const Color(0xFFD9F1E9)
                            : const Color(0xFFFFF0E5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        hasRead ? 'Read' : 'Unread',
                        style: globalTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: hasRead
                              ? const Color(0xFF1F8A59)
                              : const Color(0xFFB85A0C),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  alert.body ?? 'No details available',
                  style: globalTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    lineHeight: 1.5,
                  ),
                ),
                if (alert.createdAt != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    alert.createdAt!.toLocal().toString().split('.').first,
                    style: globalTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: hasRead ? null : onPrimaryPressed,
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
                    hasRead ? 'Already read' : 'Mark as read',
                    style: globalTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
