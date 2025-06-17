import 'package:get/get.dart';

import 'final_inventory_controller.dart';

class FinalInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalInventoryController>(
      () => FinalInventoryController(),
    );
  }
}
