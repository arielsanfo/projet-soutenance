
// import 'package:isar/isar.dart';

// import 'storage.dart';
// // Mettez à jour le chemin d'importation pour qu'il corresponde à la structure de votre projet

// // ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable

// /// REMARQUE IMPORTANTE:
// /// Ce fichier contient des classes de service (aussi appelées Repositories ou Contrôleurs de données)
// /// qui encapsulent toute la logique d'interaction avec la base de données Isar.
// ///
// /// Dans une application réelle, il est fortement recommandé d'utiliser un gestionnaire d'état
// /// ou un localisateur de services (comme Riverpod, BLoC, Provider, GetIt) pour fournir
// /// une instance unique de l'Isar et de ces services à travers l'application.

// //----------------------------------------------------------------------------//
// // SERVICE: Gestion des Utilisateurs (UserService)
// //----------------------------------------------------------------------------//
// class UserService {
//   final Isar isar;

//   UserService(this.isar);

//   /// Créer ou mettre à jour un utilisateur.
//   /// Le hachage du mot de passe doit être effectué avant d'appeler cette méthode.
//   Future<User> saveUser(User user) async {
//     await isar.writeTxn(() async {
//       user.updatedAt = DateTime.now();
//       await isar.users.put(user);
//     });
//     return user;
//   }

//   /// Obtenir un utilisateur par son email (pour la connexion).
//   Future<User?> getUserByEmail(String email) async {
//     return await isar.users.where().emailEqualTo(email).findFirst();
//   }

//   /// Obtenir un utilisateur par son ID.
//   Future<User?> getUserById(Id id) async {
//     return await isar.users.get(id);
//   }

//   /// Obtenir tous les utilisateurs.
//   Future<List<User>> getAllUsers() async {
//     return await isar.users.where().findAll();
//   }

//   /// Supprimer un utilisateur.
//   Future<bool> deleteUser(Id id) async {
//     // Attention: Pensez aux implications si l'utilisateur est lié à d'autres données.
//     return await isar.writeTxn(() async {
//       return await isar.users.delete(id);
//     });
//   }
// }

// //----------------------------------------------------------------------------//
// // SERVICE: Gestion des Produits et Catégories (ProductService)
// //----------------------------------------------------------------------------//
// class ProductService {
//   final Isar isar;

//   ProductService(this.isar);

//   // --- Gestion des Produits ---

//   /// Sauvegarder un produit (création ou mise à jour).
//   Future<Product> saveProduct(Product product, {Id? categoryId}) async {
//     await isar.writeTxn(() async {
//       product.updatedAt = DateTime.now();
      
//       // Si un produit est créé, enregistrer le stock initial comme premier mouvement
//       if (product.id == Isar.autoIncrement && product.stockQuantity > 0) {
//         final movement = InventoryMovement(
//           movementDate: DateTime.now(),
//           type: InventoryMovementTypeIsar.initialStock,
//           quantityChange: product.stockQuantity,
//           stockAfterMovement: product.stockQuantity,
//         )..productLink.value = product;
//         await isar.inventoryMovements.put(movement);
//       }

//       await isar.products.put(product);
      
//       // Lier la catégorie
//       if (categoryId != null) {
//         final category = await isar.productCategorys.get(categoryId);
//         product.categoryLink.value = category;
//         await product.categoryLink.save();
//       }
//     });
//     return product;
//   }

//   /// Obtenir un produit par son ID.
//   Future<Product?> getProductById(Id id) async {
//     return await isar.products.get(id);
//   }

//   /// Obtenir tous les produits.
//   Future<List<Product>> getAllProducts() async {
//     return await isar.products.where().findAll();
//   }

//   /// Rechercher des produits par nom ou SKU.
//   Future<List<Product>> searchProducts(String query) async {
//     return await isar.products
//         .filter()
//         .nameContains(query, caseSensitive: false)
//         .or()
//         .skuContains(query, caseSensitive: false)
//         .findAll();
//   }

