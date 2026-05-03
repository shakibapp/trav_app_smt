
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountShimmer extends StatelessWidget {
  const AccountShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),

          /// Profile Image shimmer
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          SizedBox(height: 30.h),

          /// Fields shimmer
          _buildBox(),
          SizedBox(height: 16.h),
          _buildBox(),
          SizedBox(height: 16.h),
          _buildBox(),
          SizedBox(height: 16.h),
          _buildBox(),

          SizedBox(height: 30.h),

          /// Button shimmer
          _buildBox(height: 50.h),
        ],
      ),
    );
  }

  Widget _buildBox({double? height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height ?? 55.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}