import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../controller/nav_bar_controller.dart';
import 'tabs/nav_tabs.dart';
import 'widgets/trav_bottom_nav_bar.dart';

class NavBarScreen extends GetWidget<NavBarController> {
  const NavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const <Widget>[
      HomeTab(),
      TripsTab(),
      SizedBox.shrink(), // center action
      AlertsTab(),
      ProfileTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 360.w),
                child: TravBottomNavBar(
                  selectedIndexRx: controller.selectedIndex,
                  items: controller.navItems,
                  onItemTap: controller.onNavTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
