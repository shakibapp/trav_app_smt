
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';

class BudgetController extends GetxController {
  // Selected index track korar jonno
  var selectedIndex = (-1).obs;
  
  // Custom amount control korar jonno
  var customAmount = "".obs;
  final TextEditingController amountController = TextEditingController();

  final List<BudgetOption> options = [
    BudgetOption(title: "Budget", description: "Affordable & pocket-friendly.", amount: 500, icon: AppIcons.budget),
    BudgetOption(title: "Comfort", description: "Balanced cost & comfort.", amount: 1500, icon: AppIcons.comfort),
    BudgetOption(title: "Premium", description: "Set your own specific amount.", amount: 3000, icon:AppIcons.premium),
    BudgetOption(title: "Luxury", description: "Premium travel experience.", amount: 5000, icon: AppIcons.luxury),
  ];

  void selectBudget(int index) {
    selectedIndex.value = index;
    // Card select korle custom field clear hoye jabe
    amountController.clear();
    customAmount.value = "";
  }

  void onCustomAmountChange(String value) {
    customAmount.value = value;
    if (value.isNotEmpty) {
      selectedIndex.value = -1; // Custom likhle card selection chole jabe
    }
  }
}

class BudgetOption {
  final String title;
  final String description;
  final int amount;
  final String icon; // Path or IconData

  BudgetOption({
    required this.title, 
    required this.description, 
    required this.amount, 
    required this.icon
  });
}