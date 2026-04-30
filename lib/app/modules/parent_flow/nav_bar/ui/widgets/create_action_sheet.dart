import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/style/global_text_style.dart';
import '../../controller/parent_nav_bar_controller.dart';

class CreateActionSheet extends StatelessWidget {
  const CreateActionSheet({super.key, required this.actions});

  final List<ParentNavBarCreateAction> actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create',
              style: globaltextInterTight(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 12.h),
            for (int i = 0; i < actions.length; i++) ...[
              _SheetActionTile(action: actions[i]),
              if (i != actions.length - 1) SizedBox(height: 10.h),
            ],
          ],
        ),
      ),
    );
  }
}

class _SheetActionTile extends StatelessWidget {
  const _SheetActionTile({required this.action});

  final ParentNavBarCreateAction action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
        action.onTap();
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.authFieldBorder, width: 1.4),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: AppColors.authOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                action.icon,
                color: AppColors.authOrange,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                action.title,
                style: globaltextInterTight(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.secondaryColor,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
