import 'package:get/get.dart';

import 'list_sale_controller.dart';

class ListSaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListSaleController>(
      () => ListSaleController(),
    );
  }
}
