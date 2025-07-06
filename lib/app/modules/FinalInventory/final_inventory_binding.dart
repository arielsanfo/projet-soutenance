import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/productService.dart';
import 'final_inventory_controller.dart';

class FinalInventoryBinding extends Bindings {
  @override
  void dependencies() {
    final isar = Get.find<Isar>();
    Get.lazyPut<ProductService>(() => ProductService(isar));
    Get.lazyPut<FinalInventoryController>(() => FinalInventoryController(Get.find<ProductService>()));
  }
}
