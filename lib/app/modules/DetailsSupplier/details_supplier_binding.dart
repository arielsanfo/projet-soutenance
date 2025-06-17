import 'package:get/get.dart';

import 'details_supplier_controller.dart';

class DetailsSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsSupplierController>(
      () => DetailsSupplierController(),
    );
  }
}
