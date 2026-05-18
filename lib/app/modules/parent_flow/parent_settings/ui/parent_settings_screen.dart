import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/app_bg.dart';
import 'package:hamishphipps/app/core/widgets/custom_button_widget.dart';
import '../../../general_user_flow/profile/controller/profile_controller.dart';
import '../controller/parent_settings_controller.dart';

class ParentSettingsScreen extends GetView<ParentSettingsController> {
   ParentSettingsScreen({super.key});
   final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered (fallback if binding hasn't run)
    if (!Get.isRegistered<ParentSettingsController>()) {
      Get.put(ParentSettingsController());
    }

    return BackgroundScreen(
      bgImg: AppImages.tripBgLight,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Settings",
                  style: globalTextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: ()=>profileController.onLogoutTap(),
                    icon: Icon(Icons.logout,color: Colors.red,))

              ],
            ),
            Text(
              "Manage your connections and alerts",
              style: globalTextStyle(
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 30.h),
            // Alert Preferences
            Text(
              "ALERT PREFERENCES",
              style: globalTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.lightSilverColor,
              ),
            ),
            SizedBox(height: 15.h),
            Obx(() => _buildSwitchItem(
                  title: "Flight Alerts",
                  value: controller.flightAlerts.value,
                  onChanged: controller.toggleFlightAlerts,
                )),
            Obx(() => _buildSwitchItem(
                  title: "Check-in alerts",
                  value: controller.checkInAlerts.value,
                  onChanged: controller.toggleCheckInAlerts,
                )),
            Obx(() => _buildSwitchItem(
                  title: "Delay updates",
                  value: controller.delayUpdates.value,
                  onChanged: controller.toggleDelayUpdates,
                )),
            Obx(() => _buildSwitchItem(
                  title: "Arrive Alerts",
                  value: controller.arriveAlerts.value,
                  onChanged: controller.toggleArriveAlerts,
                )),
            SizedBox(height: 30.h),
            // Notification Channels
            Text(
              "NOTIFICATION CHANNELS",
              style: globalTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.lightSilverColor,
              ),
            ),
            SizedBox(height: 15.h),
            Obx(() => _buildSwitchItem(
                  title: "Push Notifications",
                  value: controller.pushNotifications.value,
                  onChanged: controller.togglePushNotifications,
                  icon: Icons.notifications_none_outlined,
                  iconColor: Colors.green,
                )),
            Obx(() => _buildSwitchItem(
                  title: "Email Notifications",
                  value: controller.emailNotifications.value,
                  onChanged: controller.toggleEmailNotifications,
                  icon: Icons.email_outlined,
                  iconColor: Colors.green,
                )),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "You can choose one or multiple notification channels.",
                style: globalTextStyle(fontSize: 10.sp, color: AppColors.greyColor),
              ),
            ),
            SizedBox(height: 30.h),
            CustomButtonWidget.primary(
              label: "Save Changes",
              onPressed: controller.saveChanges,
              fullWidth: true,
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.orange).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? Colors.orange, size: 20.sp),
            ),
            SizedBox(width: 15.w),
          ],
          Expanded(
            child: Text(
              title,
              style: globalTextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.authOrange,
          ),
        ],
      ),
    );
  }
}
