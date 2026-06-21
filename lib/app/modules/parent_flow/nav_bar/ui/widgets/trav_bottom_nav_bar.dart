import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/parent_nav_bar_controller.dart';
import 'nav_item.dart';

class TravBottomNavBar extends StatelessWidget {
  const TravBottomNavBar({
    super.key,
    required this.selectedIndexRx,
    required this.items,
    required this.onItemTap,
  });

  final RxInt selectedIndexRx;
  final List<ParentNavBarItemData> items;
  final ValueChanged<int> onItemTap;

  static const _bg = Color(0xFF3A3A3A);

  @override
  Widget build(BuildContext context) {
    final barHeight = 62.h;
    final fabSize = 58.w;
    final notchSize = 78.w;
    final centerGap = fabSize + 4.w;
    final floatOffset = 10.h;

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

                  Expanded(
                    child: NavItem(
                      data: items[2],
                      selected: selected == items[2].index,
                      onTap: () => onItemTap(items[2].index),
                    ),
                  ),
                  Expanded(
                    child: NavItem(
                      data: items[3],
                      selected: selected == items[3].index,
                      onTap: () => onItemTap(items[3].index),
                    ),
                  ),
                ],
              );
            }),
          ),

        ],
      ),
    );
  }
}
