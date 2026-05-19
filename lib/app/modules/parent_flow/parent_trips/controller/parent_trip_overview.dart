// parent_trip_overview_controller.dart

import 'dart:developer';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_trips/model/trip_overview_model.dart';

class ParentTripOverviewController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;

  @override
  void onInit() {
    super.onInit();
    getOverViewTrip();
  }

  final Rx<TripOverviewModel> tripOverView = TripOverviewModel().obs;
  final RxBool isTripOverViewLoadin = false.obs;

  Future<void> getOverViewTrip() async {
    try {
      isTripOverViewLoadin.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.baseUrl}/trips/parent/route",
        {},
        is_auth: true,
      );
      if (response != null && response["success"] == true) {
        tripOverView.value = TripOverviewModel.fromJson(response["data"]);
        log("get parent route success ${response["message"]}");
      } else {
        log("Get parent trip route failed ${response["message"]}");
      }
    } catch (e) {
      log("get parent trip route error ${e.toString()}");
    } finally {
      isTripOverViewLoadin.value = false;
    }
  }
}