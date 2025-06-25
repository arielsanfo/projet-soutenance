import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/productService.dart';
import '../../data/storage.dart';
import 'package:flutter/material.dart';

// import 'product_list_view.dart';
class ProductListController extends GetxController {
  late Isar isar;
  late ProductService productService;

  // États observables
  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final selectedTab = 0.obs;

  // Getters pour les compteurs
  int get totalProducts => products.length;
  int get lowStockProducts => products
      .where((p) => (p.stockQuantity ?? 0) > 0 && (p.stockQuantity ?? 0) < 10)
      .length;
  int get outOfStockProducts =>
      products.where((p) => (p.stockQuantity ?? 0) == 0).length;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    productService = ProductService(isar);
    loadProducts();
  }

  // Méthode publique pour rafraîchir les produits depuis d'autres pages
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final fetchedProducts = await productService.getAllProducts();

      // Charger les catégories pour chaque produit
      for (var product in fetchedProducts) {
        await product.categoryLink.load();
      }

      products.value = fetchedProducts;
      applyFilters();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les produits: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void onTabChanged(int tabIndex) {
    selectedTab.value = tabIndex;
    applyFilters();
  }

  void applyFilters() {
    var filtered = List<Product>.from(products);

    // Appliquer le filtre de recherche
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) {
        final query = searchQuery.value.toLowerCase();
        return product.name?.toLowerCase().contains(query) == true ||
            product.sku?.toLowerCase().contains(query) == true ||
            product.description?.toLowerCase().contains(query) == true ||
            product.categoryLink.value?.name?.toLowerCase().contains(query) ==
                true;
      }).toList();
    }

    // Appliquer le filtre par onglet
    switch (selectedTab.value) {
      case 1: // Stock Bas
        filtered = filtered
            .where((p) =>
                (p.stockQuantity ?? 0) > 0 && (p.stockQuantity ?? 0) < 10)
            .toList();
        break;
      case 2: // Hors Stock
        filtered = filtered.where((p) => (p.stockQuantity ?? 0) == 0).toList();
        break;
      default: // Tous (case 0)
        break;
    }

    filteredProducts.value = filtered;
  }

  void navigateToProductDetails(Product product) {
    if (product.id != null) {
      Get.toNamed('/detail-product-with-id?productId=${product.id}');
    }
  }

  String getProductInitial(Product product) {
    return product.name?.isNotEmpty == true
        ? product.name![0].toUpperCase()
        : '?';
  }

  Color getStockColor(Product product) {
    final stock = product.stockQuantity ?? 0;
    if (stock == 0) return Colors.red;
    if (stock < 10) return Colors.orange;
    return Colors.green;
  }

  String getStockStatus(Product product) {
    final stock = product.stockQuantity ?? 0;
    if (stock == 0) return 'Hors Stock';
    if (stock < 10) return 'Stock Bas';
    return 'En Stock';
  }

  Future<void> deleteProduct(Product product) async {
    if (product.id != null) {
      try {
        final productName = product.name ?? 'Ce produit';
        await productService.deleteProduct(product.id!);
        await loadProducts(); // Recharger la liste après suppression

        Get.snackbar(
          'Suppression réussie',
          'Le produit "$productName" a été supprimé avec succès!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle, color: Colors.white),
          margin: EdgeInsets.all(10),
          borderRadius: 10,
        );
      } catch (e) {
        Get.snackbar(
          'Erreur de suppression',
          'Impossible de supprimer le produit: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.error, color: Colors.white),
          margin: EdgeInsets.all(10),
          borderRadius: 10,
        );
        rethrow; // Relancer l'erreur pour que la dialog puisse la gérer
      }
    }
  }
}
