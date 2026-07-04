import 'dart:convert';
import 'dart:developer';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/model/single_transport_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';

class TransportationController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

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

  // New specific controllers
  final trainOperatorController = TextEditingController();
  final trainNumberController = TextEditingController();
  final busCompanyController = TextEditingController();
  final serviceNumberController = TextEditingController();
  final carNumberPlateController = TextEditingController();

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
  final hasTypeError = false.obs; // ✅ Track type validation error

  // Form Key
  late GlobalKey<FormState> formKey;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    selectedCurrency.value = 'AUD';
    selectedBookingPlatform.value = 'Skyscanner';
  }

  // Validate all fields
  bool validateForm() {
    bool isValid = formKey.currentState!.validate();
    if (selectedTransportationType.value == null) {
      hasTypeError.value = true;
      isValid = false;
    } else {
      hasTypeError.value = false;
    }
    
    isFormValid.value = isValid;
    return isValid;
  }

  // Transportation Type Selection
  void selectTransportationType(String type) {
    selectedTransportationType.value = type;
    hasTypeError.value = false; // ✅ Clear error on select
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

  String toIsoDate(String value) {
    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      return DateTime.utc(
        date.year,
        date.month,
        date.day,
      ).toIso8601String();
    } catch (e) {
      log("Error parsing date: $e");
      return value; // Fallback
    }
  }

  //create new transportation
  final RxBool isTransportationLoading = false.obs;
  Future<void> createTransportation(String id) async {
    if (!validateForm()) return;

    try {
      isTransportationLoading.value = true;
      final Map<String, dynamic> data = {
        "type": selectedTransportationType.value,
        "dpeartureLocation": departureLocationController.text,
        "arrivalLocation": arrivalLocationController.text,
        "departureDate": toIsoDate(departureDateController.text),
        "departureTime": departureTimeController.text,
        "arrivalDate": toIsoDate(arrivalDateController.text),
        "arrivalTime": arrivalTimeController.text,
        "bookingPlatform": selectedBookingPlatform.value,
        "currency": selectedCurrency.value,
        "totalCost": double.tryParse(totalCostController.text) ?? 0.0,
      };

      // Helper to add non-empty fields
      void addIfNotEmpty(String key, String value) {
        if (value.isNotEmpty) {
          data[key] = value;
        }
      }

      addIfNotEmpty("bookingReference", bookingReferenceController.text);
      addIfNotEmpty("airline", airlineController.text);
      addIfNotEmpty("flightNumber", flightNumberController.text);
      addIfNotEmpty("terminal", terminalController.text);
      addIfNotEmpty("gate", gateController.text);
      addIfNotEmpty("trainOperator", trainOperatorController.text);
      addIfNotEmpty("trainNumber", trainNumberController.text);
      addIfNotEmpty("busCompany", busCompanyController.text);
      addIfNotEmpty("serviceNumber", serviceNumberController.text);
      addIfNotEmpty("carNumberPlate", carNumberPlateController.text);
      addIfNotEmpty("notes", notesController.text);
      addIfNotEmpty("seat", seatController.text);

      log("Payload: ${jsonEncode(data)}");

      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.POST,
          "${Urls.createTransportation}/$id",
          jsonEncode(data),
          is_auth: true);
      if (response != null && response["success"] == true) {
        await Get.put(ItineraryDetailsController()).getItineraryOverview(id);
        Get.back();
        AppSnackbar.success("${response["message"]}");
        log("create transportation success ${response["message"]}");
      } else {
        AppSnackbar.failed("${response["message"] ?? 'Failed to create transportation'}");
        log("Create Transportation failed ${response["message"]}");
      }
    } catch (e) {
      log("Create transportation error ${e.toString()}");
      AppSnackbar.failed("An error occurred");
    } finally {
      isTransportationLoading.value = false;
    }
  }

  // ✅ Prefill form with existing data
void prefillForm() {
  final data = transportationDetails.value;
  if (data == null) return;

  selectedTransportationType.value = data.type;

  departureLocationController.text = data.dpeartureLocation ?? '';
  arrivalLocationController.text = data.arrivalLocation ?? '';

  // Date format: DD/MM/YYYY
  if (data.departureDate != null) {
    departureDateController.text =
        '${data.departureDate!.day.toString().padLeft(2, '0')}/'
        '${data.departureDate!.month.toString().padLeft(2, '0')}/'
        '${data.departureDate!.year}';
  }
  if (data.arrivalDate != null) {
    arrivalDateController.text =
        '${data.arrivalDate!.day.toString().padLeft(2, '0')}/'
        '${data.arrivalDate!.month.toString().padLeft(2, '0')}/'
        '${data.arrivalDate!.year}';
  }

  departureTimeController.text = data.departureTime ?? '';
  arrivalTimeController.text = data.arrivalTime ?? '';

  selectedBookingPlatform.value = data.bookingPlatform ?? 'Skyscanner';
  bookingReferenceController.text = data.bookingReference ?? '';

  airlineController.text = data.airline ?? '';
  flightNumberController.text = data.flightNumber ?? '';
  terminalController.text = data.terminal ?? '';
  gateController.text = data.gate ?? '';

  trainOperatorController.text = data.trainOperator?.toString() ?? '';
  trainNumberController.text = data.trainNumber?.toString() ?? '';
  busCompanyController.text = data.busCompany?.toString() ?? '';
  serviceNumberController.text = data.serviceNumber?.toString() ?? '';
  carNumberPlateController.text = data.carNumberPlate?.toString() ?? '';

  seatController.text = data.seat ?? '';
  selectedCurrency.value = data.currency ?? 'EUR';
  totalCostController.text = data.totalCost?.toString() ?? '';
  notesController.text = data.notes ?? '';

  update();
}

