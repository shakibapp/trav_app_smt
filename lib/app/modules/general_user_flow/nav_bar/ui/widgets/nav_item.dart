import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    final assetPath = selected ? data.filledAssetPath : data.outlineAssetPath;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetPath.isNotEmpty)
            SvgPicture.asset(
              assetPath,
              width: 22.sp,
              height: 22.sp,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          else
            SizedBox(height: 22.sp, width: 22.sp),
          SizedBox(height: 3.h),
          Text(
            data.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: globaltextInterTight(
              fontSize: 11.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
