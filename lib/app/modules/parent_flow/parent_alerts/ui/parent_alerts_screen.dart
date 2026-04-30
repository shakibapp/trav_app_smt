import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/app_bg.dart';

class ParentAlertsScreen extends StatelessWidget {
  const ParentAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScreen(
      bgImg: AppImages.tripBgLight,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Text(
              "Alerts & Updates",
              style: globalTextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Stay in the loop with everything.",
              style: globalTextStyle(
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 30.h),
            // Expanded Alert item
            _buildDetailedAlert(
              icon: Icons.error_outline,
              title: "Not arrived in Airport yet.",
              subtitle: "Expected check-in has not been confirmed.",
              time: "2:45 PM",
              reason: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.",
            ),
            SizedBox(height: 15.h),
            _buildSimpleAlert(
              icon: Icons.check_circle_outline,
              title: "Checked in successfully",
              subtitle: "Accomodation - Rome",
              time: "2:45 PM",
            ),
            SizedBox(height: 15.h),
            _buildSimpleAlert(
              icon: Icons.flight_takeoff,
              title: "Arrived in airport",
              subtitle: "Melbourne - Venice (Today)",
              time: "2:45 PM",
            ),
            SizedBox(height: 15.h),
            _buildSimpleAlert(
              icon: Icons.flight_land,
              title: "Arrived in Rome safely.",
              subtitle: "Flight landed safely.",
              time: "2:45 PM",
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAlert({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required String reason,
  }) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.orange, size: 20.sp),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: globalTextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: globalTextStyle(fontSize: 11.sp, color: AppColors.greyColor),
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
          SizedBox(height: 15.h),
          Divider(color: Colors.grey.shade200),
          SizedBox(height: 10.h),
          Text(
            "View Reason",
            style: globalTextStyle(fontSize: 12.sp, color: AppColors.greyColor),
          ),
          SizedBox(height: 5.h),
          Text(
            reason,
            style: globalTextStyle(
              fontSize: 11.sp,
              color: Colors.orange.shade700,
              lineHeight: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAlert({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.orange, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: globalTextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: globalTextStyle(fontSize: 11.sp, color: AppColors.greyColor),
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
}
