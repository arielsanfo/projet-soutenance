import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/controller/customerService.dart';
import 'package:flutter_application_1/app/data/storage.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  Customer currentCustomer =
      Customer(name: '', email: '', phone: '', address: '');

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    CustomerService customerServices = CustomerService(isar);
    customerServices.getCustomerById(100).then((customers) {
      if (customers != null) {
        currentCustomer = customers;
        emailController.text = customers.email ?? "";
        passwordController.text = 'defaultPassword'; // Set a default password
      }
    });
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
