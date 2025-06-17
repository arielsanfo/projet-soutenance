import 'package:get/get.dart';

import 'reception_controller.dart';

class ReceptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceptionController>(
      () => ReceptionController(),
    );
  }
}
