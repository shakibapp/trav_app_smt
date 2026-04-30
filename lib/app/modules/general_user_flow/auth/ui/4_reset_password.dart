import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../../core/widgets/custom_textfield_widget.dart';
import '../controller/4_reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
   ResetPasswordScreen({super.key, required this.email});
   final controller = Get.put(ResetPasswordController());

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
            margin: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.authFieldBorder, width: 1.5),
              borderRadius: BorderRadius.circular(100.r),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              _header(),
              SizedBox(height: 28.h),
              _form(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Center(
          child: Image.asset(
            AppImages.applogo,
            height: 92.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 22.h),
        Center(
          child: Text(
            'Create New Password',
            style: globaltextInterTight(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.blackColor,
              lineHeight: 1.1,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Center(
          child: Text(
            'Your new password must be different from previous used passwords.',
            style: globaltextInterTight(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryColor,
              lineHeight: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _form() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Obx(
            () => CustomTextFormWidget(
              sectionTitle: 'NEW PASSWORD',
              textEditingController: controller.newPasswordController,
              hintText: '••••••••',
              isPassword: true,
              isPasswordVisible: controller.isNewPasswordVisible.value,
              onTogglePasswordVisibility:
                  controller.toggleNewPasswordVisibility,
              textInputAction: TextInputAction.next,
              validator: controller.validatePassword,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => CustomTextFormWidget(
              sectionTitle: 'CONFIRM PASSWORD',
              textEditingController: controller.confirmPasswordController,
              hintText: '••••••••',
              isPassword: true,
              isPasswordVisible: controller.isConfirmPasswordVisible.value,
              onTogglePasswordVisibility:
                  controller.toggleConfirmPasswordVisibility,
              textInputAction: TextInputAction.done,
              validator: controller.validateConfirmPassword,
            ),
          ),
          SizedBox(height: 28.h),
          Obx(
            () => CustomButtonWidget(
              label: 'Reset Password',
              onPressed: controller.onResetPassword,
              loading: controller.isResetLoading.value,
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
    );
  }
}
