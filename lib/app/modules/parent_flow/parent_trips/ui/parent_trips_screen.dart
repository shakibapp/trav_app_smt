// parent_trips_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_images.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';
import 'package:hamishphipps/app/core/widgets/app_bg.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_trips/controller/parent_trip_overview.dart';

import 'package:hamishphipps/app/modules/parent_flow/parent_trips/model/trip_overview_model.dart';

class ParentTripsScreen extends StatelessWidget {
  const ParentTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ParentTripOverviewController());

    return BackgroundScreen(
      bgImg: AppImages.tripBgLight,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Text(
              "Trip Overview",
              style: globalTextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "A quick look at the journey.",
              style: globalTextStyle(
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 30.h),

            // Full Route Card
            Obx(() {
              if (controller.isTripOverViewLoadin.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final routes = controller.tripOverView.value.route ?? [];

              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFBFB),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Full Route",
                          style: globalTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.close,
                          size: 20.sp,
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    if (routes.isEmpty)
                      Center(
                        child: Text(
                          "No route data available",
                          style: globalTextStyle(
                            fontSize: 14.sp,
                            color: AppColors.greyColor,
                          ),
                        ),
                      )
                    else
                      ...routes.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final TripRoute route =
                            entry.value; // ✅ Route → TripRoute

                        final bool isFirst = index == 0;
                        final bool isLast = index == routes.length - 1;

                        return _buildTimelineItem(
                          title: route.city ?? "-",
                          status: route.status,
                          days: route.days,
                          isFirst: isFirst,
                          isLast: isLast,
                        );
                      }),
                  ],
                ),
              );
            }),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required TripStatus status,
    int? days,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: status.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          SizedBox(width: 15.w),
          Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: globalTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: status.textColor,
                  ),
                ),
                Text(
                  status.label,
                  style: globalTextStyle(
                    fontSize: 12.sp,
                    color: AppColors.greyColor,
                  ),
                ),
                if (days != null)
                  Text(
                    "$days days",
                    style: globalTextStyle(
                      fontSize: 11.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
