import 'package:flutter_application_1/app/data/controller/productService.dart';
import 'package:isar/isar.dart';
import '../storage.dart';

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Ventes (SaleService)
//----------------------------------------------------------------------------//
class SaleService {
  final Isar isar;
  final ProductService productService;
  SaleService(this.isar) : productService = ProductService(isar);

  /// Processus complet de création d'une nouvelle vente.
  /// Cette méthode est transactionnelle et met à jour le stock.
  Future<Sale> processNewSale({
    required List<SaleItem> items,
    Id? customerId,
    required String paymentMethod,
    double discount = 0.0,
    Id? processedByUserId,
  }) async {
    final double totalPrice =
        items.fold(0.0, (sum, item) => sum + item.totalPrice!) - discount;

    final newSale = Sale(
      saleNumber:
          'V-${DateTime.now().millisecondsSinceEpoch}', // Générer un numéro unique
      saleDate: DateTime.now(),
      totalPrice: totalPrice,
      discountAmount: discount,
      paymentMethod: paymentMethod,
    );

    await isar.writeTxn(() async {
      // Lier le client et l'utilisateur
      if (customerId != null)
        newSale.customerLink.value = await isar.customers.get(customerId);
      if (processedByUserId != null)
        newSale.processedByLink.value = await isar.users.get(processedByUserId);

      // Sauvegarder la vente pour obtenir un ID
      await isar.sales.put(newSale);
      await newSale.customerLink.save();
      await newSale.processedByLink.save();

      for (var item in items) {
        item.saleLink.value = newSale;

        await isar.saleItems.put(item);
        await item.productLink.save();
        await item.saleLink.save();

        // Mettre à jour le stock du produit
        if (item.productLink.value != null) {
          await productService.updateStock(
            productId: item.productLink.value!.id!,
            quantityChange:
                -item.quantity!, // Négatif car c'est une sortie de stock
            movementType: InventoryMovementTypeIsar.sale,
            relatedDocumentId: newSale.saleNumber,
            userId: processedByUserId,
            inTransaction: true,
          );
        }
      }
    });

    return newSale;
  }

  /// Obtenir une vente par son ID, avec ses articles.
  Future<Sale?> getSaleById(Id id) async {
    final sale = await isar.sales.get(id);
    await sale?.saleItems.load();
    return sale;
  }

  /// Obtenir toutes les ventes, triées par date.
  Future<List<Sale>> getAllSales() async {
    return await isar.sales.where().sortBySaleDateDesc().findAll();
  }

  /// Supprimer une vente et restaurer le stock des produits.
  /// Cette méthode est transactionnelle pour assurer la cohérence des données.
  Future<void> deleteSale(Id saleId) async {
    await isar.writeTxn(() async {
      // Récupérer la vente avec ses articles
      final sale = await isar.sales.get(saleId);
      if (sale == null) {
        throw Exception('Vente introuvable');
      }

      // Charger les articles de la vente
      await sale.saleItems.load();
      
      // Restaurer le stock pour chaque article
      for (var item in sale.saleItems) {
        await item.productLink.load();
        if (item.productLink.value != null) {
          // Restaurer le stock (quantité positive car c'est un retour en stock)
          await productService.updateStock(
            productId: item.productLink.value!.id!,
            quantityChange: item.quantity!, // Positif car c'est un retour en stock
            movementType: InventoryMovementTypeIsar.saleCancellation,
            relatedDocumentId: 'ANNULATION-${sale.saleNumber}',
            userId: sale.processedByLink.value?.id,
            inTransaction: true,
          );
        }
        
        // Supprimer l'article de vente
        await isar.saleItems.delete(item.id!);
      }

      // Supprimer la vente
      await isar.sales.delete(saleId);
    });
  }
}
