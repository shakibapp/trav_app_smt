import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../ui/widgets/create_action_sheet.dart';

class NavBarItemData {
  const NavBarItemData({
    required this.index,
    required this.icon,
    required this.label,
  });

  final int index;
  final IconData icon;
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
    NavBarItemData(index: 0, icon: Icons.home_rounded, label: 'Home'),
    NavBarItemData(
      index: 1,
      icon: Icons.airplanemode_active_rounded,
      label: 'Trips',
    ),
    NavBarItemData(index: 2, icon: Icons.add, label: ''),
    NavBarItemData(
      index: 3,
      icon: Icons.notifications_none_rounded,
      label: 'Alerts',
    ),
    NavBarItemData(
      index: 4,
      icon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  final createActions = <NavBarCreateAction>[
    NavBarCreateAction(
      icon: Icons.add_road_rounded,
      title: 'New Trip',
      onTap: () {},
    ),
    NavBarCreateAction(
      icon: Icons.event_available_rounded,
      title: 'New Booking',
      onTap: () {},
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
