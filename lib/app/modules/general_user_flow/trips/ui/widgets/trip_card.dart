import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/view/tripItinerary_overview_screen.dart';

import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/view/trip_details_screen.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/network_image.dart';
import '../../models/trip_model.dart';

class TripCard extends StatelessWidget {
  final AllTripDataModel trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    // Format dates
    final startDate = DateFormat(
      'MMM dd',
    ).format(DateTime.parse(trip.startDate.toString()));
    final endDate = DateFormat(
      'MMM dd yyyy',
    ).format(DateTime.parse(trip.endDate.toString()));

  
    return GestureDetector(
      
      onTap: () => Get.to(TripDetailsScreen(tripId: trip.id.toString(),)),
      child: Container(
        height: 220.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Background Image — PageView সরিয়ে SizedBox দিয়ে wrap করো
              SizedBox(
                width: double.infinity,
                height: 220.h,
                child: trip.images != null && trip.images!.isNotEmpty
                    ? PageView.builder(
                  itemCount: trip.images!.length,
                  itemBuilder: (_, imgIndex) {
                    return AppNetworkImage(
                      imageUrl: trip.images![imgIndex] ??
                          "https://media.cntraveller.com/photos/66dab99cca79963e5f03ff9d/16:9/w_2560%2Cc_limit/GettyImages-1588291549.jpg",
                      width: double.infinity,
                      height: 220.h,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : AppNetworkImage(
                  imageUrl:
                  "https://media.cntraveller.com/photos/66dab99cca79963e5f03ff9d/16:9/w_2560%2Cc_limit/GettyImages-1588291549.jpg",
                  width: double.infinity,
                  height: 220.h,
                  fit: BoxFit.cover,
                ),
              ),

              // Shadow only at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 130.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.92),
                      ],
                    ),
                  ),
                ),
              ),

              // Text content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        trip.city!.join(', '),
                        style: globaltextInterTight(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor,
                          lineHeight: 1.2,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: 'assets/icons/trip_calendar.svg',
                            label: '$startDate - $endDate',
                          ),
                          SizedBox(width: 8.w),
                          _buildInfoChip(
                            icon: 'assets/icons/trip_calendar.svg',
                            label: '${trip.totalDays} Days',
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: 'assets/icons/trip_dollar.svg',
                            label: '\$${trip.budget}',
                          ),
                          SizedBox(width: 5.w),
                          _buildInfoChip(
                            icon: 'assets/icons/home_outline.svg',
                            label: trip.interests!.join(', '),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required String icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 14.sp,
            height: 14.sp,
            colorFilter: const ColorFilter.mode(
              AppColors.whiteColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          SizedBox(
            width: 120,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: globaltextInterTight(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
                lineHeight: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
