import 'dart:convert';
import 'dart:developer';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
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




String toIsoDate(String value) {
  final date = DateFormat('dd/MM/yy').parseStrict(value);
  return DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).toIso8601String();
}
//create new transportation
  final RxBool isTransportationLoading = false.obs;
  Future<void> createTransportation(String id) async {
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
        "bookingReference": bookingReferenceController.text,
        "airline": airlineController.text,
        "flightNumber": flightNumberController.text,
        "terminal": terminalController.text,
        "gate": gateController.text,
        "currency":selectedCurrency.value,
        "totalCost": double.parse(totalCostController.text),
        "notes": notesController.text
      };
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.POST, "${Urls.createTransportation}/$id", jsonEncode(data),
          is_auth: true);
      if (response != null && response["success"]==true){
       await Get.put(ItineraryDetailsController()).getItineraryOverview(id);
        Get.back();
        AppSnackbar.success("${response["message"]}");
        log("create transportation success ${response["message"]}");
      }else{
        AppSnackbar.failed("${response["message"]}");
        log("Create Transportation failed ${response["message"]}");
      }
    } catch (e) {
      log("Create transportation error ${e.toString()}");
    }finally{
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
    selectedTransportationType.value = null;
    selectedBookingPlatform.value = 'Skyscanner';
    selectedCurrency.value = 'EUR';
    isFormValid.value = false;
    formKey.currentState?.reset();
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
