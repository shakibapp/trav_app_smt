import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/country_list.dart';

class PreferencesController extends GetxController {
  final localService = LocalService.localService;
  final networkConfig = NetworkConfigV1.instance;
  // Step 1
  final selectedFeature = ''.obs;

  // Step 2
  final selectedAgeRange = ''.obs;

  // Step 3
  final homeCountry = ''.obs;
  final passportIssuingCountry = ''.obs;
  final passportExpiryTEC =TextEditingController();
  // Options
  final ageRanges = const ['Under 18', '18-24', '25-34', '35-44', 'Over 45'];

  late final List<String> countries = countryList
      .map((c) => c['name']!)
      .toList();

  bool get canContinueStep1 => selectedFeature.value.trim().isNotEmpty;

  bool get canContinueStep2 => selectedAgeRange.value.trim().isNotEmpty;

  bool get canContinueStep3 =>
      homeCountry.value.trim().isNotEmpty &&
      passportIssuingCountry.value.trim().isNotEmpty;

  void setFeature(String v) => selectedFeature.value = v;

  void setAgeRange(String v) => selectedAgeRange.value = v;

  void setHomeCountry(String v) => homeCountry.value = v;

  void setPassportIssuingCountry(String v) => passportIssuingCountry.value = v;

  void onFinish() {
    log(
      'Preferences saved: Feature=${selectedFeature.value}, AgeRange=${selectedAgeRange.value}, HomeCountry=${homeCountry.value}, PassportCountry=${passportIssuingCountry.value}',
    );

    //Get.offAllNamed(AppRoutes.NAVBAR);
  }

  final RxBool isUpdateLoading = false.obs;
  Future<bool> updateProfile() async {
    try {
      isUpdateLoading.value = true;
      final request = http.MultipartRequest(
        "PUT",
        Uri.parse("${Urls.baseUrl}/users/profile"),
      );
      String? token = localService.getToken();
      log(" Updating profile with token: $token");
      if (token != null) {
        request.headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': token,
        });
      } else {
        AppToast.showError("Please login again");
      }
      String? mappedFeature;
      if (selectedFeature.value == 'Organise Destinations') {
        mappedFeature = 'Organize_Destinations';
      } else if (selectedFeature.value == 'Track Booking') {
        mappedFeature = 'Track_Bookings';
      } else if (selectedFeature.value == 'Plan your route') {
        mappedFeature = 'Plan_your_Routes';
      }

      // Create the JSON data for the data field
      Map<String, dynamic> updateData = {
        "tripsPlans": mappedFeature != null ? [mappedFeature] : [],
        "age": selectedAgeRange.value,
        "homeCountry": homeCountry.value,
        "passportCountry": passportIssuingCountry.value,
        "passportExpiry": passportExpiryDate.value != null
            ? "${passportExpiryDate.value!.year}-${passportExpiryDate.value!.month.toString().padLeft(2, '0')}-${passportExpiryDate.value!.day.toString().padLeft(2, '0')}T00:00:00.000Z"
            : "",
      };
      // Add the data field as JSON string to the request
      request.fields["data"] = jsonEncode(updateData);

      log("Updating profile with data: ${jsonEncode(updateData)}");

      //send request to server and get response from server and return response to controller
      final streamedRequest = await request.send();
      //response use for get response from server and return response to controller
      final response = await http.Response.fromStream(streamedRequest);
      final decodeResponse = jsonDecode(response.body);
      log("Profile update response: $decodeResponse");
      log("Status code: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppToast.showSuccess("Profile updated successfully!");
        Get.offAllNamed(AppRoutes.NAVBAR);
        isUpdateLoading.value = false;
        return true;
      } else {
        AppToast.showError(decodeResponse["message"]);
        isUpdateLoading.value = false;
        return false;
      }
    } catch (e) {
      log("Profile update error: $e");
      return false;
    } finally {
      isUpdateLoading.value = false;
    }
  }

  final passportExpiryDate = Rxn<DateTime>(); // actual date store

  Future<void> pickPassportExpiryDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 20),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.authOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      passportExpiryDate.value = picked;
      // UI তে readable format
      passportExpiryTEC.text = "${picked.day.toString().padLeft(2, '0')} ${_monthName(picked.month)} ${picked.year}";
    }
  }

  String _monthName(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[month - 1];
  }
}
