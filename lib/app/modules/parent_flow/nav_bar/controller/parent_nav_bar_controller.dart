import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/view/create_plan_country_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../ui/widgets/create_action_sheet.dart';

class ParentNavBarItemData {
  const ParentNavBarItemData({
    required this.index,
    required this.outlineAssetPath,
    required this.filledAssetPath,
    required this.label,
  });

  final int index;
  final String outlineAssetPath;
  final String filledAssetPath;
  final String label;
}

class ParentNavBarCreateAction {
  const ParentNavBarCreateAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
}

class ParentNavBarController extends GetxController {
  static const int centerIndex = 4;

  final selectedIndex = 0.obs;

  final navItems = const <ParentNavBarItemData>[
    ParentNavBarItemData(
      index: 0,
      outlineAssetPath: AppIcons.travHomeOutline,
      filledAssetPath: AppIcons.travHomeFill,
      label: 'Home',
    ),
    ParentNavBarItemData(
      index: 1,
      outlineAssetPath: AppIcons.travTripsOutline,
      filledAssetPath: AppIcons.travTripsFill,
      label: 'Trips',
    ),

    ParentNavBarItemData(
      index: 2,
      outlineAssetPath: AppIcons.travAlertsOutline,
      filledAssetPath: AppIcons.travAlertsFill,
      label: 'Alerts',
    ),
    ParentNavBarItemData(
      index: 3,
      outlineAssetPath: AppIcons.travProfileOutline,
      filledAssetPath: AppIcons.travProfileFill,
      label: 'Settings',
    ),
  ];

  final createActions = <ParentNavBarCreateAction>[
    ParentNavBarCreateAction(
      icon: Icons.add_road_rounded,
      title: 'New Trip',
      onTap: () => Get.to(() => RegionSelectionView()),
    ),
    ParentNavBarCreateAction(
      icon: Icons.event_available_rounded,
      title: 'New Booking',
      onTap: () => Get.to(() => RegionSelectionView()),
    ),
  ];

  void setIndex(int index) {
    selectedIndex.value = index;
  }

  void onNavTap(int index) {
    if (index == centerIndex) {
      openCreateSheet();
      return;
    }
    setIndex(index);
  }

  void openCreateSheet() {
    Get.bottomSheet<void>(
      CreateActionSheet(actions: createActions),
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    );
  }
}
