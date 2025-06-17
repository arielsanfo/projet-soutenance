import 'package:get/get.dart';

import 'supplier_list_controller.dart';

class SupplierListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierListController>(
      () => SupplierListController(),
    );
  }
}
