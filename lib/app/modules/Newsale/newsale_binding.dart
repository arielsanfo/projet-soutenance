import 'package:get/get.dart';

import 'newsale_controller.dart';

class NewsaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsaleController>(
      () => NewsaleController(),
    );
  }
}