//   /// Mettre à jour le stock d'un produit et enregistrer le mouvement d'inventaire.
//   /// C'est une méthode transactionnelle cruciale.
//   Future<void> updateStock({
//     required Id productId,
//     required int quantityChange,
//     required InventoryMovementTypeIsar movementType,
//     String? reason,
//     String? relatedDocumentId,
//     Id? userId,
//   }) async {
//     await isar.writeTxn(() async {
//       final product = await isar.products.get(productId);
//       if (product == null) throw Exception("Produit avec l'ID $productId non trouvé.");

//       final newStock = product.stockQuantity + quantityChange;
//       product.stockQuantity = newStock;
//       product.updatedAt = DateTime.now();
      
//       final movement = InventoryMovement(
//         movementDate: DateTime.now(),
//         type: movementType,
//         quantityChange: quantityChange,
//         stockAfterMovement: newStock,
//         reason: reason,
//         relatedDocumentId: relatedDocumentId,
//       );

//       movement.productLink.value = product;
//       if (userId != null) {
//         final user = await isar.users.get(userId);
//         movement.processedByLink.value = user;
//       }
      
//       await isar.products.put(product);
//       await isar.inventoryMovements.put(movement);
//     });
//   }

//   // --- Gestion des Catégories ---

//   /// Sauvegarder une catégorie.
//   Future<ProductCategory> saveCategory(ProductCategory category) async {
//     await isar.writeTxn(() => isar.productCategorys.put(category));
//     return category;
//   }
  
//   /// Obtenir toutes les catégories.
//   Future<List<ProductCategory>> getAllCategories() async {
//     return await isar.productCategorys.where().sortByName().findAll();
//   }
  
//   /// Supprimer une catégorie.
//   Future<bool> deleteCategory(Id id) async {
//     // Attention: Gérer les produits orphelins si nécessaire avant suppression.
//     return await isar.writeTxn(() => isar.productCategorys.delete(id));
//   }
// }

// //----------------------------------------------------------------------------//
// // SERVICE: Gestion des Ventes (SaleService)
// //----------------------------------------------------------------------------//
// class SaleService {
//   final Isar isar;
//   final ProductService productService;

//   SaleService(this.isar) : productService = ProductService(isar);

//   /// Processus complet de création d'une nouvelle vente.
//   /// Cette méthode est transactionnelle et met à jour le stock.
//   Future<Sale> processNewSale({
//     required List<SaleItem> items,
//     Id? customerId,
//     required String paymentMethod,
//     double discount = 0.0,
//     Id? processedByUserId,
//   }) async {
//     final double totalPrice = items.fold(0.0, (sum, item) => sum + item.totalPrice) - discount;

//     final newSale = Sale(
//       saleNumber: 'V-${DateTime.now().millisecondsSinceEpoch}', // Générer un numéro unique
//       saleDate: DateTime.now(),
//       totalPrice: totalPrice,
//       discountAmount: discount,
//       paymentMethod: paymentMethod,
//     );
    
//     await isar.writeTxn(() async {
//       // Lier le client et l'utilisateur
//       if (customerId != null) newSale.customerLink.value = await isar.customers.get(customerId);
//       if (processedByUserId != null) newSale.processedByLink.value = await isar.users.get(processedByUserId);

//       // Sauvegarder la vente pour obtenir un ID
//       await isar.sales.put(newSale);
//       await newSale.customerLink.save();
//       await newSale.processedByLink.save();

//       for (var item in items) {
//         item.saleLink.value = newSale;
        
//         await isar.saleItems.put(item);
//         await item.productLink.save();
//         await item.saleLink.save();

//         // Mettre à jour le stock du produit
//         if (item.productLink.value != null) {
//           await productService.updateStock(
//             productId: item.productLink.value!.id,
//             quantityChange: -item.quantity, // Négatif car c'est une sortie de stock
//             movementType: InventoryMovementTypeIsar.sale,
//             relatedDocumentId: newSale.saleNumber,
//             userId: processedByUserId,
//           );
//         }
//       }
//     });

//     return newSale;
//   }
  
//   /// Obtenir une vente par son ID, avec ses articles.
//   Future<Sale?> getSaleById(Id id) async {
//     final sale = await isar.sales.get(id);
//     await sale?.saleItems.load();
//     return sale;
//   }
  
