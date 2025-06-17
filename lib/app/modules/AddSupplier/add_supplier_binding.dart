import 'package:get/get.dart';

import 'add_supplier_controller.dart';

class AddSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSupplierController>(
      () => AddSupplierController(),
    );
  }
}
