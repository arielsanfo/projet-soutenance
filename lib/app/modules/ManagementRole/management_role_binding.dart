import 'package:get/get.dart';

import 'management_role_controller.dart';

class ManagementRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagementRoleController>(
      () => ManagementRoleController(),
    );
  }
}
