import 'package:get/get.dart';

import 'iventory_controller.dart';

class IventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IventoryController>(
      () => IventoryController(),
    );
  }
}
