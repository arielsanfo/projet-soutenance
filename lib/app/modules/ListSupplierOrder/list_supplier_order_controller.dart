import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';

class ListSupplierOrderController extends GetxController {
  final supplierOrders = <SupplierOrder>[].obs;
  final isLoading = false.obs;
  late final Isar isar;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    loadSupplierOrders();
  }

  Future<void> loadSupplierOrders() async {
    isLoading.value = true;
    final result =
        await isar.supplierOrders.where().sortByOrderDateDesc().findAll();
    supplierOrders.assignAll(result);
    isLoading.value = false;
  }

  void goToDetails(SupplierOrder order) {
    Get.toNamed('/detail-supplier-order', arguments: order);
  }
}
