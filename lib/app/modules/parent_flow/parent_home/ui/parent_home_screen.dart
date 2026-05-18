import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/app_bg.dart';
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
            // Header
            // Row(
            //   children: [
            //     CircleAvatar(
            //       radius: 24.r,
            //       backgroundImage: AssetImage(AppImages.tripBg),
            //     ),
            //     SizedBox(width: 12.w),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Hello, Hamish!",
            //           style: globalTextStyle(
            //             fontSize: 12.sp,
            //             color: AppColors.greyColor,
            //           ),
            //         ),
            //         Text(
            //           "Good Morning!",
            //           style: globalTextStyle(
            //             fontSize: 18.sp,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            _buildGreetingSection(profileController),
            //SizedBox(height: 10.h),
            // Stay Connected Title
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
                  Text(
                    "Currently in Rome",
                    style: globalTextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Checked in at accommodation . 2:45 PM",
                    style: globalTextStyle(
                      fontSize: 12.sp,
                      color: AppColors.whiteColor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionCard(
                  icon: AppIcons.routeIcon,
                  title: "Location",
                  subtitle: "Rome",
                ),
                _buildActionCard(
                  icon: AppIcons.airplane,
                  title: "Flight",
                  subtitle: "In 2 hrs",
                ),
                _buildActionCard(
                  icon: AppIcons.hotel,
                  title: "Checked In",
                  subtitle: "Hotel",
                ),
              ],
            ),
            SizedBox(height: 30.h),
            // Recent Updates
            Text(
              "Recent Updates",
              style: globalTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            _buildUpdateItem(
              icon: Icons.check_circle_outline,
              iconColor: Colors.orange,
              title: "Checked in successfully",
              subtitle: "Accomodation - Rome",
              time: "2:45 PM",
            ),
            _buildUpdateItem(
              icon: Icons.flight_takeoff,
              iconColor: Colors.orange,
              title: "Arrived in airport",
              subtitle: "Melbourne - Venice (Today)",
              time: "2:45 PM",
            ),
            _buildUpdateItem(
              icon: Icons.flight_land,
              iconColor: Colors.orange,
              title: "Arrived in Rome safely.",
              subtitle: "Flight landed safely.",
              time: "2:45 PM",
            ),
            SizedBox(height: 100.h), // Bottom padding for nav bar
          ],
        ),
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
           return CircularProgressIndicator();
         } else {
           final user = controller.userProfile.value;
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   GestureDetector(
                     onTap: ()=>Get.toNamed(AppRoutes.PROFILE_ACCOUNT),
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
}
