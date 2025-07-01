import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/customerService.dart';
import '../../data/storage.dart';
import 'package:flutter/material.dart';
// import 'package:app/routes/app_routes.dart';

class ClientListController extends GetxController {
  final RxString searchQuery = ''.obs;
  late final RxList<Customer> clients = <Customer>[].obs;
  late final RxList<Customer> filteredClients = <Customer>[].obs;
  late final CustomerService customerService;

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    customerService = CustomerService(isar);
    loadClients();
    ever(searchQuery, (_) => _filterClients());
  }

  Future<void> loadClients() async {
    clients.value = await customerService.getAllCustomers();
    _filterClients();
  }

  void _filterClients() {
    if (searchQuery.value.isEmpty) {
      filteredClients.value = clients;
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredClients.value = clients.where((client) {
        final name = (client.name ?? '').toLowerCase();
        final email = (client.email ?? '').toLowerCase();
        final phone = (client.phone ?? '').toLowerCase();

        return name.contains(query) ||
            email.contains(query) ||
            phone.contains(query);
      }).toList();
    }
  }

  Future<void> deleteCustomer(Customer customer) async {
    try {
      await customerService.delete(customer.id!);
      await loadClients(); // Recharger la liste
      Get.snackbar(
        'Succès',
        'Client supprimé avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer le client',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void editCustomer(Customer customer) {
    // Passer les données du client à la page de modification
    Get.toNamed(Routes.ADD_CLIENT, arguments: customer);
  }
    void navigateToDetails(Customer customer) {
    Get.toNamed(Routes.DETAILS_CLIENT, arguments: customer);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime lastPurchase;
  final double debt;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.lastPurchase,
    required this.debt,
  });
}
