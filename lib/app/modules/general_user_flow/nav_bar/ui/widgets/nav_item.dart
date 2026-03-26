import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/style/global_text_style.dart';
import '../../controller/nav_bar_controller.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final NavBarItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Colors.white
        : Colors.white.withValues(alpha: 0.65);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, color: color, size: 22.sp),
            SizedBox(height: 3.h),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: globaltextInterTight(
                fontSize: 11.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
                lineHeight: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
