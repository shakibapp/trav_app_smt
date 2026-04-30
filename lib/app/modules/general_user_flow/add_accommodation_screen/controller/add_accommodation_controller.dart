import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccommodationController extends GetxController {
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

  // Get all form data
  Map<String, dynamic> getFormData() {
    return {
      'accommodationName': accommodationNameController.text,
      'accommodationType': selectedAccommodationType.value,
      'address': addressController.text,
      'bookingPlatform': selectedBookingPlatform.value,
      'bookingReference': bookingReferenceController.text,
      'numberOfGuests': numberOfGuests.value,
      'checkInDate': checkInDateController.text,
      'checkOutDate': checkOutDateController.text,
      'currency': selectedCurrency.value,
      'totalCost': totalCostController.text,
      'paymentStatus': selectedPaymentStatus.value,
      'amountOwing': amountOwingController.text,
      'notes': notesController.text,
    };
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

  // Save form
  void saveForm() {
    if (validateForm()) {
      final data = getFormData();
      Get.snackbar(
        'Success',
        'Accommodation booking saved!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      // Here you would typically send data to backend
      print('Form Data: $data');
      // Get.back(); // Uncomment to go back after saving
    } else {
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Calculate amount owing (Total Cost - Paid Amount)
  double calculateAmountOwing() {
    try {
      double total = double.parse(totalCostController.text.isEmpty
          ? '0'
          : totalCostController.text);
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

  @override
  void onClose() {
    accommodationNameController.dispose();
    addressController.dispose();
    bookingReferenceController.dispose();
    numberOfGuestsController.dispose();
    totalCostController.dispose();
    amountOwingController.dispose();
    notesController.dispose();
    checkInDateController.dispose();
    checkOutDateController.dispose();
    super.onClose();
  }
}