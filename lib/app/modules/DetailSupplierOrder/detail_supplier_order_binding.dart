import 'package:get/get.dart';

import 'detail_supplier_order_controller.dart';

class DetailSupplierOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailSupplierOrderController>(
      () => DetailSupplierOrderController(),
    );
  }
}
