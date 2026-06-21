import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../controller/6_verify_otp_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String email;
  final bool isForPasswordReset;

  VerifyOtpScreen({
    super.key,
    required this.email,
    required this.isForPasswordReset,
  });

  final controller = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () =>Get.back(),
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
            'Verify Email',
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
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'We have sent a 4-digit code to your email ',
                  style: globaltextInterTight(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryColor,
                    lineHeight: 1.4,
                  ),
                ),
                TextSpan(
                  text: (email.isNotEmpty) ? email : 'hello@traveller.com',
                  style: globaltextInterTight(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.authOrange,
                    lineHeight: 1.4,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _form() {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.h,
      textStyle: globaltextInterTight(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.blackColor,
        lineHeight: 1.1,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.authFieldBorder, width: 1.5),
        borderRadius: BorderRadius.circular(14.r),
        color: AppColors.whiteColor,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.authOrange, width: 2),
      borderRadius: BorderRadius.circular(14.r),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(14.r),
    );

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Pinput(
            controller: controller.otpController,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            errorPinTheme: errorPinTheme,
            length: 4,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            keyboardType: TextInputType.number,
            onCompleted: (pin) {
              // Optional: Auto-submit when all 4 digits are entered
              // controller.onVerifyOtpPressed(email, isForPasswordReset);
            },
            validator: (pin) {
              if (pin == null || pin.isEmpty) {
                return 'OTP is required';
              }
              if (pin.length != 4) {
                return 'OTP must be 4 digits';
              }
              if (!RegExp(r'^[0-9]{4}$').hasMatch(pin)) {
                return 'OTP must contain only numbers';
              }
              return null;
            },
          ),
          SizedBox(height: 28.h),
          Obx(
            () => CustomButtonWidget(
              label: 'Verify Code',
              onPressed: () =>
                  controller.onVerifyOtpPressed(email, isForPasswordReset),
              loading: controller.isVerifyingOTP.value,
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
          SizedBox(height: 18.h),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: globaltextInterTight(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                    lineHeight: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: controller.canResendOTP.value
                      ? () => controller.onResendOtpPressed(email)
                      : null,
                  child: Text(
                    controller.canResendOTP.value
                        ? 'Resend'
                        : 'Resend in ${controller.resendCountdown.value}s',
                    style: globaltextInterTight(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: controller.canResendOTP.value
                          ? AppColors.authOrange
                          : AppColors.greyColor,
                      lineHeight: 1.2,
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
