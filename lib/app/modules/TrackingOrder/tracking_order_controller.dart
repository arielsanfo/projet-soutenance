import 'package:get/get.dart';

class TrackingOrderController extends GetxController {
    final List<Map<String, dynamic>> orderItems = [
    {'name': 'Huile d\'Olive Bio (Carton de 12)', 'quantity': 2},
    {'name': 'Pâtes Complètes (Pack de 6)', 'quantity': 5},
    {'name': 'Riz Basmati (Sac de 5kg)', 'quantity': 3},
  ];

  double get total => orderItems.fold(
    0,
    (sum, item) => sum + (item['quantity'] * 10.0),
  ); // Prix fictif


  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
