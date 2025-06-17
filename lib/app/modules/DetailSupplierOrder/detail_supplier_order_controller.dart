import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailSupplierOrderController extends GetxController {
    String orderStatus = 'Envoyée';
  final TextEditingController notesController = TextEditingController();

  // Données de démonstration
  final List<Map<String, dynamic>> orderItems = [
    {
      'name': 'Huile d\'Olive Bio (Carton de 12)',
      'quantity': 2,
      'unitPrice': 18.50,
      'image': 'assets/oil.png',
    },
    {
      'name': 'Pâtes Complètes (Pack de 6)',
      'quantity': 5,
      'unitPrice': 4.20,
      'image': 'assets/pasta.png',
    },
    {
      'name': 'Riz Basmati (Sac de 5kg)',
      'quantity': 3,
      'unitPrice': 12.90,
      'image': 'assets/rice.png',
    },
  ];

  double get subtotal => orderItems.fold(
    0,
    (sum, item) => sum + (item['quantity'] * item['unitPrice']),
  );

  double get vat => subtotal * 0.2;
  double get total => subtotal + vat;

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
