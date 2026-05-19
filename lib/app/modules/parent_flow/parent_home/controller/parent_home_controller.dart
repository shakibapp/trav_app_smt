import 'dart:developer';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_alerts/model/parent_alets_model.dart';
import 'package:hamishphipps/app/modules/parent_flow/parent_home/model/parent_home_model.dart';

class ParentHomeController extends GetxController {
  final _networkConfig = NetworkConfigV1.instance;

  final currentLocation = "Rome".obs;
  final checkInStatus = "Checked in at accomodation . 2:45 PM".obs;

  @override
  void onInit() {
    super.onInit();
    getParentHome();
    getParentAlerts();
  }

  final Rx<ParentHomeModel> parentHomeModel = ParentHomeModel().obs;
  final RxBool isParentHomeLoading = false.obs;
  Future<void> getParentHome() async {
    try {
      isParentHomeLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
          RequestMethod.GET, "${Urls.baseUrl}/trips/parent/status", {},
          is_auth: true);
      if (response != null && response['success'] == true) {
        parentHomeModel.value = ParentHomeModel.fromJson(response["data"]);
        log("get parent home date ${response["message"]} ");
      } else {
        log("get parent home date failed ${response["message"]}");
      }
    } catch (e) {
      log("get parent home error${e.toString()}");
    } finally {
      isParentHomeLoading.value = false;
    }
  }

  final RxList<ParentAlertModel> alerts = <ParentAlertModel>[].obs;
  final RxBool isAlertsLoading = false.obs;
  Future<void> getParentAlerts() async {
    try {
      isAlertsLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.baseUrl}/trips/parent/alerts",
        {},
        is_auth: true,
      );
      if (response != null && response['success'] == true) {
        final List data = response["data"] ?? [];
        alerts.value = data.map((e) => ParentAlertModel.fromJson(e)).toList();
        log("alerts fetched: ${alerts.length}");
      } else {
        log("alerts fetch failed: ${response?["message"]}");
      }
    } catch (e) {
      log("alerts error: ${e.toString()}");
    } finally {
      isAlertsLoading.value = false;
    }
  }
}
