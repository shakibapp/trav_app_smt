import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/style/global_text_style.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../../../core/widgets/custom_textfield_widget.dart';
import '../../../routes/app_routes.dart';
import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
        SizedBox(height: 32.h),
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
            'Welcome Back',
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
            'Login to continue your journey',
            style: globaltextInterTight(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryColor,
              lineHeight: 1.2,
            ),
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
          CustomTextFormWidget(
            sectionTitle: 'EMAIL',
            textEditingController: controller.emailController,
            hintText: 'hello@traveller.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: controller.validateEmail,
          ),
          SizedBox(height: 16.h),
          Obx(
            () => CustomTextFormWidget(
              sectionTitle: 'PASSWORD',
              textEditingController: controller.passwordController,
              hintText: '••••••••',
              isPassword: true,
              isPasswordVisible: controller.isPasswordVisible.value,
              onTogglePasswordVisibility: controller.togglePasswordVisibility,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => controller.onLoginPressed(),
              validator: controller.validatePassword,
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD),
              child: Text(
                'Forgot password?',
                style: globaltextInterTight(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.authOrange,
                  lineHeight: 1.1,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          CustomButtonWidget(
            label: 'Login',
            onPressed: controller.onLoginPressed,
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
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                  lineHeight: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.SIGNUP),
                child: Text(
                  'Sign Up',
                  style: globaltextInterTight(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.authOrange,
                    lineHeight: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
