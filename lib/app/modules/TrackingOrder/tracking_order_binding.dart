import 'package:get/get.dart';

import 'tracking_order_controller.dart';

class TrackingOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingOrderController>(
      () => TrackingOrderController(),
    );
  }
}
