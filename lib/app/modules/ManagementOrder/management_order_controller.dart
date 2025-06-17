import 'package:get/get.dart';

class ManagementOrderController extends GetxController {
    bool isClientSelected = true;
  final List<Map<String, dynamic>> orders = [
    {
      'type': 'client',
      'id': '#C20240078',
      'name': 'L. Moreau',
      'date': '05 Mai 2024',
      'amount': 42.10,
      'status': 'En préparation',
    },
    {
      'type': 'client',
      'id': '#C20240079',
      'name': 'A. Dubois',
      'date': '04 Mai 2024',
      'amount': 89.90,
      'status': 'Envoyée',
    },
    {
      'type': 'supplier',
      'id': '#F20240012',
      'name': 'BioFrais',
      'date': '03 Mai 2024',
      'amount': 250.00,
      'status': 'En préparation',
    },
  ];

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
