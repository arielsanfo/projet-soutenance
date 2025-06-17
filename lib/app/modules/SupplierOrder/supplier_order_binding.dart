import 'package:get/get.dart';

import 'supplier_order_controller.dart';

class SupplierOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierOrderController>(
      () => SupplierOrderController(),
    );
  }
}
