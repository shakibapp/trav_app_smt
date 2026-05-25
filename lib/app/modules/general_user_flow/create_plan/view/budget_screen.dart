
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/view/stay_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

import '../../nav_bar/controller/nav_bar_controller.dart';
import '../controller/budget_controller.dart';
import '../controller/create_plan_controller.dart';

class BudgetView extends StatelessWidget {
  final BudgetController controller = Get.put(BudgetController());
  final CreatePlanController createPlanController =
      Get.put(CreatePlanController(), tag: 'create_plan');

  BudgetView({super.key});
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(onTap: ()=>Get.back()),
                  SizedBox(height: 25),
                  Text(
                    "What's your budget range?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Per day estimate, we'll keep you on track",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(height: 25),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .95,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: controller.options.length,
                    itemBuilder: (context, index) {
                      final item = controller.options[index];
                      return Obx(() {
                        bool isSelected = controller.selectedIndex.value == index;
                        return GestureDetector(
                          onTap: () => controller.selectBudget(index),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.authOrange : Colors.grey.shade200,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.authOrange.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFfcdcc9)),
                                    color: const Color(0xFFfdf3ec),
                                  ),
                                  child: Image.asset(item.icon, height: 35, width: 35),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Text(
                                    "\$${item.amount}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Or customize your budget",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.authFieldFill,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.authFieldBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.orangeLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.attach_money,
                            color: AppColors.authOrange,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            onChanged: controller.onCustomAmountChange,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Enter Daily Budget",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: "0.00",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Obx(
              (){
                final isLoading = createPlanController.isSubmitting.value ||
      createPlanController.isManualSubmitting.value;
  final canProceed = controller.isBudgetSelected; 
               return SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading || !canProceed
          ? null
                      : () async {
                          final success = createPlanController.useAiTrip
                              ? await createPlanController.createTripHelperAi()
                              : await createPlanController.createTripManually();
                          if (success) {
                            if (createPlanController.useAiTrip) {
                              final navController = Get.find<NavBarController>();
                              navController.setIndex(0);
                              Get.offAllNamed('/navbar');
                            } else {
                              Get.off(() => StayView());
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authOrange,
                    elevation: 5,
                    shadowColor: AppColors.authOrange.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: createPlanController.isSubmitting.value ||
                          createPlanController.isManualSubmitting.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                ),
              );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}