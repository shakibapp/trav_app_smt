import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_icons.dart';
import '../../create_plan/view/create_plan_country_screen.dart';


class NavBarItemData {
  const NavBarItemData({
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

class NavBarCreateAction {
  const NavBarCreateAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
}

class NavBarController extends GetxController {
  static const int centerIndex = 2;

  final selectedIndex = 0.obs;

  final navItems = const <NavBarItemData>[
    NavBarItemData(
      index: 0,
      outlineAssetPath: AppIcons.travHomeOutline,
      filledAssetPath: AppIcons.travHomeFill,
      label: 'Home',
    ),
    NavBarItemData(
      index: 1,
      outlineAssetPath: AppIcons.travTripsOutline,
      filledAssetPath: AppIcons.travTripsFill,
      label: 'Trips',
    ),
    NavBarItemData(
      index: 2,
      outlineAssetPath: '',
      filledAssetPath: '',
      label: '',
    ),
    NavBarItemData(
      index: 3,
      outlineAssetPath: AppIcons.travAlertsOutline,
      filledAssetPath: AppIcons.travAlertsFill,
      label: 'Alerts',
    ),
    NavBarItemData(
      index: 4,
      outlineAssetPath: AppIcons.travProfileOutline,
      filledAssetPath: AppIcons.travProfileFill,
      label: 'Profile',
    ),
  ];

  final createActions = <NavBarCreateAction>[
    NavBarCreateAction(
      icon: Icons.add_road_rounded,
      title: 'New Trip',
      onTap: () => Get.to(() => RegionSelectionView()),
    ),
    NavBarCreateAction(
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
      Get.to(() => RegionSelectionView());
      return;
    }
    setIndex(index);
  }

  // void openCreateSheet() {
  //   Get.bottomSheet<void>(
  //     CreateActionSheet(actions: createActions),
  //     backgroundColor: AppColors.whiteColor,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
  //     ),
  //   );
  // }
}
