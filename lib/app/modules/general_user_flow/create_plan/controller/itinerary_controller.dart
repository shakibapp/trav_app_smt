import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/view/tripItinerary_overview_screen.dart';

class ItineraryController extends GetxController {
  // Mock Data for the list
  var itineraryList = <ItineraryItem>[
    ItineraryItem(
      cityName: "Rome, Italy",
      duration: "3 Nights",
      imageUrl: "assets/images/rome.png",
      statusIcons: ["flight", "hotel", "activity"],
    ),
    ItineraryItem(
      cityName: "Venice, Italy",
      duration: "3 Nights",
      imageUrl: "assets/images/rome.png",
      statusIcons: ["train", "hotel", "activity"],
    ),
  ].obs;

  void applyOptimization() {
    // Logic to optimize route
    Get.to(()=>TripItineraryView());
  }

  void markAsDone(String task) {
    print("$task marked as completed");
  }
}

class ItineraryItem {
  final String cityName;
  final String duration;
  final String imageUrl;
  final List<String> statusIcons; // For the small circular badges

  ItineraryItem({
    required this.cityName,
    required this.duration,
    required this.imageUrl,
    required this.statusIcons,
  });
}
