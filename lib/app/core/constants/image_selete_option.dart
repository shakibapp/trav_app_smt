
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';



void showImageOptions({
  required BuildContext context,
  required VoidCallback onCamera,
  required VoidCallback onGallery,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Select Profile Picture',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              _buildImageOption(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap:onCamera,
              ),
              _buildImageOption(
                context,
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: onGallery,
              ),
            ],
          ),


          SizedBox(height: 20.h),
        ],
      ),
    ),
  );
}

Widget _buildImageOption(
    BuildContext context, {
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color? color,
    }) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: (color ?? AppColors.primaryColor).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30.sp,
            color: color ?? AppColors.primaryColor,
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}