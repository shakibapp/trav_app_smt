import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_alerts/ui/parent_alerts_screen.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_home/ui/parent_home_screen.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_trips/ui/parent_trips_screen.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_settings/ui/parent_settings_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../controller/parent_nav_bar_controller.dart';
import 'widgets/trav_bottom_nav_bar.dart';

class NavBarScreen extends StatelessWidget {
   NavBarScreen({super.key});
  final controller = Get.put(ParentNavBarController());


  @override
  Widget build(BuildContext context) {
    final pages =  <Widget>[
      ParentHomeScreen(),
      ParentTripsScreen(),
      ParentAlertsScreen(),
      ParentSettingsScreen(),
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
