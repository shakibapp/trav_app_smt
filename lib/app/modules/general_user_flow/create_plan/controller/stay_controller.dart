// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
// import 'package:hamishphipps/app/core/data/network/endpoints.dart';
// import 'package:hamishphipps/app/core/data/network/netconfig.dart';
// import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/view/trip_details_screen.dart';


// class StayController extends GetxController {
//   String? tripId;

//   var locations = <StayLocation>[].obs;

//   // Total days calculation
//   int get totalDays =>
//       locations.fold(0, (sum, item) => sum + item.stayDays.value);

//   /// Distribute total days equally among all cities
//   void distributeDaysToCities(int totalDays) {
//     if (locations.isEmpty) return;

//     final daysPerCity = (totalDays / locations.length).floor();
//     final remainder = totalDays % locations.length;

//     for (int i = 0; i < locations.length; i++) {
//       locations[i].stayDays.value = daysPerCity + (i < remainder ? 1 : 0);
//     }
//     locations.refresh();
//   }

//   void incrementDays(int index) => locations[index].stayDays.value++;

//   void decrementDays(int index) {
//     if (locations[index].stayDays.value > 1) {
//       locations[index].stayDays.value--;
//     }
//   }

//   void selectAccommodation(int index, String type) {
//     locations[index].selectedAccommodation.value = type;
//     updateItinerary(index);
//   }

//   void selectTransport(int index, String type) {
//     locations[index].selectedTransport.value = type;
//     updateItinerary(index);
//   }

//   void loadFromTripResponse(Map<String, dynamic> tripData) {
//     tripId = tripData['id'] as String?;

//     final itineraries = tripData['itineraries'];
//     if (itineraries is List) {
//       locations.assignAll(itineraries.map((item) {
//         final data = item as Map<String, dynamic>;
//         return StayLocation(
//           cityName: data['name']?.toString() ?? '',
//           itineraryId: data['id']?.toString(),
//           initialDays: (data['days'] is int ? data['days'] as int : 1),
//           selectedAccommodation:
//               data['accommodation']?.toString() ?? 'Not Sure Yet',
//           selectedTransport: data['transportation']?.toString() ??
//               data['transport']?.toString() ??
//               'Not Sure Yet',
//         );
//       }).toList());
//     }
//   }

//   Future<void> updateItinerary(int index) async {
//     final location = locations[index];
//     // if (location.itineraryId == null || location.itineraryId!.isEmpty) {
//     //   return;
//     // }

//     final payload = {
//       'accommodation': location.selectedAccommodation.value,
//       'transportation': location.selectedTransport.value,
//     };

//     final response = await NetworkConfigV1.instance.ApiRequestHandler(
//       RequestMethod.PUT,
//       '${Urls.baseUrl}/trips/itinerary/${location.itineraryId}',
//       jsonEncode(payload),
//       is_auth: true,
//     );

//     if (response != null && response['success'] == true) {
//       AppSnackbar.success('Itinerary updated successfully.');
//     } else {
//       AppSnackbar.failed('Failed to update itinerary.');
//     }
//   }

//   void goTripDetails(){
//     Get.to(() => TripDetailsScreen(tripId:tripId.toString()));
//   }
// }

// class StayLocation {
//   final String cityName;
//   final String? itineraryId;
//   var stayDays = 1.obs;
//   var selectedAccommodation = ''.obs;
//   var selectedTransport = ''.obs;

//   StayLocation({
//     required this.cityName,
//     this.itineraryId,
//     int initialDays = 1,
//     String selectedAccommodation = 'Not Sure Yet',
//     String selectedTransport = 'Not Sure Yet',
//   }) {
//     stayDays.value = initialDays;
//     this.selectedAccommodation.value = selectedAccommodation;
//     this.selectedTransport.value = selectedTransport;
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/view/trip_details_screen.dart';

class StayController extends GetxController {
  String? tripId;

  var locations = <StayLocation>[].obs;

  int get totalDays =>
      locations.fold(0, (sum, item) => sum + item.stayDays.value);

  void distributeDaysToCities(int totalDays) {
    if (locations.isEmpty) return;
    final daysPerCity = (totalDays / locations.length).floor();
    final remainder = totalDays % locations.length;
    for (int i = 0; i < locations.length; i++) {
      locations[i].stayDays.value = daysPerCity + (i < remainder ? 1 : 0);
    }
    locations.refresh();
  }

