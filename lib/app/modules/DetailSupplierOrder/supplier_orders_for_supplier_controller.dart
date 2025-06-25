import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';

class SupplierOrdersForSupplierController extends GetxController {
  final orders = <SupplierOrder>[].obs;
  final isLoading = false.obs;

  late final Isar isar;
  int? supplierId;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    supplierId = Get.arguments as int?;
    if (supplierId != null) {
      loadOrders();
    }
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    final result = await isar.supplierOrders
        .filter()
        .supplierLink((q) => q.idEqualTo(supplierId))
        .statusEqualTo(SupplierOrderStatusIsar.received)
        .findAll();
    orders.assignAll(result);
    isLoading.value = false;
  }
}
