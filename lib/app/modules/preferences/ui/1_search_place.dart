import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/style/global_text_style.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../controller/1_preferences_controller.dart';
import '2_about_you.dart';

class PreferencesSearchPlaceScreen extends GetView<PreferencesController> {
  const PreferencesSearchPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = const [
      (
        title: 'Organize Destinations',
        subtitle: 'Keep all your stops in a place',
        icon: Icons.map_outlined,
      ),
      (
        title: 'Track Booking',
        subtitle: 'Flights, hotels and activities.',
        icon: Icons.calendar_month_outlined,
      ),
      (
        title: 'Plan your route',
        subtitle: 'optimize your itinerary.',
        icon: Icons.alt_route_rounded,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              // Text(
              //   'Search Place',
              //   style: globaltextInterTight(
              //     fontSize: 13.sp,
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.secondaryColor,
              //     lineHeight: 1.2,
              //   ),
              // ),
              SizedBox(height: 14.h),
              Text(
                'Plan trips with\nconfidence',
                style: globaltextInterTight(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                  lineHeight: 1.05,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Keep your travel plans organized, from first idea\nto final boarding pass.',
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryColor,
                  lineHeight: 1.4,
                ),
              ),
              SizedBox(height: 18.h),
              Obx(
                () => Column(
                  children: [
                    for (int i = 0; i < features.length; i++) ...[
                      _featureCard(
                        title: features[i].title,
                        subtitle: features[i].subtitle,
                        icon: features[i].icon,
                        selected:
                            controller.selectedFeature.value ==
                            features[i].title,
                        onTap: () => controller.setFeature(features[i].title),
                      ),
                      if (i != features.length - 1) SizedBox(height: 12.h),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              Obx(() {
                final enabled = controller.canContinueStep1;
                return CustomButtonWidget(
                  label: 'Get Started',
                  onPressed: enabled
                      ? () => Get.to(() => const PreferencesAboutYouScreen())
                      : null,
                  fullWidth: true,
                  height: 54.h,
                  radius: 30.r,
                  bgColor: enabled
                      ? AppColors.authOrange
                      : AppColors.authOrange.withValues(alpha: 0.45),
                  fgColor: AppColors.whiteColor,
                  textStyle: globaltextInterTight(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                    lineHeight: 1.1,
                  ),
                );
              }),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.authOrange : AppColors.authFieldBorder,
            width: selected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.authOrange.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 18.sp, color: AppColors.authOrange),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: globaltextInterTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                      lineHeight: 1.1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: globaltextInterTight(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryColor,
                      lineHeight: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.authOrange : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.authOrange
                      : AppColors.authFieldBorder,
                  width: 1.3,
                ),
              ),
              child: selected
                  ? Icon(Icons.circle, size: 8.sp, color: AppColors.whiteColor)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
