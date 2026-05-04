import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/view/stay_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              backButton(),
              SizedBox(height: 25),
              Text(
                "What's your budget range?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "Per day estimate, we'll keep you on track",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              SizedBox(height: 30),

              // Budget Cards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.10,
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
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Color(0xFFfcdcc9)),
                                    color: Color(0xFFfdf3ec),
                                  ),
                                  child: Image.asset(
                                    item.icon,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    "\$${item.amount}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 12,
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

              SizedBox(height: 30),
              Text(
                "Add Custom budget",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              // Custom Amount Input
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  onChanged: controller.onCustomAmountChange,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Enter Amount",
                    labelStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.unfold_more, color: Colors.blueGrey),
                    hintText: "00",
                    hintStyle: TextStyle(color: Colors.orange),
                  ),
                ),
              ),

              Spacer(),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: createPlanController.isSubmitting.value ||
                              createPlanController.isManualSubmitting.value
                          ? null
                          : () async {
                              final success = createPlanController.useAiTrip
                                  ? await createPlanController
                                      .createTripHelperAi()
                                  : await createPlanController
                                      .createTripManually();
                              if (success) {
                                Get.to(() => StayView());
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
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
