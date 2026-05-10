import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/modules/general_user_flow/home/models/itinerary_details_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/home/models/trip_detail_model.dart'
    hide PriorityRemainder;
import 'package:hamishphipps/app/modules/general_user_flow/trips/models/trip_model.dart';

class HomeController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

  final TextEditingController parentEmailController = TextEditingController();
  final RxString selectedTripId = ''.obs;
  final RxString selectedItineraryId = ''.obs;
  final RxBool showVisaReminderPrompt = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingTrips();
  }

  final RxList<AllTripDataModel> upcomingTripsFromApi =
      <AllTripDataModel>[].obs;
  final RxBool isLoadingTrips = false.obs;
  Future<void> fetchUpcomingTrips() async {
    try {
      isLoadingTrips.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.trips,
        null,
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        upcomingTripsFromApi.value = List<AllTripDataModel>.from(
            response["data"]["data"]
                .map((e) => AllTripDataModel.fromJson(e))
                .where((trip) => trip.status?.toLowerCase() == 'upcoming'));

        final firstTripId = upcomingTripsFromApi.isNotEmpty
            ? upcomingTripsFromApi.first.id?.toString() ?? ''
            : '';
        if (firstTripId.isNotEmpty && selectedTripId.value.isEmpty) {
          await getTripDetailById(firstTripId);
        }
      } else {
        log(
          " Failed to fetch upcoming trips: ${response?['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      log("Error fetching upcoming trips: $e");
    } finally {
      isLoadingTrips.value = false;
    }
  }

  //get trip details by trip id
  final Rx<TripDetailModel> tripDetail = TripDetailModel(
    itineraries: [],
    remainders: [],
    priorityRemainders: [],
  ).obs;
  final RxBool isLoadingTripDetail = false.obs;
  Future<void> getTripDetailById(String tripId) async {
    if (tripId.isEmpty) {
      return;
    }

    selectedTripId.value = tripId;
    selectedItineraryId.value = '';
    showVisaReminderPrompt.value = false;
    itineraryDetail.value = ItineraryDetailsModel();

    try {
      isLoadingTripDetail.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.tripDetail}/$tripId",
        {},
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        tripDetail.value = TripDetailModel.fromJson(response['data']);
        log(" Trip detail fetched successfully for trip ID: $tripId");
        log(" Trip Detail: ${response['data']}");
      } else {
        log(
          "Failed to fetch trip detail: ${response?['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      log("Error fetching trip detail: $e");
    } finally {
      isLoadingTripDetail.value = false;
    }
  }

  //itinerary details by itinerary id
  final Rx<ItineraryDetailsModel> itineraryDetail = ItineraryDetailsModel().obs;
  final RxBool isLoadingItineraryDetail = false.obs;
  Future<void> getItineraryDetailById(String itineraryId) async {
    if (itineraryId.isEmpty) {
      return;
    }

    selectedItineraryId.value = itineraryId;
    showVisaReminderPrompt.value = false;

    try {
      isLoadingItineraryDetail.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.baseUrl}/trips/itinerary/$itineraryId",
        {},
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        itineraryDetail.value = ItineraryDetailsModel.fromJson(
          response['data'],
        );
        _normalizeItineraryPriorityRemainders();
        log(
          " Itinerary detail fetched successfully for itinerary ID: $itineraryId",
        );
        log(" Itinerary Detail: success  ${response['message']}");
      } else {
        log(
          "Failed to fetch itinerary detail: ${response?['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      log("Error fetching itinerary detail: $e");
    } finally {
      isLoadingItineraryDetail.value = false;
    }
  }

  void _normalizeItineraryPriorityRemainders() {
    final current = itineraryDetail.value;
    if (current.priorityRemainders == null) {
      showVisaReminderPrompt.value = false;
      return;
    }

    final normalizedPriorityRemainders = current.priorityRemainders!
        .map(
          (reminder) => PriorityRemainder(
            id: reminder.id,
            tripId: reminder.tripId,
            itineraryId: reminder.itineraryId,
            passportCountry: reminder.passportCountry,
            passportExpiry: reminder.passportExpiry,
            isVisaConfirmed: reminder.isVisaConfirmed ?? false,
            noVisaRequired: reminder.noVisaRequired ?? false,
            needsAttention: reminder.needsAttention ?? false,
            visaNotes: reminder.visaNotes,
            haveInsurance: reminder.haveInsurance,
            status: reminder.status,
            createdAt: reminder.createdAt,
            updatedAt: reminder.updatedAt,
          ),
        )
        .toList();

    itineraryDetail.value = ItineraryDetailsModel(
      id: current.id,
      tripId: current.tripId,
      name: current.name,
      days: current.days,
      accommodation: current.accommodation,
      transportation: current.transportation,
      createdAt: current.createdAt,
      updatedAt: current.updatedAt,
      remainders: current.remainders,
      priorityRemainders: normalizedPriorityRemainders,
      accommodations: current.accommodations,
      transportations: current.transportations,
      activities: current.activities,
    );

    showVisaReminderPrompt.value = normalizedPriorityRemainders.any(
      (reminder) =>
          reminder.isVisaConfirmed == false &&
          reminder.noVisaRequired == false &&
          reminder.needsAttention == false,
    );
  }

  void markSelectedItineraryVisaReminderUpdated() {
    final current = itineraryDetail.value;
    if (current.priorityRemainders == null) {
      return;
    }

    final updatedPriorityRemainders = current.priorityRemainders!.map((
      reminder,
    ) {
      if (reminder.isVisaConfirmed == false &&
          reminder.noVisaRequired == false &&
          reminder.needsAttention == false) {
        return PriorityRemainder(
          id: reminder.id,
          tripId: reminder.tripId,
          itineraryId: reminder.itineraryId,
          passportCountry: reminder.passportCountry,
          passportExpiry: reminder.passportExpiry,
          isVisaConfirmed: reminder.isVisaConfirmed,
          noVisaRequired: reminder.noVisaRequired,
          needsAttention: true,
          visaNotes: reminder.visaNotes,
          haveInsurance: reminder.haveInsurance,
          status: reminder.status,
          createdAt: reminder.createdAt,
          updatedAt: reminder.updatedAt,
        );
      }
      return reminder;
    }).toList();

    itineraryDetail.value = ItineraryDetailsModel(
      id: current.id,
      tripId: current.tripId,
      name: current.name,
      days: current.days,
      accommodation: current.accommodation,
      transportation: current.transportation,
      createdAt: current.createdAt,
      updatedAt: current.updatedAt,
      remainders: current.remainders,
      priorityRemainders: updatedPriorityRemainders,
      accommodations: current.accommodations,
      transportations: current.transportations,
      activities: current.activities,
    );

    showVisaReminderPrompt.value = false;
  }

  //invite parent by email to view trip details
  final RxBool isInvitingParent = false.obs;
  Future<void> inviteParentByEmail() async {
    if (parentEmailController.text.isEmpty) {
      return;
    }

    try {
      isInvitingParent.value = true;
      final payload = {
        "email": parentEmailController.text.trim(),
      };
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        "${Urls.baseUrl}/users/invite-parent",
        jsonEncode(payload),
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        Get.back();
        Get.snackbar(
          'Invitation Sent',
          'Parent has been invited successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        parentEmailController.clear();
      } else {
        Get.snackbar(
          'Invitation Failed',
          response?['message'] ?? 'Unknown error occurred',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Error inviting parent: $e");
    } finally {
      parentEmailController.clear();
      isInvitingParent.value = false;
    }
  }
}
