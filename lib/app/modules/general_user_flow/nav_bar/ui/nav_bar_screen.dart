import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/home/ui/home_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/profile/ui/profile_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trips/ui/trips_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../alerts_screen/view/alerts_screen.dart';
import '../controller/nav_bar_controller.dart';

import 'widgets/trav_bottom_nav_bar.dart';

class NavBarScreen extends GetWidget<NavBarController> {
  const NavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(),
      TripsScreen(),
      SizedBox.shrink(),
      AlertsView(),
      ProfileScreen(),
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
          child: TravBottomNavBar(
            selectedIndexRx: controller.selectedIndex,
            items: controller.navItems,
            onItemTap: controller.onNavTap,
          ),
        ),
      ),
    );
  }
}
