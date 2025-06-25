import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';
import '../../data/controller/customerService.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';

class DetailsClientController extends GetxController {
  final isLoading = false.obs;
  final customer = Rxn<Customer>();
  final sales = <Sale>[].obs;
  final debts = <Debt>[].obs;
  final selectedTab = 0.obs; // 0: Infos, 1: Achats, 2: Dettes

  late final CustomerService customerService;
  late final Isar isar;
  int? customerId;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    customerService = CustomerService(isar);
    // Récupérer l'ID du client depuis les arguments
    final args = Get.arguments;
    if (args is Customer) {
      customerId = args.id;
    } else if (args is int) {
      customerId = args;
    } else if (args is Map && args['id'] != null) {
      customerId = args['id'];
    }
    if (customerId != null) {
      loadCustomerData(customerId!);
    }
  }

  Future<void> loadCustomerData(int id) async {
    isLoading.value = true;
    try {
      final c = await customerService.getCustomerById(id);
      if (c != null) {
        customer.value = c;
        // Charger les ventes
        final salesList = await isar.sales.filter().customerLink((q) => q.idEqualTo(id)).findAll();
        sales.assignAll(salesList);
        // Charger les dettes
        final debtsList = await customerService.getDebtsForCustomer(id);
        debts.assignAll(debtsList);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Enregistrer un paiement sur la première dette impayée
  Future<void> recordPayment({required double amount, required String method}) async {
    final unpaidDebt = debts.firstWhereOrNull((d) => d.status != DebtStatusIsar.paid);
    if (unpaidDebt == null) return;
    isLoading.value = true;
    try {
      await customerService.recordDebtPayment(
        debtId: unpaidDebt.id!,
        amountPaid: amount,
        paymentMethod: method,
      );
      await loadCustomerData(customerId!);
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation vers l'édition
  void editCustomer() {
    if (customer.value != null) {
      Get.toNamed(Routes.ADD_CLIENT, arguments: customer.value);
    }
  }

  // Changer d'onglet
  void selectTab(int index) => selectedTab.value = index;
}
