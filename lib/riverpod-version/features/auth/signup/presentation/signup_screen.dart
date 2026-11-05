import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'provider/signup_notifier.dart';

// ============================================================================
// [SignupScreen] - RIVERPOD CONSUMER STATEFUL WIDGET
// ============================================================================
// ConsumerStatefulWidget ব্যবহারের মাধ্যমে:
// ১. কন্ট্রোলারগুলো সুন্দরভাবে dispose করা যায় যাতে মেমোরি লিক না হয়।
// ২. `ref.watch` দিয়ে স্টেট লিসেন করে UI রি-রেন্ডার করা হয়।
// ৩. `ref.listen` দিয়ে সাকসেস বা এরর ডায়ালগ / স্ন্যাকবার দেখানো হয়।
// ============================================================================

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// নাম ভ্যালিডেশন
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Full name must be at least 3 characters';
    }
    return null;
  }

  /// ইমেইল ভ্যালিডেশন
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// পাসওয়ার্ড ভ্যালিডেশন
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// সাইনআপ বাটন অ্যাকশন
  void _onSignupPressed() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      ref.read(signupNotifierProvider.notifier).submitSignup(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupNotifierProvider);

    // সাইড ইফেক্ট লিসেনার (SnackBar এবং স্ক্রিন নেভিগেশন)
    ref.listen<SignupState>(signupNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successData?.message ?? 'Account created successfully!'),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // সফল হওয়ার পর লগইন স্ক্রিনে ফিরে যাওয়া
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 32.h),

                // লোগো
                Center(
                  child: Image.asset(
                    AppImages.applogo,
                    height: 92.h,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.flight_takeoff,
                      size: 72.h,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 22.h),

                // হেডার
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
                SizedBox(height: 32.h),

                // নাম ইনপুট
                _buildFieldLabel('FULL NAME'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: _validateFullName,
                  decoration: _buildInputDecoration(hint: 'John Doe'),
                ),
                SizedBox(height: 16.h),

                // ইমেইল ইনপুট
                _buildFieldLabel('EMAIL'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  decoration: _buildInputDecoration(hint: 'hello@traveller.com'),
                ),
                SizedBox(height: 16.h),

                // পাসওয়ার্ড ইনপুট
                _buildFieldLabel('PASSWORD'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !signupState.isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  onFieldSubmitted: (_) => _onSignupPressed(),
                  decoration: _buildInputDecoration(
                    hint: '••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        signupState.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.secondaryColor,
                      ),
                      onPressed: () {
                        ref
                            .read(signupNotifierProvider.notifier)
                            .togglePasswordVisibility();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // শর্তাবলি চেকবক্স
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: Checkbox(
                        value: signupState.isTermsAgreed,
                        activeColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        onChanged: (_) {
                          ref
                              .read(signupNotifierProvider.notifier)
                              .toggleTermsAgreement();
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(signupNotifierProvider.notifier)
                              .toggleTermsAgreement();
                        },
                        child: Text(
                          'I agree to the Terms of Service & Privacy Policy',
                          style: globaltextInterTight(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),

                // সাইনআপ বাটন
                SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: signupState.isLoading ? null : _onSignupPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: signupState.isLoading
                        ? SizedBox(
                            height: 22.h,
                            width: 22.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Sign Up',
                            style: globaltextInterTight(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24.h),

                // অলরেডি অ্যাকাউন্ট আছে? লগইন করুন
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: globaltextInterTight(
                        fontSize: 13.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: globaltextInterTight(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.authFieldFill,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.authFieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.authFieldBorder),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: globaltextInterTight(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.blackColor,
      ),
    );
  }
}
