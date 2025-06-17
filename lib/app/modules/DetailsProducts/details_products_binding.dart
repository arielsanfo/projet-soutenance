import 'package:get/get.dart';

import 'details_products_controller.dart';

class DetailsProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsProductsController>(
      () => DetailsProductsController(),
    );
  }
}
