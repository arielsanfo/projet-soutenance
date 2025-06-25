import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/productService.dart';
import '../../data/storage.dart';
import '../Product_List/product_list_controller.dart';

class AddProductController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController skuController = TextEditingController();

  late Isar isar;
  late ProductService productService;

  // Variable pour stocker le produit en cours de modification
  Product? productToEdit;
  bool get isEditing => productToEdit != null;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    productService = ProductService(isar);

    // Vérifier si on a reçu un produit à modifier
    final arguments = Get.arguments;
    if (arguments is Product) {
      productToEdit = arguments;
      _populateFieldsWithProductData();
    }
  }

  void _populateFieldsWithProductData() async {
    if (productToEdit != null) {
      nameController.text = productToEdit!.name ?? '';
      descriptionController.text = productToEdit!.description ?? '';
      priceController.text = productToEdit!.salePrice?.toString() ?? '';
      stockController.text = productToEdit!.stockQuantity?.toString() ?? '';
      skuController.text = productToEdit!.sku ?? '';

      // Charger la catégorie si elle existe
      if (productToEdit!.categoryLink.isLoaded == false) {
        await productToEdit!.categoryLink.load();
      }

      if (productToEdit!.categoryLink.value != null) {
        categoryController.text = productToEdit!.categoryLink.value!.name ?? '';
      }

      update(); // Déclencher la reconstruction des widgets
    }
  }

  Future<void> saveProduct() async {
    if (formKey.currentState!.validate()) {
      try {
        final name = nameController.text;
        final description = descriptionController.text;
        final price = double.tryParse(priceController.text) ?? 0.0;
        final stock = int.tryParse(stockController.text) ?? 0;
        final categoryName = categoryController.text;
        final sku = skuController.text;

        Id? categoryId;
        if (categoryName.isNotEmpty) {
          var existingCategory = await isar.productCategorys
              .filter()
              .nameEqualTo(categoryName, caseSensitive: false)
              .findFirst();

          if (existingCategory == null) {
            final newCategory = ProductCategory(name: categoryName);
            existingCategory = await productService.saveCategory(newCategory);
          }
          categoryId = existingCategory.id;
        }

        if (isEditing && productToEdit != null) {
          // Modification d'un produit existant
          productToEdit!.name = name;
          productToEdit!.description = description;
          productToEdit!.salePrice = price;
          productToEdit!.sku = sku.isNotEmpty ? sku : null;

          // Ne pas modifier le stock directement ici, utiliser updateStock si nécessaire
          // productToEdit!.stockQuantity = stock;

          await productService.saveProduct(productToEdit!,
              categoryId: categoryId);

          // Rafraîchir la liste des produits si elle existe
          try {
            final productListController = Get.find<ProductListController>();
            await productListController.refreshProducts();
          } catch (e) {
            // Le contrôleur n'existe pas encore, c'est normal
          }

          Get.back(); // Retourne à la page précédente

          Get.snackbar(
            'Modification réussie',
            'Le produit "${productToEdit!.name}" a été modifié avec succès!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            icon: Icon(Icons.check_circle, color: Colors.white),
            margin: EdgeInsets.all(10),
            borderRadius: 10,
          );
        } else {
          // Création d'un nouveau produit
          final product = Product(
            name: name,
            description: description,
            salePrice: price,
            stockQuantity: stock,
            sku: sku.isNotEmpty ? sku : null,
          );

          await productService.saveProduct(product, categoryId: categoryId);

          // Rafraîchir la liste des produits si elle existe
          try {
            final productListController = Get.find<ProductListController>();
            await productListController.refreshProducts();
          } catch (e) {
            // Le contrôleur n'existe pas encore, c'est normal
          }

          Get.back(); // Retourne à la page précédente

          Get.snackbar(
            'Création réussie',
            'Le produit "$name" a été créé avec succès!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            icon: Icon(Icons.check_circle, color: Colors.white),
            margin: EdgeInsets.all(10),
            borderRadius: 10,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Erreur',
          isEditing
              ? 'Impossible de modifier le produit: ${e.toString()}'
              : 'Impossible de créer le produit: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.error, color: Colors.white),
          margin: EdgeInsets.all(10),
          borderRadius: 10,
        );
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    skuController.dispose();
    super.onClose();
  }
}
