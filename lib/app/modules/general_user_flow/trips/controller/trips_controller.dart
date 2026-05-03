import 'package:get/get.dart';

import '../../../../core/data/network/endpoints.dart';
import '../../../../core/data/network/netconfig.dart';
import '../models/trip_model.dart';

class TripsController extends GetxController {
  final selectedTabIndex =
      1.obs; // Default to Upcoming since all trips are upcoming

  final ongoingTrips = <AllTripDataModel>[].obs;
  final upcomingTrips = <AllTripDataModel>[].obs;
  final completedTrips = <AllTripDataModel>[].obs;

  final isLoading = false.obs;

  List<AllTripDataModel> get currentTrips {
    switch (selectedTabIndex.value) {
      case 0:
        return ongoingTrips;
      case 1:
        return upcomingTrips;
      case 2:
        return completedTrips;
      default:
        return ongoingTrips;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getTrips();
  }

  Future<void> getTrips() async {
    try {
      isLoading.value = true;
      final response = await NetworkConfigV1.instance.ApiRequestHandler(
        RequestMethod.GET,
        Urls.trips,
        null,
        is_auth: true,
      );

      if (response != null) {
        if (response is Map &&
            response.containsKey('success') &&
            response['success'] == true) {
          final tripResponse = TripListResponse.fromJson(
            response.cast<String, dynamic>(),
          );
          final trips = tripResponse.data.data;

          // Clear existing lists
          ongoingTrips.clear();
          upcomingTrips.clear();
          completedTrips.clear();

          // Categorize trips based on status
          for (final trip in trips) {
            switch (trip.status.toLowerCase()) {
              case 'ongoing':
                ongoingTrips.add(trip);
                break;
              case 'upcoming':
                upcomingTrips.add(trip);
                break;
              case 'completed':
                completedTrips.add(trip);
                break;
              default:
                // Default to upcoming if status is unknown
                upcomingTrips.add(trip);
                break;
            }
          }
        } else if (response is Map &&
            response.containsKey('data') &&
            response['data'] is List) {
          final trips = (response['data'] as List<dynamic>)
              .map((item) => AllTripDataModel.fromJson(item as Map<String, dynamic>))
              .toList();

          // Clear existing lists
          ongoingTrips.clear();
          upcomingTrips.clear();
          completedTrips.clear();

          // Categorize trips based on status
          for (final trip in trips) {
            switch (trip.status.toLowerCase()) {
              case 'ongoing':
                ongoingTrips.add(trip);
                break;
              case 'upcoming':
                upcomingTrips.add(trip);
                break;
              case 'completed':
                completedTrips.add(trip);
                break;
              default:
                // Default to upcoming if status is unknown
                upcomingTrips.add(trip);
                break;
            }
          }
        }
      }
    } catch (e) {
      // Handle error silently or show snackbar
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }
}
