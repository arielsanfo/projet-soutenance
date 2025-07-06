import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/productService.dart';
import 'iventory_controller.dart';

class IventoryBinding extends Bindings {
  @override
  void dependencies() {
    final isar = Get.find<Isar>();
    Get.lazyPut<ProductService>(() => ProductService(isar));
    Get.lazyPut<IventoryController>(() => IventoryController(Get.find<ProductService>()));
  }
}
