import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/app_bg.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_alerts/model/parent_alets_model.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widgets/network_image.dart';
import '../../../../routes/app_routes.dart';
import '../../../general_user_flow/profile/controller/profile_controller.dart';
import '../controller/parent_home_controller.dart';

class ParentHomeScreen extends GetView<ParentHomeController> {
  ParentHomeScreen({super.key});
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already
    if (!Get.isRegistered<ParentHomeController>()) {
      Get.put(ParentHomeController());
    }

    return BackgroundScreen(
      bgImg: AppImages.tripBgLight,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),

            _buildGreetingSection(profileController),

            Text(
              "Stay Connected",
              style: globalTextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Quick updates about Hamish's trip.",
              style: globalTextStyle(
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 20.h),
            // Gradient Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  colors: [AppColors.authOrange, AppColors.authOrangeDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: const DecorationImage(
                  image: AssetImage(
                    AppImages.applogo,
                  ), // Subtle pattern overlap maybe?
                  opacity: 0.1,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Text(
                      "Currently in ${controller.isParentHomeLoading.value ? "" : controller.parentHomeModel.value.currentCity ?? "N/A"}",
                      style: globalTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    );
                  }),
                  SizedBox(height: 4.h),
                  Obx(() {
                    String formattedTime = "N/A";

                    if (!controller.isParentHomeLoading.value &&
                        controller.parentHomeModel.value.checkedInAt != null) {
                      try {
                        final date = DateTime.parse(
                          controller.parentHomeModel.value.checkedInAt!,
                        ).toLocal();

                        formattedTime = DateFormat('h:mm a').format(date);
                      } catch (e) {
                        formattedTime = "N/A";
                      }
                    }

                    return Text(
                      "Checked in at accommodation . $formattedTime",
                      style: globalTextStyle(
                        fontSize: 12.sp,
                        color: AppColors.whiteColor.withOpacity(0.9),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Quick Actions
            Obx(() {
              final data = controller.parentHomeModel.value;

              return controller.isParentHomeLoading.value
                  ? _buildCardShimmer()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionCard(
                          icon: AppIcons.routeIcon,
                          title: "Location",
                          subtitle: data.currentCity ?? "",
                        ),
                        _buildActionCard(
                          icon: AppIcons.airplane,
                          title: "Flight",
                          subtitle: data.nextTransport?.label ?? "No Flight",
                        ),
                        _buildActionCard(
                          icon: AppIcons.hotel,
                          title: "Checked In",
                          subtitle: data.nextTransport?.type ?? "Not Available",
                        ),
                      ],
                    );
            }),
            SizedBox(height: 30.h),

            Text(
              "Recent Updates",
              style: globalTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            Obx(() {
              if (controller.isAlertsLoading.value) {
                return _buildAlertShimmer();
              }
              if (controller.alerts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      "No recent updates.",
                      style: globalTextStyle(
                        fontSize: 13.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.alerts.length,
                itemBuilder: (context, index) {
                  final alert = controller.alerts[index];
                  return _buildAlertItem(alert);
                },
              );
            }),
            SizedBox(height: 100.h), // Bottom padding for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(ParentAlertModel alert) {
    // Map alert type → icon + color
    IconData icon;
    Color iconColor;

    switch (alert.type) {
      case 'Flight_Delayed':
        icon = Icons.flight_takeoff;
        iconColor = Colors.orange;
        break;
      case 'Flight_Cancelled':
        icon = Icons.flight_land;
        iconColor = Colors.red;
        break;
      case 'CheckIn':
        icon = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case 'Hotel':
        icon = Icons.hotel;
        iconColor = Colors.blue;
        break;
      default:
        icon = Icons.notifications_outlined;
        iconColor = Colors.orange;
    }

    // Format time from createdAt
    String formattedTime = '';
    if (alert.createdAt != null) {
      final local = alert.createdAt!.toLocal();
      final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
      final minute = local.minute.toString().padLeft(2, '0');
      final period = local.hour >= 12 ? 'PM' : 'AM';
      formattedTime = '$hour:$minute $period';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12.r),
        border: alert.isUnread
            ? Border.all(color: AppColors.authOrange.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.summary ?? '',
                        style: globalTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (alert.isUnread)
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: AppColors.authOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  alert.detail ?? '',
                  style: globalTextStyle(
                    fontSize: 11.sp,
                    color: AppColors.greyColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            formattedTime,
            style: globalTextStyle(
              fontSize: 11.sp,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        log("message");
      },
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 24.w,
              height: 24.w,
              color: Colors.black,
              errorBuilder: (c, e, s) => Icon(
                Icons.location_on,
                size: 24.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: globalTextStyle(
                fontSize: 10.sp,
                color: AppColors.greyColor,
              ),
            ),
            Text(
              subtitle,
              style: globalTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: globalTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: globalTextStyle(
                    fontSize: 11.sp,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: globalTextStyle(fontSize: 11.sp, color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 14.h),
      child: Obx(() {
        if (controller.isUserProfileLoading.value) {
          return _buildGreetingShimmer();
        } else {
          final user = controller.userProfile.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.PROFILE_ACCOUNT),
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE9E9EF),
                      ),
                      child: Center(
                        child: AppNetworkImage(
                          height: 40,
                          width: 40,
                          borderRadius: BorderRadius.circular(100),
                          imageUrl: user!.profileImage.toString(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user.fullName}',
                        style: globaltextInterTight(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        getGreeting(),
                        style: globaltextInterTight(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
      }),
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  Widget _buildCardShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        3,
        (index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 50.w,
                  height: 10.h,
                  color: Colors.white,
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 70.w,
                  height: 12.h,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertShimmer() {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 12.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 150.w,
                          height: 10.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.w,
                height: 10.h,
                color: Colors.white,
              ),
              SizedBox(height: 8.h),
              Container(
                width: 140.w,
                height: 14.h,
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}
