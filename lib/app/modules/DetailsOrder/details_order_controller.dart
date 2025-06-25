import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';

class DetailsOrderController extends GetxController {
  final sale = Rxn<Sale>();
  final saleItems = <SaleItem>[].obs;
  final customer = Rxn<Customer>();
  final isLoading = false.obs;
  late final Isar isar;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    final arg = Get.arguments;
    if (arg != null && arg is Sale) {
      sale.value = arg;
      loadDetails();
  }
  }

  Future<void> loadDetails() async {
    isLoading.value = true;
    if (sale.value != null) {
      await sale.value!.saleItems.load();
      saleItems.assignAll(sale.value!.saleItems.toList());
      await sale.value!.customerLink.load();
      customer.value = sale.value!.customerLink.value;
    }
    isLoading.value = false;
  }

  double get totalAmount => sale.value?.totalPrice ?? 0.0;
}
