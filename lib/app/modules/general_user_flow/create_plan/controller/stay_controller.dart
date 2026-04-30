
import 'package:get/get.dart';

class StayController extends GetxController {
  // City list
  var locations = <StayLocation>[
    StayLocation(cityName: "Rome, Italy"),
    StayLocation(cityName: "Venice, Italy"),
  ].obs;

  // Total days calculation
  int get totalDays => locations.fold(0, (sum, item) => sum + item.stayDays.value);

  void incrementDays(int index) => locations[index].stayDays.value++;
  
  void decrementDays(int index) {
    if (locations[index].stayDays.value > 1) {
      locations[index].stayDays.value--;
    }
  }

  void selectAccommodation(int index, String type) => locations[index].selectedAccommodation.value = type;
  void selectTransport(int index, String type) => locations[index].selectedTransport.value = type;
}

class StayLocation {
  final String cityName;
  var stayDays = 3.obs;
  var selectedAccommodation = "".obs;
  var selectedTransport = "".obs;

  StayLocation({required this.cityName, int initialDays = 3}) {
    stayDays.value = initialDays;
  }
}