  void incrementDays(int index) => locations[index].stayDays.value++;

  void decrementDays(int index) {
    if (locations[index].stayDays.value > 1) {
      locations[index].stayDays.value--;
    }
  }

  void selectAccommodation(int index, String type) {
    final location = locations[index];

    // ✅ Guard: ignore tap if already loading
    if (location.isUpdating.value) return;

    // ✅ Guard: ignore tap if same value already selected
    if (location.selectedAccommodation.value == type) return;

    location.selectedAccommodation.value = type;
    location.updatingField.value = 'accommodation';
    updateItinerary(index);
  }

  void selectTransport(int index, String type) {
    final location = locations[index];

    // ✅ Guard: ignore tap if already loading
    if (location.isUpdating.value) return;

    // ✅ Guard: ignore tap if same value already selected
    if (location.selectedTransport.value == type) return;

    location.selectedTransport.value = type;
    location.updatingField.value = 'transport';
    updateItinerary(index);
  }

  void loadFromTripResponse(Map<String, dynamic> tripData) {
    tripId = tripData['id'] as String?;
    final itineraries = tripData['itineraries'];
    if (itineraries is List) {
      locations.assignAll(itineraries.map((item) {
        final data = item as Map<String, dynamic>;
        return StayLocation(
          cityName: data['name']?.toString() ?? '',
          itineraryId: data['id']?.toString(),
          initialDays: (data['days'] is int ? data['days'] as int : 1),
          selectedAccommodation:
              data['accommodation']?.toString() ?? 'Not Sure Yet',
          selectedTransport: data['transportation']?.toString() ??
              data['transport']?.toString() ??
              'Not Sure Yet',
        );
      }).toList());
    }
  }

  Future<void> updateItinerary(int index) async {
    final location = locations[index];

    // ✅ Prevent concurrent calls
    if (location.isUpdating.value) return;

    // snapshot values before async gap
    final accommodationSnap = location.selectedAccommodation.value;
    final transportSnap = location.selectedTransport.value;

    location.isUpdating.value = true;

    try {
      final payload = {
        'accommodation': accommodationSnap,
        'transportation': transportSnap,
      };

      final response = await NetworkConfigV1.instance.ApiRequestHandler(
        RequestMethod.PUT,
        '${Urls.baseUrl}/trips/itinerary/${location.itineraryId}',
        jsonEncode(payload),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        AppSnackbar.success('Updated successfully.');
      } else {
        // ✅ On failure: revert to previous value
        _revertOnFailure(location, index);
        AppSnackbar.failed('Failed to update. Please try again.');
      }
    } catch (e) {
      _revertOnFailure(location, index);
      AppSnackbar.failed('Something went wrong. Please try again.');
    } finally {
      // ✅ Always clear loading state
      location.isUpdating.value = false;
      location.updatingField.value = '';
    }
  }

  void _revertOnFailure(StayLocation location, int index) {
    if (location.updatingField.value == 'accommodation') {
      location.selectedAccommodation.value =
          location.previousAccommodation;
    } else if (location.updatingField.value == 'transport') {
      location.selectedTransport.value =
          location.previousTransport;
    }
  }

  void goTripDetails() {
    Get.to(() => TripDetailsScreen(tripId: tripId.toString()));
  }
}

class StayLocation {
  final String cityName;
  final String? itineraryId;
  var stayDays = 1.obs;
  var selectedAccommodation = ''.obs;
  var selectedTransport = ''.obs;

  // ✅ Loading & revert state
  var isUpdating = false.obs;
  var updatingField = ''.obs;
  String previousAccommodation = 'Not Sure Yet';
  String previousTransport = 'Not Sure Yet';

  StayLocation({
    required this.cityName,
    this.itineraryId,
    int initialDays = 1,
    String selectedAccommodation = 'Not Sure Yet',
    String selectedTransport = 'Not Sure Yet',
  }) {
    stayDays.value = initialDays;
    this.selectedAccommodation.value = selectedAccommodation;
    this.selectedTransport.value = selectedTransport;
    previousAccommodation = selectedAccommodation;
    previousTransport = selectedTransport;

    // ✅ Track previous value before each change for revert
    this.selectedAccommodation.listen((val) {
      if (!isUpdating.value) previousAccommodation = val;
    });
    this.selectedTransport.listen((val) {
      if (!isUpdating.value) previousTransport = val;
    });
  }
}