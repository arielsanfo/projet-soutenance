import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/customerService.dart';
import '../../data/storage.dart';

class AddClientController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  late final CustomerService customerService;
  Customer? customerToEdit; // Client en cours de modification

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    customerService = CustomerService(isar);

    // Vérifier si on est en mode modification
    final customer = Get.arguments as Customer?;
    if (customer != null) {
      customerToEdit = customer;
      _loadCustomerData(customer);
    }
  }

  void _loadCustomerData(Customer customer) {
    final nameParts = (customer.name ?? '').split(' ');
    firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
    lastNameController.text =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    emailController.text = customer.email ?? '';
    phoneController.text = customer.phone ?? '';
    addressController.text = customer.address ?? '';
    notesController.text = customer.notes ?? '';
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

  Future<void> saveCustomer() async {
    final fullName =
        firstNameController.text.trim() + ' ' + lastNameController.text.trim();

    if (customerToEdit != null) {
      // Mode modification : mettre à jour le client existant
      customerToEdit!.name = fullName;
      customerToEdit!.email = emailController.text.trim();
      customerToEdit!.phone = phoneController.text.trim();
      customerToEdit!.address = addressController.text.trim();
      customerToEdit!.notes = notesController.text.trim();

      await customerService.updateCustomer(customerToEdit!);
    } else {
      // Mode création : créer un nouveau client
      final customer = Customer(
        name: fullName,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        notes: notesController.text.trim(),
      );
      await customerService.saveCustomer(customer);
    }

    resetFields();
  }

  void resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    notesController.clear();
  }
}
