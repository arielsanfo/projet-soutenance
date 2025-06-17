import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsReturnController extends GetxController {
    String selectedStatus = 'En attente';
  final TextEditingController notesController = TextEditingController();

  final List<String> statusOptions = [
    'En attente',
    'Approuvé',
    'Refusé',
    'En cours de traitement',
    'Terminé',
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
