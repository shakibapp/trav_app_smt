import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/nav_bar_controller.dart';
import 'nav_item.dart';

class TravBottomNavBar extends StatelessWidget {
  const TravBottomNavBar({
    super.key,
    required this.selectedIndexRx,
    required this.items,
    required this.onItemTap,
  });

  final RxInt selectedIndexRx;
  final List<NavBarItemData> items;
  final ValueChanged<int> onItemTap;

  static const _bg = Color(0xFF3A3A3A);

  @override
  Widget build(BuildContext context) {
    final barHeight = 62.h;

    // Floating center button config
    final fabSize = 58.w;
    final notchSize = 78.w;
    final centerGap = fabSize + 4.w;
    final floatOffset = 10.h; // how much the fab sits into the pill

    return SizedBox(
      height: barHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: barHeight,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Obx(() {
              final selected = selectedIndexRx.value;
              return Row(
                children: [
                  Expanded(
                    child: NavItem(
                      data: items[0],
                      selected: selected == items[0].index,
                      onTap: () => onItemTap(items[0].index),
                    ),
                  ),
                  Expanded(
                    child: NavItem(
                      data: items[1],
                      selected: selected == items[1].index,
                      onTap: () => onItemTap(items[1].index),
                    ),
                  ),
                  SizedBox(width: centerGap),
                  Expanded(
                    child: NavItem(
                      data: items[3],
                      selected: selected == items[3].index,
                      onTap: () => onItemTap(items[3].index),
                    ),
                  ),
                  Expanded(
                    child: NavItem(
                      data: items[4],
                      selected: selected == items[4].index,
                      onTap: () => onItemTap(items[4].index),
                    ),
                  ),
                ],
              );
            }),
          ),
          // notch (cuts the pill behind the center button)
          Positioned(
            top: -(notchSize / 2) + floatOffset,
            child: Container(
              width: notchSize,
              height: notchSize,
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -(fabSize / 2) + floatOffset,
            child: GestureDetector(
              onTap: () => onItemTap(NavBarController.centerIndex),
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.authOrange, AppColors.authOrangeDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 26.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
