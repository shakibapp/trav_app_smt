import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/style/global_text_style.dart';

class TripRemindersSection extends StatelessWidget {
  final String title;
  final String arrivingDate;
  final VoidCallback onBook;

  const TripRemindersSection({
    super.key,
    required this.title,
    required this.arrivingDate,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.authOrange.withValues(alpha: 0.05),
                ),
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  AppIcons.airplane,
                  colorFilter: const ColorFilter.mode(
                    AppColors.authOrange,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: globaltextInterTight(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Arriving $arrivingDate',
                      style: globaltextInterTight(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 80.w,
                height: 36.h,
                child: ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Book',
                    style: globaltextInterTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
