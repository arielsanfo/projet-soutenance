import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderListController extends GetxController {
  String selectedStatus = 'En préparation';
  final TextEditingController trackingController = TextEditingController();
  final List<Map<String, dynamic>> items = [
    {'name': 'Café en grains (250g)', 'qty': 2, 'price': 7.50},
    {'name': 'Thé vert bio (100g)', 'qty': 1, 'price': 4.60},
    {'name': 'Sucre de canne (1kg)', 'qty': 3, 'price': 3.00},
  ];

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item['price'] * item['qty']));
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
