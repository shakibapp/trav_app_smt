import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../controller/1_preferences_controller.dart';

class PreferencesYourInterestsScreen extends GetView<PreferencesController> {
  const PreferencesYourInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.authFieldBorder, width: 1.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18.sp,
              color: AppColors.authOrange,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                'Step 4 of 4',
                style: globaltextInterTight(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Your Interests',
                style: globaltextInterTight(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                  lineHeight: 1.05,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'What are you most interested in when you travel\nSelect all that apply',
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.4,
                ),
              ),
              SizedBox(height: 14.h),
              Obx(() {
                final count = controller.selectedInterests.length;
                if (count == 0) return const SizedBox.shrink();
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.authOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.authOrange, width: 1.2),
                  ),
                  child: Text(
                    '$count selected',
                    style: globaltextInterTight(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.authOrange,
                      lineHeight: 1.1,
                    ),
                  ),
                );
              }),
              SizedBox(height: 14.h),
              Obx(
                () => Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: controller.interests
                      .map(
                        (v) => _interestChip(
                          label: v,
                          selected: controller.selectedInterests.contains(v),
                          onTap: () => controller.toggleInterest(v),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Spacer(),
              Obx(() {
                final enabled = controller.canContinueStep4;
                return CustomButtonWidget(
                  label: 'Next',
                  onPressed: enabled ? controller.onFinish : null,
                  fullWidth: true,
                  height: 54.h,
                  radius: 30.r,
                  bgColor: enabled
                      ? AppColors.authOrange
                      : AppColors.authOrange.withValues(alpha: 0.45),
                  fgColor: AppColors.whiteColor,
                  textStyle: globaltextInterTight(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                    lineHeight: 1.1,
                  ),
                );
              }),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _interestChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.authOrange.withValues(alpha: 0.12)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.authOrange : AppColors.authFieldBorder,
            width: 1.4,
          ),
        ),
        child: Text(
          label,
          style: globaltextInterTight(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
            lineHeight: 1.1,
          ),
        ),
      ),
    );
  }
}
