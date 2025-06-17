import 'package:get/get.dart';

import 'list_supplier_order_controller.dart';

class ListSupplierOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListSupplierOrderController>(
      () => ListSupplierOrderController(),
    );
  }
}
