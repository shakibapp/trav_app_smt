import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/style/global_text_style.dart';
import '../controller/trips_controller.dart';
import 'widgets/trip_card.dart';

class TripsScreen extends GetView<TripsController> {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              // Header
              Text(
                'Trips',
                style: globaltextInterTight(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                  lineHeight: 1.05,
                ),
              ),
              SizedBox(height: 10.h),
              // Tab Bar
              _buildTabBar(),
              SizedBox(height: 10.h),
              // Trips List
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trips = controller.currentTrips;
                if (trips.isEmpty) {
                  return Center(
                    child: Lottie.asset(
                      AppAnimations.emptyTrips,
                      width: 250.w,
                      height: 250.h,
                      fit: BoxFit.contain,
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: TripCard(trip: trips[index]),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTabButton('Ongoing', 0),
              SizedBox(width: 8.w),
              _buildTabButton('Upcoming', 1),
              SizedBox(width: 8.w),
              _buildTabButton('Completed', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isActive = controller.selectedTabIndex.value == index;
    return GestureDetector(
      onTap: () => controller.selectTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.authOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          label,
          style: globaltextInterTight(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.whiteColor : AppColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}
