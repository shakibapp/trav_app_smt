
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
    BudgetOption(
      title: "Budget",
      description: "Travel more, spend less. Simple.",
      amount: "1-1500",
      fillAmount: "500",
      icon: AppIcons.budget,
    ),
    BudgetOption(
      title: "Comfort",
      description: "Not roughing it, not splashing out.",
      amount: "1501-3000",
      fillAmount: "2000",
      icon: AppIcons.comfort,
    ),
    BudgetOption(
      title: "Premium",
      description: "When you want the good version of everything.",
      amount: "3001-5000",
      fillAmount: "4000",
      icon: AppIcons.premium,
    ),
    BudgetOption(
      title: "Luxury",
      description: "Money's not an issue.",
      amount: "5000+",
      fillAmount: "6000",
      icon: AppIcons.luxury,
    ),
  ];

  void selectBudget(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
      amountController.clear();
      customAmount.value = "";
    } else {
      selectedIndex.value = index;
      final selectedOption = options[index];
      amountController.text = selectedOption.fillAmount;
      customAmount.value = selectedOption.fillAmount;
    }
  }

  bool get isBudgetSelected => customAmount.value.trim().isNotEmpty;

  void onCustomAmountChange(String value) {
    customAmount.value = value;
    
    // Check if entered amount matches any option's fillAmount
    int matchIndex = options.indexWhere((option) => option.fillAmount == value.trim());
    selectedIndex.value = matchIndex;
  }
}

class BudgetOption {
  final String title;
  final String description;
  final String amount;
  final String fillAmount;
  final String icon;

  BudgetOption({
    required this.title,
    required this.description,
    required this.amount,
    required this.fillAmount,
    required this.icon,
  });
}