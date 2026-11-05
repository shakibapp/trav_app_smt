import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/riverpod-version/features/auth/signup/presentation/signup_screen.dart';
import 'provider/login_notifier.dart';

// ============================================================================
// [LoginScreen] - RIVERPOD CONSUMER STATEFUL WIDGET
// ============================================================================
// কেন ConsumerStatefulWidget?
// 
// ১. TextEditingController এবং FormState dispose করার জন্য StatefulWidget দরকার।
// ২. Riverpod এর `ref` অবজেক্ট ক্লাসের সর্বত্র সরাসরি ব্যবহার করা যায়
//    (যেমন: build মেথডে `ref.watch`, ইভেন্টে `ref.read`, এবং লিসেনারে `ref.listen`)।
// ৩. GetX এর `Obx()` এর বদলে এখানে শুধু `ref.watch()` করলেই স্টেট পরিবর্তনের সাথে সাথে
//    UI অটোমেটিক রি-রেন্ডার হয়।
// ============================================================================

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // মেমোরি লিক রোধ করার জন্য কন্ট্রোলার ডিসপোজ করা অত্যন্ত জরুরি
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  /// সাবমিট অ্যাকশন
  void _onLoginPressed() {
    // কিবোর্ড বন্ধ করা
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      // ref.read: বাটন ক্লিকের মতো ইভেন্টে শুধুমাত্র একবার অ্যাকশন ট্রিগার করতে ref.read ব্যবহার হয়
      ref.read(loginNotifierProvider.notifier).submitLogin(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ১. ref.watch: স্টেট পরিবর্তন হলে উইজেট রি-বিল্ড করার জন্য
    final loginState = ref.watch(loginNotifierProvider);

    // ২. ref.listen: সাইড ইফেক্ট (যেমন SnackBar, Dialog, Navigation) হ্যান্ডেল করতে
    // এটি বিল্ড সাইকেলের অংশ নয়, স্টেট বদলালেই কেবল ফায়ার হয়।
    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      // এরর মেসেজ দেখালে
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // সাকসেস হলে নেভিগেশন
      if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // এখানে রাউট অনুযায়ী নেভিগেট করতে পারবেন
        // উদাহরণ:
        // if (next.userSession?.role == 'PARENT') { ... }
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

                // লোগো সেকশন
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

                // হেডার টাইটেল
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
                SizedBox(height: 36.h),

                // ইমেইল ইনপুট ফিল্ড
                _buildFieldLabel('EMAIL'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    hintText: 'hello@traveller.com',
                    filled: true,
                    fillColor: AppColors.authFieldFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.authFieldBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.authFieldBorder),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // পাসওয়ার্ড ইনপুট ফিল্ড
                _buildFieldLabel('PASSWORD'),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !loginState.isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  onFieldSubmitted: (_) => _onLoginPressed(),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    filled: true,
                    fillColor: AppColors.authFieldFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.authFieldBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.authFieldBorder),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginState.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.secondaryColor,
                      ),
                      onPressed: () {
                        ref
                            .read(loginNotifierProvider.notifier)
                            .togglePasswordVisibility();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 28.h),

                // সাবমিট বাটন
                SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: loginState.isLoading ? null : _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: loginState.isLoading
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
                            'Sign In',
                            style: globaltextInterTight(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24.h),

                // অ্যাকাউন্ট নেই? সাইনআপ করুন
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: globaltextInterTight(
                        fontSize: 13.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
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
