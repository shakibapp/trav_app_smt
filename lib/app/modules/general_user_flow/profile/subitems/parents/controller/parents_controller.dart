import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentsController extends GetxController {
  final parentEmail = ''.obs;
  final selectedRelation = 'Father'.obs;
  final isLoading = false.obs;

  late TextEditingController parentEmailController;

  final relationOptions = ['Father', 'Mother', 'Others'];

  @override
  void onInit() {
    super.onInit();
    parentEmailController = TextEditingController();
  }

  @override
  void onClose() {
    parentEmailController.dispose();
    super.onClose();
  }

  void setRelation(String relation) {
    selectedRelation.value = relation;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void onInvitePressed() {
    // TODO: Implement invite functionality
  }
}
