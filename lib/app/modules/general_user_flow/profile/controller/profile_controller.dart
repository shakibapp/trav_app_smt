import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/local_data.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final fullName = ''.obs;
  final email = ''.obs;
  final imageUrl = ''.obs; // will come from API later

  @override
  void onInit() {
    super.onInit();
    loadLocalProfile();
  }

  void loadLocalProfile() {
    fullName.value = LocalService.localService.getName() ?? 'Hamish Phipps';
    email.value = LocalService.localService.getEmail() ?? 'demo@gmail.com';
    // imageUrl.value = 'https://...'; // set from API later
  }

  // Actions (wire navigation later)
  void onAccountTap() {
    Get.toNamed(AppRoutes.PROFILE_ACCOUNT);
  }

  void onNotificationsTap() {
    Get.toNamed(AppRoutes.PROFILE_NOTIFICATION);
  }

  void onParentsTap() {}

  void onPrivacyTap() {}

  void onTermsOfUseTap() {}

  void onDeleteAccountTap() {}

  Future<void> onLogoutTap() async {
    _showLogoutDialog();
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppIcons.logout,
                width: 60.w,
                height: 60.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFEF4444),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Logout',
                style: globaltextInterTight(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.secondaryColor.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: globaltextInterTight(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Get.back();
                        await LocalService.localService.clearUserData();
                        Get.offAllNamed(AppRoutes.LOGIN);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: globaltextInterTight(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
