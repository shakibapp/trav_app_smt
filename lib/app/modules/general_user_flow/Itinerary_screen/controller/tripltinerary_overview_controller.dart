import 'dart:developer';

import 'package:get/get.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/model/tripltinerary_overview_model.dart';

class ItineraryDetailsController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;
  // Observables

  RxInt selectedTabIndex = 0.obs;
  RxList<Activity> suggestedActivities = <Activity>[].obs;
  RxList<Activity> selectedActivities = <Activity>[].obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    
    getItineraryOverview("69eeed3b57523b7608fc8d67");
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // void addActivity(Activity activity) {
  //   final updatedActivity = activity.copyWith(isAdded: true);
  //   selectedActivities.add(updatedActivity);

  //   // Update suggested list
  //   final index = suggestedActivities.indexWhere((a) => a.id == activity.id);
  //   if (index != -1) {
  //     suggestedActivities[index] = updatedActivity;
  //   }
  // }

  void removeActivity(String activityId) {
    selectedActivities.removeWhere((a) => a.id == activityId);

    // Update suggested list
    //   final index = suggestedActivities.indexWhere((a) => a.id == activityId);
    //   if (index != -1) {
    //     suggestedActivities[index] = suggestedActivities[index].copyWith(isAdded: false);
    //   }
    // }

    // void addAccommodation(Accommodation accommodation) {
    //   if (!currentTrip.value.accommodations.any((a) => a.id == accommodation.id)) {
    //     currentTrip.value.accommodations.add(accommodation);
    //     currentTrip.refresh(); // Notify listeners
    //   }
    // }

    // void addTransport(Transport transport) {
    //   if (!currentTrip.value.transports.any((t) => t.id == transport.id)) {
    //     currentTrip.value.transports.add(transport);
    //     currentTrip.refresh(); // Notify listeners
    //   }
    // }

    // double getTotalCost() {
    //   double total = 0;
    //   total += currentTrip.value.accommodations.fold(0, (sum, a) => sum + a.price);
    //   total += currentTrip.value.transports.fold(0, (sum, t) => sum + t.price);
    //   total += selectedActivities.fold(0, (sum, a) => sum + a.price);
    //   return total;
  }

  String formatDate(DateTime date) {
    return AppDateFormatter.format(date);
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  // get  itinerary overview data
  final RxBool isLoadingOverview = false.obs;
  final Rx<TripItineraryOverviewModel> itineraryOverview =
      TripItineraryOverviewModel().obs;
  Future<void> getItineraryOverview(String tripId) async {
    try {
      isLoadingOverview.value = true;
      final response = await networkConfig.ApiRequestHandler(
          RequestMethod.GET, "${Urls.getItineraryDetails}$tripId", {},
          is_auth: true);
      if (response != null && response["success"] == true) {
        itineraryOverview.value =
            TripItineraryOverviewModel.fromJson(response["data"]);
        log("get itinerary overview success: ${response["message"]}");
      } else {
        log("get itinerary overview failed: ${response["message"]}");
      }
    } catch (e) {
      log("get itinerary overview error: $e");
    } finally {
      isLoadingOverview.value = false;
    }
  }
}
