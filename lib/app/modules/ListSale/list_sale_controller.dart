import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/saleService.dart';
import '../../data/storage.dart';
import 'package:flutter/material.dart';
import '../../../helpers/app_constante.dart';

class ListSaleController extends GetxController {
  late final SaleService saleService;
  final sales = <Sale>[].obs;
  final filteredSales = <Sale>[].obs;
  final isLoading = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    saleService = SaleService(isar);
    
    // Enregistrer le callback de rafraîchissement
    AppRefreshManager.registerRefreshCallback(AppPageKeys.saleList, loadSales);
    
    loadSales();
  }

  Future<void> loadSales() async {
    isLoading.value = true;
    try {
      sales.value = await saleService.getAllSales();
      filteredSales.value = sales;
      
      // Afficher un message informatif si la liste est vide
      if (sales.isEmpty) {
        AppSnackbars.showInfo(
          'Information',
          'Aucune vente trouvée. Commencez par créer votre première vente.',
        );
      }
    } catch (e) {
      AppSnackbars.showError(
        'Erreur',
        'Impossible de charger les ventes: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchSales(String query) {
    if (query.isEmpty) {
      filteredSales.value = sales;
      return;
    }
    final lower = query.toLowerCase();
    filteredSales.value = sales.where((sale) {
      final num = sale.saleNumber?.toLowerCase() ?? '';
      final client = sale.customerLink.value?.name?.toLowerCase() ?? '';
      final date = sale.saleDate?.toLocal().toString().split(' ')[0] ?? '';
      return num.contains(lower) ||
          client.contains(lower) ||
          date.contains(lower);
    }).toList();
    
    // Afficher un message si aucun résultat
    if (filteredSales.isEmpty && query.isNotEmpty) {
      AppSnackbars.showInfo(
        'Recherche',
        'Aucune vente trouvée pour "$query"',
      );
    }
  }

  Future<void> deleteSale(Sale sale) async {
    try {
      isLoading.value = true;
      
      // Afficher un snackbar de chargement
      AppSnackbars.showLoading('Suppression en cours...');
      
      await saleService.isar.writeTxn(() async {
        await saleService.isar.sales.delete(sale.id!);
      });
      await loadSales();
      
      AppSnackbars.showSuccess(
        'Succès',
        'Vente "${sale.saleNumber}" supprimée avec succès',
      );
    } catch (e) {
      AppSnackbars.showError(
        'Erreur',
        'Impossible de supprimer la vente: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Actualiser la liste quand on revient sur cette page
    loadSales();
  }

  @override
  void onClose() {
    searchController.dispose();
    // Supprimer le callback de rafraîchissement
    AppRefreshManager.unregisterRefreshCallback(AppPageKeys.saleList);
    super.onClose();
  }

  /// Rafraîchir manuellement la liste
  Future<void> refreshList() async {
    AppSnackbars.showInfo(
      'Actualisation',
      'Actualisation de la liste des ventes...',
    );
    await loadSales();
  }
} 