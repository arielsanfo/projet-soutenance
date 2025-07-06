import 'package:get/get.dart';

import 'dettes_controller.dart';

class DettesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DettesController>(
      () => DettesController(),
    );
  }
}
