import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/style/global_text_style.dart';
import '../../models/home_trip_model.dart';

class HomeUpcomingTripCard extends StatelessWidget {
  final HomeTripData trip;
  final double? width;
  final double? height;
  final bool showEdit;

  const HomeUpcomingTripCard({
    super.key,
    required this.trip,
    this.width,
    this.height,
    this.showEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 300.w;
    final cardHeight = height ?? 190.h;
    final badgeText = trip.status.trim().isEmpty ? 'Upcoming' : trip.status;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              trip.imageUrl,
              width: double.infinity,
              height: cardHeight,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Container(
            width: double.infinity,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Status badge (always top-left)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 12.h, left: 12.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badgeText,
                  style: globaltextInterTight(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.authOrange,
                  ),
                ),
              ),
            ),
          ),

          // Blurred info panel (matches design)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: globaltextInterTight(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.whiteColor,
                                lineHeight: 1.1,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${trip.startDate} - ${trip.endDate} • ${trip.days} days • Budget: ${trip.budget}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: globaltextInterTight(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.whiteColor,
                                lineHeight: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showEdit) ...[
                        SizedBox(width: 10.w),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16.sp,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
