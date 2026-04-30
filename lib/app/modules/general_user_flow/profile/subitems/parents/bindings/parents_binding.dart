import 'package:get/get.dart';

import '../controller/parents_controller.dart';

class ParentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentsController>(() => ParentsController());
  }
}
