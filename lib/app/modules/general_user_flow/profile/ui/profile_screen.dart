import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/style/global_text_style.dart';
import '../controller/profile_controller.dart';
import 'widgets/profile_menu_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            Text(
              'Profile',
              style: globaltextInterTight(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 18.h),
            _header(),
            SizedBox(height: 18.h),
            _menu(),
            SizedBox(height: 22.h),
            _logout(),
            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Obx(() {
      final name = controller.fullName.value;
      final email = controller.email.value;
      final img = controller.imageUrl.value;

      return Center(
        child: Column(
          children: [
            Container(
              width: 62.w,
              height: 62.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE9E9EF),
                image: img.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(img),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: img.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 26.sp,
                      color: AppColors.secondaryColor,
                    )
                  : null,
            ),
            SizedBox(height: 10.h),
            Text(
              name,
              style: globaltextInterTight(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mail_outline_rounded,
                  size: 14.sp,
                  color: AppColors.secondaryColor,
                ),
                SizedBox(width: 6.w),
                Text(
                  email,
                  style: globaltextInterTight(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _menu() {
    return Column(
      children: [
        ProfileMenuTile(
          icon: Icons.person_outline_rounded,
          title: 'Account',
          onTap: controller.onAccountTap,
        ),
        SizedBox(height: 10.h),
        ProfileMenuTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          onTap: controller.onNotificationsTap,
        ),
        SizedBox(height: 10.h),
        ProfileMenuTile(
          icon: Icons.group_outlined,
          title: 'Parents',
          onTap: controller.onParentsTap,
        ),
        SizedBox(height: 10.h),
        ProfileMenuTile(
          icon: Icons.shield_outlined,
          title: 'Privacy',
          onTap: controller.onPrivacyTap,
        ),
        SizedBox(height: 10.h),
        ProfileMenuTile(
          icon: Icons.description_outlined,
          title: 'Terms of Use',
          onTap: controller.onTermsOfUseTap,
        ),
      ],
    );
  }

  Widget _logout() {
    return InkWell(
      onTap: controller.onLogoutTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              size: 20.sp,
              color: const Color(0xFFEF4444),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Log Out',
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: const Color(0xFFEF4444),
            ),
          ],
        ),
      ),
    );
  }
}
