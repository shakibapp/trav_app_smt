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



  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

 

  void removeActivity(String activityId) {
    selectedActivities.removeWhere((a) => a.id == activityId);
  }

  // Update activity in local list
  void updateActivityInList(Activity updatedActivity) {
    final activities = itineraryOverview.value.activities;
    if (activities != null) {
      final index = activities.indexWhere((a) => a.id == updatedActivity.id);
      if (index != -1) {
        activities[index] = updatedActivity;
        itineraryOverview.refresh();
      }
    }
  }

  // Add activity to local list
  void addActivityToList(Activity newActivity) {
    final activities = itineraryOverview.value.activities;
    if (activities != null) {
      activities.add(newActivity);
      itineraryOverview.refresh();
    }
  }

  // Delete activity from local list
  void deleteActivityFromList(String activityId) {
    final activities = itineraryOverview.value.activities;
    if (activities != null) {
      activities.removeWhere((a) => a.id == activityId);
      itineraryOverview.refresh();
    }
  }

  // Update activity status in local list
  void updateActivityStatus(String activityId, String newStatus) {
    final activities = itineraryOverview.value.activities;
    if (activities != null) {
      final index = activities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        final updatedActivity = activities[index];
        activities[index] = Activity(
          id: updatedActivity.id,
          itineraryId: updatedActivity.itineraryId,
          name: updatedActivity.name,
          dayNumber: updatedActivity.dayNumber,
          type: updatedActivity.type,
          startDate: updatedActivity.startDate,
          endDate: updatedActivity.endDate,
          startTime: updatedActivity.startTime,
          endTime: updatedActivity.endTime,
          location: updatedActivity.location,
          expense: updatedActivity.expense,
          status: newStatus,
          rating: updatedActivity.rating,
          createdAt: updatedActivity.createdAt,
          updatedAt: updatedActivity.updatedAt,
        );
        itineraryOverview.refresh();
      }
    }
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


  //stay ---
  RxInt selectedAccommodationIndex = 0.obs;
}
