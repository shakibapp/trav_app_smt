
import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/controller/add_activity_controller.dart';


class AddActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddActivityController>(
      () => AddActivityController(),
      tag: 'add_activity',
    );
  }
}