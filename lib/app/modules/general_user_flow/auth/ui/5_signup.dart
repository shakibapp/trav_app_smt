// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_images.dart';
// import '../../../../core/style/global_text_style.dart';
// import '../../../../core/widgets/custom_button_widget.dart';
// import '../../../../core/widgets/custom_textfield_widget.dart';
// import '../controller/5_signup_controller.dart';

// class SignupScreen extends GetWidget<SignupController> {
//   const SignupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             children: [
//               _header(),
//               SizedBox(height: 28.h),
//               _form(),
//               SizedBox(height: 24.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _header() {
//     return Column(
//       children: [
//         SizedBox(height: 32.h),
//         Center(
//           child: Image.asset(
//             AppImages.applogo,
//             height: 92.h,
//             fit: BoxFit.contain,
//           ),
//         ),
//         SizedBox(height: 22.h),
//         Center(
//           child: Text(
//             'Create Your Account',
//             style: globaltextInterTight(
//               fontSize: 24.sp,
//               fontWeight: FontWeight.w800,
//               color: AppColors.blackColor,
//               lineHeight: 1.1,
//             ),
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Center(
//           child: Text(
//             'Start planning your dream trip today.',
//             style: globaltextInterTight(
//               fontSize: 13.sp,
//               fontWeight: FontWeight.w400,
//               color: AppColors.secondaryColor,
//               lineHeight: 1.2,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _form() {
//     return Form(
//       key: controller.formKey,
//       child: Column(
//         children: [
//           CustomTextFormWidget(
//             sectionTitle: 'FULL NAME',
//             textEditingController: controller.fullNameController,
//             hintText: 'Enter your full Name',
//             keyboardType: TextInputType.name,
//             textInputAction: TextInputAction.next,
//             validator: controller.validateFullName,
//           ),
//           SizedBox(height: 16.h),
//           CustomTextFormWidget(
//             sectionTitle: 'EMAIL',
//             textEditingController: controller.emailController,
//             hintText: 'hello@traveller.com',
//             keyboardType: TextInputType.emailAddress,
//             textInputAction: TextInputAction.next,
//             validator: controller.validateEmail,
//           ),
//           SizedBox(height: 16.h),
//           CustomTextFormWidget(
//             sectionTitle: 'PHONE NUMBER(OPTIONAL)',
//             textEditingController: controller.phoneController,
//             hintText: 'Enter your phone number',
//             keyboardType: TextInputType.phone,
//             textInputAction: TextInputAction.next,
        
//           ),
//           SizedBox(height: 16.h),
//           Obx(
//             () => CustomTextFormWidget(
//               sectionTitle: 'PASSWORD',
//               textEditingController: controller.passwordController,
//               hintText: '••••••••',
//               isPassword: true,
//               isPasswordVisible: controller.isPasswordVisible.value,
//               onTogglePasswordVisibility: controller.togglePasswordVisibility,
//               textInputAction: TextInputAction.done,
//               validator: controller.validatePassword,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Obx(
//             () => Row(
//               children: [
//                 Checkbox(
//                   value: controller.isTermsAgreed.value,
//                   onChanged: (_) => controller.toggleTermsAgreement(),
//                   activeColor: AppColors.authOrange,
//                   side: const BorderSide(color: AppColors.authOrange),
//                 ),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'I agree to the ',
//                           style: globaltextInterTight(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.greyColor,
//                             lineHeight: 1.2,
//                           ),
//                         ),
//                         TextSpan(
//                           text: 'Terms of Service',
//                           style: globaltextInterTight(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.authOrange,
//                             lineHeight: 1.2,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' and ',
//                           style: globaltextInterTight(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.greyColor,
//                             lineHeight: 1.2,
//                           ),
//                         ),
//                         TextSpan(
//                           text: 'Privacy Policy',
//                           style: globaltextInterTight(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.authOrange,
//                             lineHeight: 1.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Obx(
//             () => CustomButtonWidget(
//               label: 'Sign Up',
//               onPressed: controller.onSignupPressed,
//               loading: controller.isSignupLoading.value,
//               fullWidth: true,
//               height: 54.h,
//               radius: 30.r,
//               bgColor: AppColors.authOrange,
//               fgColor: AppColors.whiteColor,
//               textStyle: globaltextInterTight(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.whiteColor,
//                 lineHeight: 1.1,
//               ),
//             ),
//           ),
//           SizedBox(height: 18.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Already have an account? ',
//                 style: globaltextInterTight(
//                   fontSize: 13.sp,
//                   fontWeight: FontWeight.w400,
//                   color: AppColors.greyColor,
//                   lineHeight: 1.2,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Text(
//                   'Log In',
//                   style: globaltextInterTight(
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.authOrange,
//                     lineHeight: 1.2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../../core/widgets/custom_textfield_widget.dart';
import '../controller/5_signup_controller.dart';

class SignupScreen extends GetWidget<SignupController> {
  const SignupScreen({super.key});

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
            'Create Your Account',
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
            'Start planning your dream trip today.',
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
          // Full Name Field
          CustomTextFormWidget(
            sectionTitle: 'FULL NAME',
            textEditingController: controller.fullNameController,
            hintText: 'Enter your full name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: controller.validateFullName,
          ),
          SizedBox(height: 16.h),

          // Email Field
          CustomTextFormWidget(
            sectionTitle: 'EMAIL',
            textEditingController: controller.emailController,
            hintText: 'hello@traveller.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: controller.validateEmail,
          ),
          SizedBox(height: 16.h),

          // Phone Number Field (Optional)
          CustomTextFormWidget(
            sectionTitle: 'PHONE NUMBER (OPTIONAL)',
            textEditingController: controller.phoneController,
            hintText: '+1 (555) 123-4567',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: controller.validatePhoneNumber,
          ),
          SizedBox(height: 16.h),

          // Password Field
          Obx(
            () => CustomTextFormWidget(
              sectionTitle: 'PASSWORD',
              textEditingController: controller.passwordController,
              hintText: '••••••••',
              isPassword: true,
              isPasswordVisible: controller.isPasswordVisible.value,
              onTogglePasswordVisibility: controller.togglePasswordVisibility,
              textInputAction: TextInputAction.done,
              validator: controller.validatePassword,
            ),
          ),
          SizedBox(height: 16.h),

          // Terms & Conditions Checkbox
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: controller.isTermsAgreed.value,
                  onChanged: (_) => controller.toggleTermsAgreement(),
                  activeColor: AppColors.authOrange,
                  side: const BorderSide(color: AppColors.authOrange),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'I agree to the ',
                          style: globaltextInterTight(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyColor,
                            lineHeight: 1.4,
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to Terms of Service
                              // Get.toNamed(AppRoutes.TERMS_OF_SERVICE);
                            },
                            child: Text(
                              'Terms of Service',
                              style: globaltextInterTight(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.authOrange,
                                lineHeight: 1.4,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: globaltextInterTight(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyColor,
                            lineHeight: 1.4,
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to Privacy Policy
                              // Get.toNamed(AppRoutes.PRIVACY_POLICY);
                            },
                            child: Text(
                              'Privacy Policy',
                              style: globaltextInterTight(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.authOrange,
                                lineHeight: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Sign Up Button
          Obx(
            () => CustomButtonWidget(
              label: 'Sign Up',
              onPressed: controller.onSignupPressed,
              loading: controller.isSignupLoading.value,
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

          // Sign In Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                  lineHeight: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Text(
                  'Log In',
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
