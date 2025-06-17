import 'package:get/get.dart';

import 'details_client_controller.dart';

class DetailsClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsClientController>(
      () => DetailsClientController(),
    );
  }
}
