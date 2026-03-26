import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/custom_button_widget.dart';

import '../controller/notification_controller.dart';

class NotificationScreen extends GetWidget<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notification Settings',
          style: globaltextInterTight(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.blackColor,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('ALERT PREFERENCES'),
            _buildSectionContainer([
              _buildToggleRow('Flight Alerts', controller.flightAlerts),
              _buildToggleRow(
                'Check-in Reminders',
                controller.checkInReminders,
              ),
              _buildToggleRow('Parent Updates', controller.parentUpdates),
              _buildToggleRow('Marketing Emails', controller.marketingEmails),
              _buildToggleRow('Passport Alerts', controller.passportAlerts),
            ]),
            SizedBox(height: 24.h),
            _buildSectionHeader('NOTIFICATION CHANNELS'),
            _buildSectionContainer([
              _buildToggleRow(
                'Push Notifications',
                controller.pushNotifications,
                svgIcon: AppIcons.profileNotification,
              ),
              _buildToggleRow(
                'Email Notifications',
                controller.emailNotifications,
                svgIcon: AppIcons.profileEmail,
              ),
            ]),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                'You can choose one or multiple notification channels.',
                style: globaltextInterTight(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Obx(
              () => CustomButtonWidget.primary(
                label: 'Save Changes',
                loading: controller.isLoading.value,
                onPressed: controller.isLoading.value
                    ? null
                    : controller.saveChanges,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: globaltextInterTight(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.greyColor,
        ),
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleRow(
    String title,
    RxBool value, {
    IconData? icon,
    String? svgIcon,
  }) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            if (svgIcon != null) ...[
              SvgPicture.asset(
                svgIcon,
                width: 22.sp,
                height: 22.sp,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondaryColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 12.w),
            ] else if (icon != null) ...[
              Icon(icon, color: AppColors.secondaryColor, size: 22.sp),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                title,
                style: globaltextInterTight(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            Switch(
              value: value.value,
              onChanged: (v) => value.value = v,
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
