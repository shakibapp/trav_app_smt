import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/city/controller/city_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/controller/budget_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/controller/create_plan_calender_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/controller/interest_controller.dart';

class CreatePlanController extends GetxController {
  final cityController = Get.find<CityController>();
  final dateController = Get.find<DatePickerController>();
  final interestController = Get.find<InterestController>();
  final budgetController = Get.find<BudgetController>();

  final isSubmitting = false.obs;
  final isManualSubmitting = false.obs;

  final tripResponse = Rxn<Map<String, dynamic>>();

  // =========================
  // MODE
  // =========================
  bool get useAiTrip => cityController.useAiHelp.value;

  // =========================
  // DATA GETTERS
  // =========================
  List<String> get selectedRegions =>
      cityController.selectedRegions.map((e) => e.name).toList();

  List<String> get selectedCities =>
      cityController.selectedCities.map((e) => e.name).toList();

  List<String> get selectedInterests => interestController.interests
      .where((e) => e.isSelected)
      .map((e) => e.title)
      .toList();

  DateTime? get startDate => dateController.selectedStartDate.value;
  DateTime? get endDate => dateController.selectedEndDate.value;

  int get totalDays => dateController.getTotalDays();

  // =========================
  // CREATE AI TRIP
  // =========================
  Future<bool> createTripHelperAi() async {
    if (isSubmitting.value) return false;

    if (!_validateCommon()) return false;

    final payload = _buildPayload(isAiMode: true);

    isSubmitting(true);
    try {
      final response = await NetworkConfigV1.instance.ApiRequestHandler(
        RequestMethod.POST,
        Urls.createTripByAI,
        jsonEncode(payload),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        tripResponse(response['data']);
        log("${response}");
        Get.snackbar(
          'Trip Created',
          'AI trip created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Trip Created',
          'AI trip created Failed',
          backgroundColor: Colors.red,
          colorText: Colors.black,
        );
        return false;
      }
    } finally {
      isSubmitting(false);
    }
  }

  // =========================
  // CREATE MANUAL TRIP
  // =========================
  Future<bool> createTripManually() async {
    if (isManualSubmitting.value) return false;

    if (!_validateCommon()) return false;

    final payload = _buildPayload(isAiMode: false);

    isManualSubmitting(true);
    try {
      log("Manual Trip Payload: ${jsonEncode(payload)}");

      final response = await NetworkConfigV1.instance.ApiRequestHandler(
        RequestMethod.POST,
        Urls.createTrip,
        jsonEncode(payload),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        tripResponse(response['data']);

        Get.snackbar(
          'Trip Created',
          'Manual trip created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          'Failed',
          'Trip creation failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return false;
      }
    } finally {
      isManualSubmitting(false);
    }
  }

  // =========================
  // PAYLOAD BUILDER
  // =========================
  Map<String, dynamic> _buildPayload({required bool isAiMode}) {
    final base = {
      "region": selectedRegions,
      "city": selectedCities,
      "startDate": _formatDate(startDate),
      "endDate": _formatDate(endDate),
      "totalDays": totalDays,
      "interests": selectedInterests,
      "budget": int.parse(budgetController.customAmount.value.trim()),
    };

    // =========================
    // AI MODE ONLY
    // =========================
    if (isAiMode) {
      base["message"] = _buildMessage(selectedRegions, selectedInterests);
    }

    return base;
  }

  // =========================
  // VALIDATION
  // =========================
  bool _validateCommon() {
    if (selectedCities.isEmpty || selectedRegions.isEmpty) {
      Get.snackbar(
        'Failed',
        'Please select region and city',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedInterests.isEmpty) {
      Get.snackbar(
        'Failed',
        'Please select interests',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (startDate == null || endDate == null || totalDays <= 0) {
      Get.snackbar(
        'Failed',
        'Please select valid dates',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // if (_resolveBudget() == "") {
    //   Get.snackbar(
    //     'Failed',
    //     'Please select budget',
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return false;
    // }

    return true;
  }

  // =========================
  // DATE FORMAT
  // =========================
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return date.toUtc().toIso8601String();
  }

  // =========================
  // AI MESSAGE BUILDER
  // =========================
  String _buildMessage(List<String> regions, List<String> interests) {
    final normalized = interests.map((e) {
      final v = e.toLowerCase();
      if (v.contains('culture') || v.contains('history')) return 'Culture';
      if (v.contains('food')) return 'Food';
      if (v.contains('adventure')) return 'Adventure';
      if (v.contains('relax')) return 'Relaxed';
      return e;
    }).toList();

    final theme = normalized.contains('Culture')
        ? 'cultural'
        : normalized.contains('Food')
        ? 'food-focused'
        : normalized.contains('Adventure')
        ? 'adventurous'
        : 'relaxed';

    final regionText = regions.isNotEmpty
        ? regions.join(', ')
        : 'selected destinations';

    return "I want a $theme trip through $regionText";
  }
}
