import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/style/global_text_style.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    this.icon,
    this.iconPath,
    required this.title,
    required this.onTap,
  }) : assert(
         icon != null || iconPath != null,
         'Either icon or iconPath must be provided',
       );

  final IconData? icon;
  final String? iconPath;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(
                  AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              )
            else if (icon != null)
              Icon(icon, size: 20.sp, color: AppColors.blackColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: globaltextInterTight(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: AppColors.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
