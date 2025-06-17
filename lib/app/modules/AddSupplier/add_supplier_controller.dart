import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSupplierController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController productsController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  

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
