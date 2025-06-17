import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierOrderController extends GetxController {
    final List<Map<String, dynamic>> products = [];
  final TextEditingController internalRefController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? selectedSupplier;
  String? selectedProduct;
  String quantity = '';

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
