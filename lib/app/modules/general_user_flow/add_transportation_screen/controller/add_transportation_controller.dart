import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransportationController extends GetxController {
  // Text Controllers
  final departureLocationController = TextEditingController();
  final arrivalLocationController = TextEditingController();
  final bookingReferenceController = TextEditingController();
  final airlineController = TextEditingController();
  final flightNumberController = TextEditingController();
  final terminalController = TextEditingController();
  final gateController = TextEditingController();
  final seatController = TextEditingController();
  final totalCostController = TextEditingController();
  final notesController = TextEditingController();

  // Date and Time Controllers
  final departureDateController = TextEditingController();
  final departureTimeController = TextEditingController();
  final arrivalDateController = TextEditingController();
  final arrivalTimeController = TextEditingController();

  // Reactive Variables
  final selectedTransportationType = Rxn<String>();
  final selectedBookingPlatform = Rxn<String>();
  final selectedCurrency = Rxn<String>();
  final isFormValid = false.obs;

  // Form Key
  late GlobalKey<FormState> formKey;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    selectedCurrency.value = 'EUR';
    selectedBookingPlatform.value = 'Skyscanner';
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

  // Transportation Type Selection
  void selectTransportationType(String type) {
    selectedTransportationType.value = type;
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

  // Get all form data
  Map<String, dynamic> getFormData() {
    return {
      'transportationType': selectedTransportationType.value,
      'departureLocation': departureLocationController.text,
      'arrivalLocation': arrivalLocationController.text,
      'departureDate': departureDateController.text,
      'departureTime': departureTimeController.text,
      'arrivalDate': arrivalDateController.text,
      'arrivalTime': arrivalTimeController.text,
      'bookingPlatform': selectedBookingPlatform.value,
      'bookingReference': bookingReferenceController.text,
      'airline': airlineController.text,
      'flightNumber': flightNumberController.text,
      'terminal': terminalController.text,
      'gate': gateController.text,
      'seat': seatController.text,
      'currency': selectedCurrency.value,
      'totalCost': totalCostController.text,
      'notes': notesController.text,
    };
  }

  // Clear all fields
  void clearForm() {
    departureLocationController.clear();
    arrivalLocationController.clear();
    departureDateController.clear();
    departureTimeController.clear();
    arrivalDateController.clear();
    arrivalTimeController.clear();
    bookingReferenceController.clear();
    airlineController.clear();
    flightNumberController.clear();
    terminalController.clear();
    gateController.clear();
    seatController.clear();
    totalCostController.clear();
    notesController.clear();
    selectedTransportationType.value = null;
    selectedBookingPlatform.value = 'Skyscanner';
    selectedCurrency.value = 'EUR';
    isFormValid.value = false;
    formKey.currentState?.reset();
  }

  // Save form
  void saveForm() {
    if (validateForm()) {
      final data = getFormData();
      Get.snackbar(
        'Success',
        'Transportation booking saved!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Here you would typically send data to backend
      print('Form Data: $data');
    } else {
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    departureLocationController.dispose();
    arrivalLocationController.dispose();
    departureDateController.dispose();
    departureTimeController.dispose();
    arrivalDateController.dispose();
    arrivalTimeController.dispose();
    bookingReferenceController.dispose();
    airlineController.dispose();
    flightNumberController.dispose();
    terminalController.dispose();
    gateController.dispose();
    seatController.dispose();
    totalCostController.dispose();
    notesController.dispose();
    super.onClose();
  }
}