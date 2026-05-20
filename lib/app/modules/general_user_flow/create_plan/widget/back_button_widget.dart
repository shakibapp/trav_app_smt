import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hamishphipps/app/core/constants/app_colors.dart';

Widget backButton({required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),

        border: Border.all(color: AppColors.authOrange),
      ),
      child: Center(
        child: Icon(Icons.arrow_back_ios_new, color: AppColors.authOrange),
      ),
    ),
  );
}





