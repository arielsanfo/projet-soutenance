import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/productService.dart';
import '../../data/storage.dart';
import '../../routes/app_pages.dart';

class DetailProductController extends GetxController {
  late Isar isar;
  late ProductService productService;

  final product = Rx<Product?>(null);
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    productService = ProductService(isar);

    final productIdStr = Get.parameters['productId'];
    if (productIdStr != null) {
      final productId = int.tryParse(productIdStr);
      if (productId != null) {
        fetchProduct(productId);
      } else {
        // Gérer l'erreur d'ID invalide
        isLoading.value = false;
      }
    } else {
      // Gérer l'absence d'ID
      isLoading.value = false;
    }
  }

  Future<void> fetchProduct(int id) async {
    isLoading.value = true;
    try {
      final fetchedProduct = await productService.getProductById(id);
      if (fetchedProduct != null) {
        await fetchedProduct.categoryLink.load();
        product.value = fetchedProduct;
      }
      // Gérer le cas où le produit n'est pas trouvé
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger le produit.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct() async {
    if (product.value?.id != null) {
      Get.dialog(
        AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text(
              'Voulez-vous vraiment supprimer ce produit ? Cette action est irréversible.'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await productService.deleteProduct(product.value!.id!);
                  Get.back(); // Ferme la dialog
                  Get.back(); // Retourne à la page précédente
                  Get.snackbar('Succès', 'Produit supprimé.');
                } catch (e) {
                  Get.back(); // Ferme la dialog
                  Get.snackbar('Erreur', 'La suppression a échoué.');
                }
              },
            ),
          ],
        ),
      );
    }
  }

  void navigateToEdit() {
    if (product.value != null) {
      // Note: La page d'ajout/modification doit être adaptée pour pré-remplir les champs.
      // Pour l'instant, on navigue simplement.
      Get.toNamed(Routes.ADD_PRODUCT, arguments: product.value);
    }
  }

  Color getStockColor(Product product) {
    final stock = product.stockQuantity ?? 0;
    if (stock == 0) return Colors.red;
    if (stock < 10) return Colors.orange;
    return Colors.green;
  }
}
