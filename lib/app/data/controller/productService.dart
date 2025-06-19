import 'package:isar/isar.dart';
import '../storage.dart';

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Produits et Catégories (ProductService)
//----------------------------------------------------------------------------//
class ProductService {
  final Isar isar;

  ProductService(this.isar);

  // --- Gestion des Produits ---

  /// Sauvegarder un produit (création ou mise à jour).
  Future<Product> saveProduct(Product product, {Id? categoryId}) async {
    await isar.writeTxn(() async {
      product.updatedAt = DateTime.now();
      
      // Si un produit est créé, enregistrer le stock initial comme premier mouvement
      if (product.id == Isar.autoIncrement && product.stockQuantity! > 0) {
        final movement = InventoryMovement(
          movementDate: DateTime.now(),
          type: InventoryMovementTypeIsar.initialStock,
          quantityChange: product.stockQuantity,
          stockAfterMovement: product.stockQuantity,
        )..productLink.value = product;
        await isar.inventoryMovements.put(movement);
      }

      await isar.products.put(product);
      
      // Lier la catégorie
      if (categoryId != null) {
        final category = await isar.productCategorys.get(categoryId);
        product.categoryLink.value = category;
        await product.categoryLink.save();
      }
    });
    return product;
  }

  /// Obtenir un produit par son ID.
  Future<Product?> getProductById(Id id) async {
    return await isar.products.get(id);
  }

  /// Obtenir tous les produits.
  Future<List<Product>> getAllProducts() async {
    return await isar.products.where().findAll();
  }

  /// Rechercher des produits par nom ou SKU.
  Future<List<Product>> searchProducts(String query) async {
    return await isar.products
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .skuContains(query, caseSensitive: false)
        .findAll();
  }

  /// Mettre à jour le stock d'un produit et enregistrer le mouvement d'inventaire.
  /// C'est une méthode transactionnelle cruciale.
  Future<void> updateStock({
    required Id productId,
    required int quantityChange,
    required InventoryMovementTypeIsar movementType,
    String? reason,
    String? relatedDocumentId,
    Id? userId,
  }) async {
    await isar.writeTxn(() async {
      final product = await isar.products.get(productId);
      if (product == null) throw Exception("Produit avec l'ID $productId non trouvé.");

      final newStock = product.stockQuantity! + quantityChange;
      product.stockQuantity = newStock;
      product.updatedAt = DateTime.now();
      
      final movement = InventoryMovement(
        movementDate: DateTime.now(),
        type: movementType,
        quantityChange: quantityChange,
        stockAfterMovement: newStock,
        reason: reason,
        relatedDocumentId: relatedDocumentId,
      );

      movement.productLink.value = product;
      if (userId != null) {
        final user = await isar.users.get(userId);
        movement.processedByLink.value = user;
      }
      
      await isar.products.put(product);
      await isar.inventoryMovements.put(movement);
    });
  }

  // --- Gestion des Catégories ---

  /// Sauvegarder une catégorie.
  Future<ProductCategory> saveCategory(ProductCategory category) async {
    await isar.writeTxn(() => isar.productCategorys.put(category));
    return category;
  }
  
  /// Obtenir toutes les catégories.
  Future<List<ProductCategory>> getAllCategories() async {
    return await isar.productCategorys.where().sortByName().findAll();
  }
  
  /// Supprimer une catégorie.
  Future<bool> deleteCategory(Id id) async {
    // Attention: Gérer les produits orphelins si nécessaire avant suppression.
    return await isar.writeTxn(() => isar.productCategorys.delete(id));
  }
}