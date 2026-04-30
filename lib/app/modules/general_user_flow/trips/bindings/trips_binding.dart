import 'package:get/get.dart';

import '../controller/trips_controller.dart';

class TripsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripsController>(() => TripsController());
  }
}
