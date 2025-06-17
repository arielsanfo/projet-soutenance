import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriseInventoryController extends GetxController {
    final TextEditingController product1Controller = TextEditingController(
    text: '56',
  );
  final TextEditingController product2Controller = TextEditingController(
    text: '18',
  );

  // Variables for dropdown
  String? selectedReason;
  final List<String> reasons = [
    'Casse',
    'Vol',
    'Erreur de saisie',
    'Erreur de livraison',
    'Autre',
  ];

  @override
  void dispose() {
    product1Controller.dispose();
    product2Controller.dispose();
    super.dispose();
  }

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
