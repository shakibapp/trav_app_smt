import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/style/global_text_style.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home',
        style: globaltextInterTight(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}

class TripsTab extends StatelessWidget {
  const TripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Trips',
        style: globaltextInterTight(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Alerts',
        style: globaltextInterTight(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: globaltextInterTight(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}
