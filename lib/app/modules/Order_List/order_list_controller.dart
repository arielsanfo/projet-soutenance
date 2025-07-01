import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';
import '../../data/controller/saleService.dart';

class OrderListController extends GetxController {
  final sales = <Sale>[].obs;
  final isLoading = false.obs;
  late final Isar isar;
  late final SaleService saleService;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    saleService = SaleService(isar);
    loadSales();
  }

  Future<void> loadSales() async {
    isLoading.value = true;
    final result = await saleService.getAllSales();
    sales.assignAll(result);
    isLoading.value = false;
  }

  void goToDetails(Sale sale) {
    Get.toNamed('/details-order', arguments: sale);
  }
}
