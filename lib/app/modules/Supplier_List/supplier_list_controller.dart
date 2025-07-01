import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../../app/data/storage.dart';
import '../../../app/data/controller/supplierService.dart';
import '../../../helpers/app_constante.dart';

class SupplierListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final suppliers = <Supplier>[].obs;
  final filteredSuppliers = <Supplier>[].obs;

  late final SupplierService supplierService;

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    supplierService = SupplierService(isar);
    
    // Enregistrer le callback de rafraîchissement
    AppRefreshManager.registerRefreshCallback(AppPageKeys.supplierList, loadSuppliers);
    
    loadSuppliers();
  }

  @override
  void onReady() {
    super.onReady();
    // Actualiser la liste quand on revient sur cette page
    loadSuppliers();
  }

  @override
  void onClose() {
    searchController.dispose();
    // Supprimer le callback de rafraîchissement
    AppRefreshManager.unregisterRefreshCallback(AppPageKeys.supplierList);
    super.onClose();
  }

  /// Charger tous les fournisseurs
  Future<void> loadSuppliers() async {
    try {
      isLoading.value = true;
      final allSuppliers = await supplierService.getAllSuppliers();
      suppliers.value = allSuppliers;
      filteredSuppliers.value = allSuppliers;
      
      // Afficher un message informatif si la liste est vide
      if (allSuppliers.isEmpty) {
        AppSnackbars.showInfo(
          'Information',
          'Aucun fournisseur trouvé. Commencez par ajouter votre premier fournisseur.',
        );
      }
    } catch (e) {
      AppSnackbars.showError(
        'Erreur',
        'Impossible de charger les fournisseurs: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Rechercher des fournisseurs
  Future<void> searchSuppliers(String query) async {
    try {
      if (query.isEmpty) {
        filteredSuppliers.value = suppliers;
        return;
      }

      final results = await supplierService.searchSuppliers(query);
      filteredSuppliers.value = results;
      
      // Afficher un message si aucun résultat
      if (results.isEmpty) {
        AppSnackbars.showInfo(
          'Recherche',
          'Aucun fournisseur trouvé pour "$query"',
        );
      }
    } catch (e) {
      AppSnackbars.showError(
        'Erreur',
        'Erreur lors de la recherche: ${e.toString()}',
      );
    }
  }

  /// Supprimer un fournisseur
  Future<void> deleteSupplier(Supplier supplier) async {
    try {
      isLoading.value = true;
      
      // Afficher un snackbar de chargement
      AppSnackbars.showLoading('Suppression en cours...');
      
      await supplierService.deleteSupplier(supplier.id!);
      await loadSuppliers(); // Recharger la liste
      
      AppSnackbars.showSuccess(
        'Succès',
        'Fournisseur "${supplier.name}" supprimé avec succès',
      );
    } catch (e) {
      AppSnackbars.showError(
        'Erreur',
        'Impossible de supprimer le fournisseur: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Naviguer vers les détails d'un fournisseur
  void navigateToDetails(Supplier supplier) {
    Get.toNamed('/details-supplier', arguments: supplier);
  }

  /// Naviguer vers la modification d'un fournisseur
  void navigateToEdit(Supplier supplier) {
    Get.toNamed('/add-supplier', arguments: supplier);
  }

  /// Naviguer vers l'ajout d'un fournisseur
  void navigateToAdd() {
    Get.toNamed(Routes.ADD_SUPPLIER);
  }

  /// Rafraîchir manuellement la liste
  Future<void> refreshList() async {
    AppSnackbars.showInfo(
      'Actualisation',
      'Actualisation de la liste des fournisseurs...',
    );
    await loadSuppliers();
  }
} 