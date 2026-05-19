import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';

import '../../Itinerary_screen/controller/tripltinerary_overview_controller.dart';

class AccommodationController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

  // Text Controllers
  final accommodationNameController = TextEditingController();
  final addressController = TextEditingController();
  final bookingReferenceController = TextEditingController();
  final numberOfGuestsController = TextEditingController();
  final totalCostController = TextEditingController();
  final amountOwingController = TextEditingController();
  final notesController = TextEditingController();

  // Date Controllers
  final checkInDateController = TextEditingController();
  final checkOutDateController = TextEditingController();

  // Reactive Variables
  final selectedAccommodationType = Rxn<String>();
  final selectedBookingPlatform = Rxn<String>();
  final selectedCurrency = Rxn<String>();
  final selectedPaymentStatus = Rxn<String>();
  final numberOfGuests = RxInt(1);
  final isFormValid = false.obs;

  // Form Key
  late GlobalKey<FormState> formKey;

  // Accommodation type options
  final accommodationTypes = [
    'Hotel',
    'Hostel',
    'Airbnb',
    'Resort',
  ];

  // Booking platform options
  final bookingPlatforms = [
    'HOSTELWORLD',
    'Booking.com',
    'Airbnb',
    'Expedia',
    'Hotels.com',
  ];

  // Payment status options
  final paymentStatuses = [
    'Still Owe',
    'Paid',
    'Partially Paid',
    'Refunded',
  ];

  // Currency options
  final currencies = ['EUR', 'USD', 'GBP', 'INR', 'BDT', 'AUD', 'CAD'];

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    selectedCurrency.value = 'EUR';
    selectedBookingPlatform.value = 'HOSTELWORLD';
    selectedPaymentStatus.value = 'Still Owe';
    numberOfGuestsController.text = '1';
  }

  // Validate all fields
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      isFormValid.value = true;
      return true;
    }
    isFormValid.value = false;
    return false;
  }

  // Accommodation Type Selection
  void selectAccommodationType(String type) {
    selectedAccommodationType.value = type;
    update();
  }

  // Booking Platform Selection
  void selectBookingPlatform(String platform) {
    selectedBookingPlatform.value = platform;
    update();
  }

  // Currency Selection
  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
    update();
  }

  // Payment Status Selection
  void selectPaymentStatus(String status) {
    selectedPaymentStatus.value = status;
    update();
  }

  // Increment guests
  void incrementGuests() {
    numberOfGuests.value++;
    numberOfGuestsController.text = numberOfGuests.value.toString();
    update();
  }

  // Decrement guests
  void decrementGuests() {
    if (numberOfGuests.value > 1) {
      numberOfGuests.value--;
      numberOfGuestsController.text = numberOfGuests.value.toString();
      update();
    }
  }

  // Set number of guests
  void setNumberOfGuests(int number) {
    if (number > 0) {
      numberOfGuests.value = number;
      numberOfGuestsController.text = number.toString();
      update();
    }
  }

  // Calculate amount owing (Total Cost - Paid Amount)
  double calculateAmountOwing() {
    try {
      double total = double.parse(
          totalCostController.text.isEmpty ? '0' : totalCostController.text);
      // If needed, implement logic for partially paid amounts
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  // Validate accommodation name
  String? validateAccommodationName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Accommodation name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // Validate check-in date
  String? validateCheckInDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Check-in date is required';
    }
    return null;
  }

  // Validate check-out date
  String? validateCheckOutDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Check-out date is required';
    }
    return null;
  }

  // Validate total cost
  String? validateTotalCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Total cost is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) < 0) {
      return 'Cost cannot be negative';
    }
    return null;
  }

  // Validate amount owing
  String? validateAmountOwing(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) < 0) {
      return 'Amount cannot be negative';
    }
    return null;
  }

  String toIsoDate(String value) {
    final date = DateFormat('dd/MM/yy').parseStrict(value);
    return DateTime.utc(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();
  }

  // create new accommodations
  final RxBool isAddAccommodationLoading = false.obs;
  Future<void> createNewAccommodation(String id) async {
    try {
      isAddAccommodationLoading.value = true;
      final Map<String, dynamic> data = {
        "name": accommodationNameController.text.trim(),
        "type": selectedAccommodationType.value,
        "address": addressController.text,
        "bookingPlatform": selectedBookingPlatform.value,
        "bookingReference": bookingReferenceController.text,
        "numberOfGuests": int.parse(numberOfGuestsController.text),
        "checkInDate": toIsoDate(checkInDateController.text),
        "checkOutDate": toIsoDate(checkOutDateController.text),
        "currency": selectedCurrency.value,
        "totalCost": double.parse(totalCostController.text),
        "paymentStatus": selectedPaymentStatus.value,
        "amountOwing": int.parse(amountOwingController.text),
        "notes": notesController.text,
      };
      log("create accommodation input Data --${data}");
      final response = await networkConfig.ApiRequestHandler(RequestMethod.POST,
          "${Urls.createAccommondation}/$id", jsonEncode(data),
          is_auth: true);
      if (response != null && response["success"] == true) {
        await Get.put(ItineraryDetailsController()).getItineraryOverview(id);
        Get.back();
        AppSnackbar.success("Accommondation Create successfull");
        log("accommondation create success ${response["message"]}");
      } else {
        AppSnackbar.failed("Accommondation Create failed");
        log("accommondation create failed ${response["message"]}");
      }
    } catch (e) {
      log('create accommodation error ${e.toString()}');
    } finally {
      isAddAccommodationLoading.value = false;
    }
  }

  // Clear all fields
  void clearForm() {
    accommodationNameController.clear();
    addressController.clear();
    bookingReferenceController.clear();
    totalCostController.clear();
    amountOwingController.clear();
    notesController.clear();
    checkInDateController.clear();
    checkOutDateController.clear();
    selectedAccommodationType.value = null;
    selectedBookingPlatform.value = 'HOSTELWORLD';
    selectedCurrency.value = 'EUR';
    selectedPaymentStatus.value = 'Still Owe';
    numberOfGuests.value = 1;
    numberOfGuestsController.text = '1';
    isFormValid.value = false;
    formKey.currentState?.reset();
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
