import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/profile/model/user_profile_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/local_data.dart';
import '../../../../core/style/global_text_style.dart';
import '../../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

  final fullName = ''.obs;
  final email = ''.obs;
  final imageUrl = ''.obs; // will come from API later

  @override
  void onInit() {
    super.onInit();
    loadLocalProfile();
    getUserProfile();
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

  void onParentsTap() {
    Get.toNamed(AppRoutes.PROFILE_PARENTS);
  }

  void onPrivacyTap() {}

  void onTermsOfUseTap() {}

  Future<void> onDeleteAccountTap() async {
    // Show confirmation dialog before deleting account
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Delete',
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      // Call API to delete account
      try {
        final response = await networkConfig.ApiRequestHandler(
          RequestMethod.DELETE,
          "${Urls.deleteAccount}${LocalService.localService.getUserId() ?? ""}",
          {},
          is_auth: true,
        );
        if (response != null && response['success'] == true) {
          AppToast.showSuccess('Account deleted successfully');
          await localService.clearUserData();
          Get.offAllNamed(AppRoutes.LOGIN);
        } else {
          log(
            'Failed to delete account: ${response?["message"] ?? "Unknown error"}',
          );
          AppToast.showError(
            'Failed to delete account. Please try again later.',
          );
        }
      } catch (e) {
        log('Error deleting account: $e');
        AppToast.showError(
          'An error occurred while deleting your account. Please try again later.',
        );
      }
    }
  }

  // get user profile
  final RxBool isUserProfileLoading = false.obs;
  final Rxn<UserProfileModel> userProfile = Rxn<UserProfileModel>();
  Future<void> getUserProfile() async {
    try {
      isUserProfileLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.userProfile,
        {},
        is_auth: true,
      );
      if (response != null && response["success"] == true) {
        userProfile.value = UserProfileModel.fromJson(response["data"]);
        log("get user profile success: ${response["message"]}");
      } else {
        log(
          "get user profile failed: ${response?["message"] ?? "Unknown error"}",
        );
      }
    } catch (e) {
      log("get user profile error: $e");
    } finally {
      isUserProfileLoading.value = false;
    }
  }

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
                        Get.offNamed(AppRoutes.LOGIN);
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
