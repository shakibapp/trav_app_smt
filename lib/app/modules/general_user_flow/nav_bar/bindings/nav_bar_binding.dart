import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/controller/add_activity_controller.dart';

import '../../create_plan/controller/create_plan_calender_controller.dart';
import '../controller/nav_bar_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../trips/controller/trips_controller.dart';
import '../../home/controller/home_controller.dart';

class NavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavBarController>(() => NavBarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<TripsController>(() => TripsController());

    Get.lazyPut<DatePickerController>(() => DatePickerController());
    Get.lazyPut<AddActivityController>(
      () => AddActivityController(),
      tag: 'add_activity',
    );
  
  }
}
