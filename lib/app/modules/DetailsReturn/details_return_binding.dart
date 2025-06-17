import 'package:get/get.dart';

import 'details_return_controller.dart';

class DetailsReturnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsReturnController>(
      () => DetailsReturnController(),
    );
  }
}
