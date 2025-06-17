import 'package:get/get.dart';

import 'management_order_controller.dart';

class ManagementOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagementOrderController>(
      () => ManagementOrderController(),
    );
  }
}
