import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/style/global_text_style.dart';

class HomeHorizontalCardSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> cards;
  final double? listHeight;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const HomeHorizontalCardSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.cards,
    this.listHeight,
    this.padding = EdgeInsets.zero,
    this.spacing = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: globaltextInterTight(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.blackColor,
              lineHeight: 1.1,
            ),
          ),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              subtitle!,
              style: globaltextInterTight(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor.withAlpha(150),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          SizedBox(
            height: listHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, __) => SizedBox(width: spacing.w),
              itemBuilder: (_, index) => cards[index],
            ),
          ),
        ],
      ),
    );
  }
}
