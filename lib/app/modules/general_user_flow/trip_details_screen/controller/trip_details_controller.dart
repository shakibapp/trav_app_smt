import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';

class TripDetailsController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  // Observables
  final isLoading = false.obs;
  final selectedTabIndex = 0.obs;
  final expandedStopIndex = (-1).obs;


  @override
  void onInit() {
    super.onInit();
    getSingleTripData("69fc4ba8154098ba82db9081");

  }

  //get single trip data
  final Rx<SingleTripDetailsModel> singleTripData = SingleTripDetailsModel().obs;
  final RxBool isTripDetailsLoading = false.obs;
  Future<void> getSingleTripData(String id)async{
    try{
      isTripDetailsLoading.value = true;
      final response = await networkConfig.ApiRequestHandler(RequestMethod.GET, "${Urls.tripDetail}/$id",
          {},is_auth: true);
      if(response != null && response["success"]==true){
        singleTripData.value = SingleTripDetailsModel.fromJson(response["data"]);
        log("Get single trip details success ${response['message']}");
      }else{
        log("get Single trip details failed ${response["message"]}");
      }
    }catch(e){
      log("get single trip details error ${e.toString()}");
    }finally{
      isTripDetailsLoading.value = false;
    }
  }


  void toggleStop(int index) {
    expandedStopIndex.value = expandedStopIndex.value == index ? -1 : index;
  }



  void handleReminder(String title) {
    Get.snackbar(
      'Reminder Action',
      'Processing: $title',
      backgroundColor: const Color(0xFFFFA500),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void optimizeRoute() {
    Get.snackbar(
      'Route Optimization',
      'Finding the best route for you...',
      backgroundColor: const Color(0xFFFFA500),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  //update priority Remainder
  final RxBool isPriorityLoading= false.obs;
  Future<void> changePriority()async{
    try{
      isPriorityLoading.value = true;
      final Map<String,dynamic> data ={
        "passportCountry": "Paris",
        "passportExpiry": "2028-03-15T00:00:00.000Z",
        "isVisaConfirmed": true,
        "noVisaRequired": false,
        "needsAttention": false,
        "visaNotes": "Visa approved via embassy",
        "haveInsurance": true
      };
      final response = await networkConfig.ApiRequestHandler(RequestMethod.PUT, "${Urls.priorityStatusChange}/",
          jsonEncode(data),is_auth: true);
      if(response != null && response["success"]==true){
        AppSnackbar.success("${response["message"]}");
        log("priority reminders status update success");
      }else{
        AppSnackbar.failed("${response["message"]}");
        log("Priority remainders failed ${response["message"]}");
      }
    }catch(e){
      log("priority status change error ${e.toString()}");
    }finally{
      isPriorityLoading.value = false;
    }
  }


  // Bottom Sheet Methods
  void showPriorityReminderBottomSheet(PriorityRemainder reminder) {
    switch (reminder.passportCountry) {
      case 'Passport':
        _showPassportBottomSheet();
        break;
      case 'Visa':
        _showVisaBottomSheet();
        break;
      case 'Travel Insurance':
        _showTravelInsuranceBottomSheet();
        break;
      default:
        break;
    }
  }

  void _showPassportBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFffe7d9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.document_scanner,
                            color: AppColors.authOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Passport',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Issuing Country',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'e.g. Australia',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Passport Expiry Date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Day Number 1',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            borderColor: AppColors.authOrange,
                            bgColor: Colors.transparent,

                            onTap: () {
                              Get.back();
                            },
                            name: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: appButton(
                            textColor: Colors.white,

                            onTap: () {
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Passport details saved',
                                backgroundColor: AppColors.authOrange,
                                colorText: Colors.white,
                              );
                            },
                            name: "Save",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showVisaBottomSheet() {
    var selectedVisaStatus = ''.obs;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFffe7d9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.badge,
                            color: AppColors.authOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Visa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Have you checked visa requirements?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Option 1
                    Obx(
                      () => GestureDetector(
                        onTap: () => selectedVisaStatus.value =
                            'Visa Confirmed/ Obtained',
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedVisaStatus.value ==
                                      'Visa Confirmed/ Obtained'
                                  ? AppColors.authOrange
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Visa Confirmed/ Obtained',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'I have the necessary visa(s) or have confirmed i dont need one',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        selectedVisaStatus.value ==
                                            'Visa Confirmed/ Obtained'
                                        ? AppColors.authOrange
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color:
                                      selectedVisaStatus.value ==
                                          'Visa Confirmed/ Obtained'
                                      ? AppColors.authOrange
                                      : Colors.transparent,
                                ),
                                child:
                                    selectedVisaStatus.value ==
                                        'Visa Confirmed/ Obtained'
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Option 2
                    Obx(
                      () => GestureDetector(
                        onTap: () =>
                            selectedVisaStatus.value = 'No Visa Required',
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedVisaStatus.value == 'No Visa Required'
                                  ? AppColors.authOrange
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'No Visa Required',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'My passport allows visa-free entry to all destinations',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        selectedVisaStatus.value ==
                                            'No Visa Required'
                                        ? AppColors.authOrange
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color:
                                      selectedVisaStatus.value ==
                                          'No Visa Required'
                                      ? AppColors.authOrange
                                      : Colors.transparent,
                                ),
                                child:
                                    selectedVisaStatus.value ==
                                        'No Visa Required'
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Option 3
                    Obx(
                      () => GestureDetector(
                        onTap: () =>
                            selectedVisaStatus.value = 'Needs Attention',
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedVisaStatus.value == 'Needs Attention'
                                  ? AppColors.authOrange
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Needs Attention',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'I still need to apply for or check visa requirements',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        selectedVisaStatus.value ==
                                            'Needs Attention'
                                        ? AppColors.authOrange
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color:
                                      selectedVisaStatus.value ==
                                          'Needs Attention'
                                      ? AppColors.authOrange
                                      : Colors.transparent,
                                ),
                                child:
                                    selectedVisaStatus.value ==
                                        'Needs Attention'
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Ask AI Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            'AI Assistant',
                            'Opening Trav AI for visa guidance...',
                            backgroundColor: AppColors.authOrange,
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.authOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Ask Trav (AI)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Notes Section
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'describe',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            borderColor: AppColors.authOrange,
                            bgColor: Colors.transparent,

                            onTap: () {
                              Get.back();
                            },
                            name: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: appButton(
                            textColor: Colors.white,

                            onTap: () {
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Visa status marked as reviewed',
                                backgroundColor: AppColors.authOrange,
                                colorText: Colors.white,
                              );
                            },
                            name: "Mark as Reviewed",
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 20,),
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showTravelInsuranceBottomSheet() {
    var selectedInsuranceStatus = ''.obs;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFffe7d9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shield,
                            color:AppColors.authOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Travel Insurance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Do you have a travel insurance?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Option 1
                    Obx(
                      () => GestureDetector(
                        onTap: () => selectedInsuranceStatus.value =
                            'Yes, I have insurance',
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedInsuranceStatus.value ==
                                      'Yes, I have insurance'
                                  ? AppColors.authOrange
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Yes, I have insurance',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'I have travel insurance coverage for this trip',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        selectedInsuranceStatus.value ==
                                            'Yes, I have insurance'
                                        ? AppColors.authOrange
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color:
                                      selectedInsuranceStatus.value ==
                                          'Yes, I have insurance'
                                      ? AppColors.authOrange
                                      : Colors.transparent,
                                ),
                                child:
                                    selectedInsuranceStatus.value ==
                                        'Yes, I have insurance'
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Option 2
                    Obx(
                      () => GestureDetector(
                        onTap: () => selectedInsuranceStatus.value =
                            'Not yet/ Need to get',
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedInsuranceStatus.value ==
                                      'Not yet/ Need to get'
                                  ? AppColors.authOrange
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Not yet/ Need to get',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'I still need to purchase travel insurance',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        selectedInsuranceStatus.value ==
                                            'Not yet/ Need to get'
                                        ? AppColors.authOrange
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color:
                                      selectedInsuranceStatus.value ==
                                          'Not yet/ Need to get'
                                      ? AppColors.authOrange
                                      : Colors.transparent,
                                ),
                                child:
                                    selectedInsuranceStatus.value ==
                                        'Not yet/ Need to get'
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            borderColor: AppColors.authOrange,
                            bgColor: Colors.transparent,

                            onTap: () {
                              Get.back();
                            },
                            name: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: appButton(
                            textColor: Colors.white,

                            onTap: () {
                              
                              Get.snackbar(
                                'Success',
                                'Insurance status confirmed',
                                backgroundColor: AppColors.authOrange,
                                colorText: Colors.white,
                              );
                              Get.back();
                            },
                            name: "Save",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
