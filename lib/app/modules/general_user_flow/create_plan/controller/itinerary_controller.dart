
import 'dart:developer';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/model/itinerary_details_model.dart';


class ItineraryController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

  // ── Itinerary Details ──────────────────────────────────────────────────────
  final RxBool isLoadingItineraryDetails = false.obs;
  final Rx<ItineraryDetailsModel> itineraryDetails = ItineraryDetailsModel().obs;

  Future<void> fetchItineraryDetails(String itineraryId) async {
    try {
      isLoadingItineraryDetails.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.baseUrl}/trips/itinerary/$itineraryId",
        null,
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        itineraryDetails.value =
            ItineraryDetailsModel.fromJson(response['data']);
        log("get itinerary details success: ${response['data']}");
      } else {
        log("Failed to fetch itinerary details: "
            "${response?['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      log("Error fetching itinerary details: $e");
    } finally {
      isLoadingItineraryDetails.value = false;
    }
  }

  // ── Optimization ───────────────────────────────────────────────────────────
  void applyOptimization() {
    // TODO: implement route optimization logic
    log("Applying route optimization...");
  }
}