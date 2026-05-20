import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../controller/1_preferences_controller.dart';
import '3_travel_details.dart';

class PreferencesAboutYouScreen extends GetView<PreferencesController> {
  const PreferencesAboutYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: backButton(onTap: ()=>Get.back()),
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
                'Step 2 of 4',
                style: globaltextInterTight(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'About You',
                style: globaltextInterTight(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                  lineHeight: 1.05,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Which age range best describe you?',
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: controller.ageRanges
                      .map(
                        (v) => _optionChip(
                          label: v,
                          selected: controller.selectedAgeRange.value == v,
                          onTap: () => controller.setAgeRange(v),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Spacer(),
              Obx(() {
                final enabled = controller.canContinueStep2;
                return CustomButtonWidget(
                  label: 'Next',
                  onPressed: enabled
                      ? () =>
                            Get.to(() => const PreferencesTravelDetailsScreen())
                      : null,
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

  Widget _optionChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.authOrange : AppColors.whiteColor,
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
            color: selected ? AppColors.whiteColor : AppColors.blackColor,
            lineHeight: 1.1,
          ),
        ),
      ),
    );
  }
}