//   /// Obtenir toutes les ventes, triées par date.
//   Future<List<Sale>> getAllSales() async {
//     return await isar.sales.where().sortBySaleDateDesc().findAll();
//   }
// }

// //----------------------------------------------------------------------------//
// // SERVICE: Gestion des Clients et Dettes (CustomerService)
// //----------------------------------------------------------------------------//
// class CustomerService {
//   final Isar isar;

//   CustomerService(this.isar);

//   // --- Gestion des Clients ---
  
//   /// Sauvegarder un client.
//   Future<Customer> saveCustomer(Customer customer) async {
//     await isar.writeTxn(() => isar.customers.put(customer));
//     return customer;
//   }

//   /// Obtenir un client par son ID.
//   Future<Customer?> getCustomerById(Id id) async {
//     return await isar.customers.get(id);
//   }
  
//   /// Obtenir tous les clients.
//   Future<List<Customer>> getAllCustomers() async {
//     return await isar.customers.where().sortByName().findAll();
//   }

//   // --- Gestion des Dettes ---

//   /// Ajouter une dette à un client.
//   Future<Debt> addDebtToCustomer({
//     required Id customerId,
//     required double amount,
//     DateTime? dueDate,
//     String? notes,
//     Id? relatedSaleId,
//   }) async {
//     final debt = Debt(
//       initialAmount: amount,
//       debtDate: DateTime.now(),
//       dueDate: dueDate,
//       notes: notes,
//     );

//     await isar.writeTxn(() async {
//       final customer = await isar.customers.get(customerId);
//       if (customer == null) throw Exception("Client non trouvé");

//       debt.customerLink.value = customer;
//       if (relatedSaleId != null) debt.relatedSaleLink.value = await isar.sales.get(relatedSaleId);
      
//       await isar.debts.put(debt);
//       await debt.customerLink.save();
//       await debt.relatedSaleLink.save();
//     });
//     return debt;
//   }

//   /// Enregistrer un paiement pour une dette.
//   Future<Debt?> recordDebtPayment({
//     required Id debtId,
//     required double amountPaid,
//     required String paymentMethod,
//     Id? recordedByUserId,
//   }) async {
//     return await isar.writeTxn(() async {
//       final debt = await isar.debts.get(debtId);
//       if (debt == null) return null;

//       final payment = DebtPayment(
//         amountPaid: amountPaid, 
//         paymentDate: DateTime.now(),
//         paymentMethod: paymentMethod
//       );

//       debt.remainingAmount -= amountPaid;
//       if (debt.remainingAmount <= 0.01) { // Utiliser une tolérance pour les doubles
//         debt.status = DebtStatusIsar.paid;
//         debt.remainingAmount = 0;
//       } else {
//         debt.status = DebtStatusIsar.partiallyPaid;
//       }

//       payment.debtLink.value = debt;
//       if (recordedByUserId != null) payment.recordedByLink.value = await isar.users.get(recordedByUserId);

//       await isar.debts.put(debt);
//       await isar.debtPayments.put(payment);
//       await payment.debtLink.save();
//       await payment.recordedByLink.save();
      
//       return debt;
//     });
//   }

//   /// Obtenir toutes les dettes d'un client.
//   Future<List<Debt>> getDebtsForCustomer(Id customerId) async {
//     return await isar.debts.filter().customerLink((q) => q.idEqualTo(customerId)).findAll();
//   }
// }

// //----------------------------------------------------------------------------//
// // SERVICE: Gestion des Commandes Fournisseurs (SupplierOrderService)
// //----------------------------------------------------------------------------//
// class SupplierOrderService {
//   final Isar isar;
//   final ProductService productService;

//   SupplierOrderService(this.isar) : productService = ProductService(isar);

//   /// Créer une commande fournisseur.
//   Future<SupplierOrder> createSupplierOrder({
//     required Id supplierId,
//     required List<SupplierOrderItem> items,
//     String? notes,
//     Id? createdByUserId,
//   }) async {
//     final total = items.fold(0.0, (sum, item) => sum + item.totalCost);
//     final order = SupplierOrder(
//       orderNumber: 'CF-${DateTime.now().millisecondsSinceEpoch}',
//       orderDate: DateTime.now(),
//       totalPrice: total,
//       notes: notes
//     );

