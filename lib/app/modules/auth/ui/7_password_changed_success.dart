import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/auth/controller/7_password_changed_success_controller.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/style/global_text_style.dart';
import '../../../core/widgets/custom_button_widget.dart';

class PasswordChangedSuccessScreen
    extends GetView<PasswordChangedSuccessController> {
  const PasswordChangedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: AppColors.authOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 56.sp,
                      color: AppColors.authOrange,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'Password Changed\nSuccessfully',
                  style: globaltextInterTight(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                    lineHeight: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your password has been successfully reset. You can now log in with your new password.',
                  style: globaltextInterTight(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryColor,
                    lineHeight: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    label: 'Back to Login',
                    onPressed: controller.onBackToLoginPressed,
                    fullWidth: true,
                    height: 54.h,
                    radius: 30.r,
                    bgColor: AppColors.authOrange,
                    fgColor: AppColors.whiteColor,
                    textStyle: globaltextInterTight(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                      lineHeight: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
