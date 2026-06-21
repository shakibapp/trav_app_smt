import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/style/global_text_style.dart';
import '../../../../../core/widgets/custom_button_widget.dart';

class HomePlanTripSection extends StatelessWidget {
  final VoidCallback onCreateTrip;

  const HomePlanTripSection({super.key, required this.onCreateTrip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Text(
          'Plan a New Trip',
          style: globaltextInterTight(
            fontSize: 28.sp,
            color: AppColors.blackColor,
            lineHeight: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        // Subtitle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Let AI create a personalized itinerary for your next adventure.',
            textAlign: TextAlign.center,
            style: globaltextInterTight(
              fontSize: 14.sp,
              color: AppColors.blackColor.withAlpha(100),
              lineHeight: 1.5,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        // Icon with light background
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.authOrange.withValues(alpha: 0.1),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppImages.homeTravel,
              width: 70.w,
              height: 70.w,
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Create Trip Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomButtonWidget(
            label: 'Create Trip',
            onPressed: onCreateTrip,
            fullWidth: true,
            height: 54.h,
            // radius: 30.r,
            bgColor: AppColors.authOrange,
            leading: Icon(Icons.add, color: AppColors.whiteColor),
          ),
        ),
        SizedBox(height: 20.h),

        // Share with Parents Card
        SizedBox(height: 40.h),
      ],
    );
  }
}