//     await isar.writeTxn(() async {
//       order.supplierLink.value = await isar.suppliers.get(supplierId);
//       if(createdByUserId != null) order.createdByLink.value = await isar.users.get(createdByUserId);
      
//       await isar.supplierOrders.put(order);
//       await order.supplierLink.save();
//       await order.createdByLink.save();

//       for (var item in items) {
//         item.supplierOrderLink.value = order;
//         await isar.supplierOrderItems.put(item);
//         await item.productLink.save();
//         await item.supplierOrderLink.save();
//       }
//     });
//     return order;
//   }

//   /// Marquer une commande fournisseur comme reçue et met à jour le stock.
//   Future<void> receiveSupplierOrderItems({
//     required Id supplierOrderItemId,
//     required int quantityReceived,
//     Id? userId,
//   }) async {
//     await isar.writeTxn(() async {
//       final orderItem = await isar.supplierOrderItems.get(supplierOrderItemId);
//       if (orderItem == null) return;
//       await orderItem.productLink.load();
//       await orderItem.supplierOrderLink.load();
//       if (orderItem.productLink.value == null || orderItem.supplierOrderLink.value == null) return;
      
//       orderItem.quantityReceived += quantityReceived;
//       await isar.supplierOrderItems.put(orderItem);

//       // Mettre à jour le stock du produit
//       await productService.updateStock(
//         productId: orderItem.productLink.value!.id,
//         quantityChange: quantityReceived, // Positif car c'est une entrée de stock
//         movementType: InventoryMovementTypeIsar.purchaseReceived,
//         relatedDocumentId: orderItem.supplierOrderLink.value!.orderNumber,
//         userId: userId,
//       );

//       // Mettre à jour le statut de la commande globale
//       final order = orderItem.supplierOrderLink.value!;
//       await order.supplierOrderItems.load();
//       bool allReceived = order.supplierOrderItems.every((item) => item.quantityReceived >= item.quantityOrdered);

//       order.status = allReceived ? SupplierOrderStatusIsar.received : SupplierOrderStatusIsar.partiallyReceived;
//       order.actualDeliveryDate = DateTime.now();
//       await isar.supplierOrders.put(order);
//     });
//   }
  
//   /// Obtenir toutes les commandes fournisseurs.
//   Future<List<SupplierOrder>> getAllSupplierOrders() async {
//     return await isar.supplierOrders.where().sortByOrderDateDesc().findAll();
//   }
// }

// //----------------------------------------------------------------------------//
// // SERVICE: Gestion des Dépenses (ExpenseService)
// //----------------------------------------------------------------------------//
// class ExpenseService {
//   final Isar isar;
//   ExpenseService(this.isar);
  
//   /// Sauvegarder une dépense.
//   Future<Expense> saveExpense(Expense expense, {Id? userId}) async {
//     await isar.writeTxn(() async {
//         if(userId != null) expense.recordedByLink.value = await isar.users.get(userId);
//         await isar.expenses.put(expense);
//         await expense.recordedByLink.save();
//     });
//     return expense;
//   }
  
//   /// Obtenir toutes les dépenses.
//   Future<List<Expense>> getAllExpenses() async {
//       return await isar.expenses.where().sortByExpenseDateDesc().findAll();
//   }
// }

// //----------------------------------------------------------------------------//
// // SERVICE: Gestion des Informations de l'Entreprise (BusinessService)
// //----------------------------------------------------------------------------//
// class BusinessService {
//   final Isar isar;
//   BusinessService(this.isar);
  
//   /// Sauvegarder les détails de l'entreprise.
//   Future<BusinessDetails> saveDetails(BusinessDetails details) async {
//     await isar.writeTxn(() => isar.businessDetails.put(details));
//     return details;
//   }
  
//   /// Obtenir les détails de l'entreprise (il n'y en a qu'un).
//   Future<BusinessDetails?> getDetails() async {
//     return await isar.businessDetails.get(BusinessDetails.fixedId);
//   }
// }
