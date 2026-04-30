import 'package:get/get.dart';

import '../models/trip_model.dart';

class TripsController extends GetxController {
  final selectedTabIndex = 0.obs;

  final ongoingTrips = <TripData>[
    TripData(
      location: 'Rome, Italy',
      imageUrl: 'assets/images/rome.png',
      startDate: 'Mar 18',
      endDate: 'Mar 28 2026',
      days: 5,
      priceRange: '\$80-\$150',
      vibe: 'Luxury',
      accommodation: 'Airbnb/Apartment',
    ),
  ].obs;

  final upcomingTrips = <TripData>[].obs;

  final completedTrips = <TripData>[].obs;

  List<TripData> get currentTrips {
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

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }
}
