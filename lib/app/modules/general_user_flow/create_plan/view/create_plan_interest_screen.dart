import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/view/budget_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

import '../controller/interest_controller.dart';

class InterestView extends StatelessWidget {
  final InterestController controller = Get.put(InterestController());

  InterestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            // Progress Bar & Back Button (Custom)
            backButton(onTap: () => Get.back()),
            SizedBox(height: 20),
            Text(
              "Your Interests",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "What are you most interested in when you travel",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20),

            // 3 Selected Badge
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.authOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.authOrange.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  "${controller.selectedCount} selected",
                  style: TextStyle(color: AppColors.authOrange, fontSize: 15),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Grid of Interests

            Expanded(
              child: Obx(() {
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.interests.length,
                  itemBuilder: (context, index) {
                    final item = controller.interests[index];
                    return GestureDetector(
                      onTap: () => controller.toggleSelection(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: item.isSelected
                                ? AppColors.authOrange
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              item.iconPath,
                              height: 30,
                              width: 30,
                            ), // Placeholder icon
                            SizedBox(width: 8),
                            Text(
                              item.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Get.to(BudgetView()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.authOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
