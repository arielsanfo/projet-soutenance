import 'package:get/get.dart';

import 'details_order_controller.dart';

class DetailsOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsOrderController>(
      () => DetailsOrderController(),
    );
  }
}