// ✅ Update transportation (PUT)
Future<void> updateTransportation(String transportationId) async {
  if (!validateForm()) return;

  try {
    isTransportationLoading.value = true;
    final Map<String, dynamic> data = {
      "type": selectedTransportationType.value,
      "dpeartureLocation": departureLocationController.text,
      "arrivalLocation": arrivalLocationController.text,
      "departureDate": toIsoDate(departureDateController.text),
      "departureTime": departureTimeController.text,
      "arrivalDate": toIsoDate(arrivalDateController.text),
      "arrivalTime": arrivalTimeController.text,
      "bookingPlatform": selectedBookingPlatform.value,
      "currency": selectedCurrency.value,
      "totalCost": double.tryParse(totalCostController.text) ?? 0.0,
    };

    void addIfNotEmpty(String key, String value) {
      if (value.isNotEmpty) data[key] = value;
    }

    addIfNotEmpty("bookingReference", bookingReferenceController.text);
    addIfNotEmpty("airline", airlineController.text);
    addIfNotEmpty("flightNumber", flightNumberController.text);
    addIfNotEmpty("terminal", terminalController.text);
    addIfNotEmpty("gate", gateController.text);
    addIfNotEmpty("trainOperator", trainOperatorController.text);
    addIfNotEmpty("trainNumber", trainNumberController.text);
    addIfNotEmpty("busCompany", busCompanyController.text);
    addIfNotEmpty("serviceNumber", serviceNumberController.text);
    addIfNotEmpty("carNumberPlate", carNumberPlateController.text);
    addIfNotEmpty("notes", notesController.text);
    addIfNotEmpty("seat", seatController.text);

    log("Update Payload: ${jsonEncode(data)}");

    final response = await networkConfig.ApiRequestHandler(
        RequestMethod.PUT,                                    // ✅ PUT
        "${Urls.baseUrl}/transportations/$transportationId",  // ✅ endpoint
        jsonEncode(data),
        is_auth: true);

    if (response != null && response["success"] == true) {
      final itineraryId = transportationDetails.value?.itineraryId ?? '';
      await Get.put(ItineraryDetailsController()).getItineraryOverview(itineraryId);
      Get.back();
      AppSnackbar.success("${response["message"]}");
      log("Update transportation success ${response["message"]}");
    } else {
      AppSnackbar.failed("${response["message"] ?? 'Failed to update transportation'}");
      log("Update transportation failed ${response["message"]}");
    }
  } catch (e) {
    log("Update transportation error ${e.toString()}");
    AppSnackbar.failed("An error occurred");
  } finally {
    isTransportationLoading.value = false;
  }
}

  //single transportation details
  final Rx<SingleTransportModel?> transportationDetails = Rxn<SingleTransportModel>();
    Future<void> getSingleTransportation( String transportationId) async {
      try {
        isTransportationLoading.value = true;
        final response = await networkConfig.ApiRequestHandler(
            RequestMethod.GET,
            "${Urls.baseUrl}/transportations/single/$transportationId",
            {},
            is_auth: true);
        if (response != null && response["success"] == true) {
          log("Get single transportation success ${response["data"]}");
          transportationDetails.value = SingleTransportModel.fromJson(response["data"]);
        
          
        } else {
          AppSnackbar.failed("${response["message"] ?? 'Failed to fetch transportation details'}");
          log("Get single transportation failed ${response["message"]}");
        }
      } catch (e) {
        log("Get single transportation error ${e.toString()}");
        
        
      } finally {
        isTransportationLoading.value = false;
      }
    }

    //delete transportation
    Future<void> deleteTransportation(String transportationId, String itineraryId) async {
  try {
    isTransportationLoading.value = true;
    final response = await networkConfig.ApiRequestHandler(
        RequestMethod.DELETE,
        "${Urls.baseUrl}/transportations/$transportationId",
        {},
        is_auth: true);

    if (response != null && response["success"] == true) {
      await Get.put(ItineraryDetailsController()).getItineraryOverview(itineraryId);
      Get.back(); // dialog close
      AppSnackbar.success("${response["message"]}");
      log("Delete transportation success ${response["message"]}");
    } else {
      AppSnackbar.failed("${response["message"] ?? 'Failed to delete transportation'}");
      log("Delete transportation failed ${response["message"]}");
    }
  } catch (e) {
    log("Delete transportation error ${e.toString()}");
    AppSnackbar.failed("An error occurred");
  } finally {
    isTransportationLoading.value = false;
  }
}
    
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
    trainOperatorController.clear();
    trainNumberController.clear();
    busCompanyController.clear();
    serviceNumberController.clear();
    carNumberPlateController.clear();
    selectedTransportationType.value = null;
    selectedBookingPlatform.value = 'Skyscanner';
    selectedCurrency.value = 'EUR';
    isFormValid.value = false;
    hasTypeError.value = false;
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
