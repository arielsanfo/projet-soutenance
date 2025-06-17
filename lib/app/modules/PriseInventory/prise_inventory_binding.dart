import 'package:get/get.dart';

import 'prise_inventory_controller.dart';

class PriseInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PriseInventoryController>(
      () => PriseInventoryController(),
    );
  }
}
