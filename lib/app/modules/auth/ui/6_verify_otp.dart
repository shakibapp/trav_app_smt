import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/style/global_text_style.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../controller/verify_otp_controller.dart';

class VerifyOtpScreen extends GetView<VerifyOtpController> {
  const VerifyOtpScreen({super.key});

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
                  text: 'hello@traveller.com',
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

    return Column(
      children: [
        Pinput(
          controller: controller.otpController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          length: 4,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: (pin) {},
        ),
        SizedBox(height: 28.h),
        CustomButtonWidget(
          label: 'Verify Code',
          onPressed: controller.onVerifyPressed,
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
              "Didn't receive the code? ",
              style: globaltextInterTight(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyColor,
                lineHeight: 1.2,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Resend',
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
    );
  }
}
