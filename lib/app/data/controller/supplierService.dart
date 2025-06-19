import 'package:flutter_application_1/app/data/controller/productService.dart';
import 'package:isar/isar.dart';
import '../storage.dart';

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Commandes Fournisseurs (SupplierOrderService)
//----------------------------------------------------------------------------//
class SupplierOrderService {
  final Isar isar;
  final ProductService productService;

  SupplierOrderService(this.isar) : productService = ProductService(isar);

  /// Créer une commande fournisseur.
  Future<SupplierOrder> createSupplierOrder({
    required Id supplierId,
    required List<SupplierOrderItem> items,
    String? notes,
    Id? createdByUserId,
  }) async {
    final total = items.fold(0.0, (sum, item) => sum + item.totalCost!);
    final order = SupplierOrder(
      orderNumber: 'CF-${DateTime.now().millisecondsSinceEpoch}',
      orderDate: DateTime.now(),
      totalPrice: total,
      notes: notes
    );

    await isar.writeTxn(() async {
      order.supplierLink.value = await isar.suppliers.get(supplierId);
      if(createdByUserId != null) order.createdByLink.value = await isar.users.get(createdByUserId);
      
      await isar.supplierOrders.put(order);
      await order.supplierLink.save();
      await order.createdByLink.save();

      for (var item in items) {
        item.supplierOrderLink.value = order;
        await isar.supplierOrderItems.put(item);
        await item.productLink.save();
        await item.supplierOrderLink.save();
      }
    });
    return order;
  }

  /// Marquer une commande fournisseur comme reçue et met à jour le stock.
  Future<void> receiveSupplierOrderItems({
    required Id supplierOrderItemId,
    required int quantityReceived,
    Id? userId,
  }) async {
    await isar.writeTxn(() async {
      final orderItem = await isar.supplierOrderItems.get(supplierOrderItemId);
      if (orderItem == null) return;
      await orderItem.productLink.load();
      await orderItem.supplierOrderLink.load();
      if (orderItem.productLink.value == null || orderItem.supplierOrderLink.value == null) return;
      
      orderItem.quantityReceived = (orderItem.quantityReceived ?? 0) + quantityReceived;
      await isar.supplierOrderItems.put(orderItem);

      // Mettre à jour le stock du produit
      await productService.updateStock(
        productId: orderItem.productLink.value!.id!,
        quantityChange: quantityReceived, // Positif car c'est une entrée de stock
        movementType: InventoryMovementTypeIsar.purchaseReceived,
        relatedDocumentId: orderItem.supplierOrderLink.value!.orderNumber,
        userId: userId,
      );

      // Mettre à jour le statut de la commande globale
      final order = orderItem.supplierOrderLink.value!;
      await order.supplierOrderItems.load();
      bool allReceived = order.supplierOrderItems.every((item) => item.quantityReceived! >= item.quantityOrdered!);

      order.status = allReceived ? SupplierOrderStatusIsar.received : SupplierOrderStatusIsar.partiallyReceived;
      order.actualDeliveryDate = DateTime.now();
      await isar.supplierOrders.put(order);
    });
  }
  
  /// Obtenir toutes les commandes fournisseurs.
  Future<List<SupplierOrder>> getAllSupplierOrders() async {
    return await isar.supplierOrders.where().sortByOrderDateDesc().findAll();
  }
}
