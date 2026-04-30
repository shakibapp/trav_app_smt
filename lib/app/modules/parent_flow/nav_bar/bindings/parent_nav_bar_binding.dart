import 'package:get/get.dart';
import '../controller/parent_nav_bar_controller.dart';
import '../../parent_settings/controller/parent_settings_controller.dart';

class ParentNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentNavBarController>(() => ParentNavBarController());
    Get.lazyPut<ParentSettingsController>(() => ParentSettingsController());
  }
}
