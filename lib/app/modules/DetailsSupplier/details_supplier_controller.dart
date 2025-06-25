import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../../app/data/storage.dart';
// import '../../../app/services/supplier_service.dart';
import '../../data/controller/supplierService.dart';

class DetailsSupplierController extends GetxController {
  final supplier = Rxn<Supplier>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSupplierData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Charger les données du fournisseur
  void _loadSupplierData() {
    final args = Get.arguments;
    if (args != null && args is Supplier) {
      supplier.value = args;
    } else {
      Get.snackbar(
        'Erreur',
        'Fournisseur non trouvé',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  /// Extraire les produits des notes
  String get products {
    if (supplier.value?.notes == null) return 'Aucun produit spécifié';

    final notes = supplier.value!.notes!;
    final lines = notes.split('\n');

    for (final line in lines) {
      if (line.startsWith('Produits:')) {
        return line.replaceFirst('Produits:', '').trim();
      }
    }

    return 'Aucun produit spécifié';
  }

  /// Extraire les conditions de paiement des notes
  String get paymentConditions {
    if (supplier.value?.notes == null) return 'Non spécifié';

    final notes = supplier.value!.notes!;
    final lines = notes.split('\n');

    for (final line in lines) {
      if (line.startsWith('Conditions de paiement:')) {
        return line.replaceFirst('Conditions de paiement:', '').trim();
      }
    }

    return 'Non spécifié';
  }

  /// Naviguer vers la modification
  void navigateToEdit() {
    if (supplier.value != null) {
      Get.toNamed('/add-supplier', arguments: supplier.value);
    }
  }

  /// Supprimer le fournisseur
  Future<void> deleteSupplier() async {
    if (supplier.value == null) return;

    try {
      final isar = Get.find<Isar>();
      final supplierService = SupplierService(isar);
      await supplierService.deleteSupplier(supplier.value!.id!);
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer le fournisseur',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void navigateToSupplierOrders() {
    // final supplier = this.supplier.value;
    // if (supplier != null) {
      Get.toNamed(Routes.LIST_SUPPLIER_ORDER, arguments: supplier);
    // }
  }
}
