import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import '../../data/storage.dart';
import '../../data/controller/customerService.dart';
import '../../data/controller/supplierService.dart';

class ManagementOrderController extends GetxController {
  final searchQuery = ''.obs;
  final isClientSelected = true.obs;
  final isLoading = false.obs;
  final orders = <Order>[].obs;
  final supplierOrders = <SupplierOrder>[].obs;
  final filteredClientOrders = <Order>[].obs;
  final filteredSupplierOrders = <SupplierOrder>[].obs;
  final debtsByCustomerId = <int, Debt?>{}.obs;
  late final Isar isar;
  late final CustomerService customerService;
  late final SupplierOrderService supplierOrderService;

  // Gestion des onglets
  final currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    print('=== INITIALISATION MANAGEMENT ORDER CONTROLLER ===');
    try {
      isar = Get.find<Isar>();
      customerService = CustomerService(isar);
      supplierOrderService = SupplierOrderService(isar);
      print('Services initialisés avec succès');
      loadAllData();
    } catch (e) {
      print('Erreur lors de l\'initialisation: $e');
      _showErrorSnackBar('Erreur d\'initialisation: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
    print('=== ON READY MANAGEMENT ORDER ===');
    // Rafraîchir les données quand la page devient active
    refreshData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Changer d'onglet
  void changeTab(int index) {
    currentTabIndex.value = index;
    isClientSelected.value = index == 0;
    print('Onglet changé vers: ${index == 0 ? "Clients" : "Fournisseurs"}');
  }

  /// Afficher un SnackBar de succès
  void _showSuccessSnackBar(String message) {
    Get.snackbar(
      'Succès',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  /// Afficher un SnackBar d'erreur
  void _showErrorSnackBar(String message) {
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      icon: Icon(Icons.error, color: Colors.white),
    );
  }

  /// Afficher un SnackBar d'information
  void _showInfoSnackBar(String message) {
    Get.snackbar(
      'Information',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      icon: Icon(Icons.info, color: Colors.white),
    );
  }

  /// Charger toutes les données (commandes clients et fournisseurs)
  Future<void> loadAllData() async {
    print('=== DÉBUT CHARGEMENT DONNÉES ===');
    isLoading.value = true;
    try {
      await Future.wait([
        loadOrders(),
        loadSupplierOrders(),
      ]);
      
      // Si aucune commande n'existe, créer des données de test
      if (orders.isEmpty && supplierOrders.isEmpty) {
        print('Aucune commande trouvée, création de données de test');
        await createTestData();
        // Recharger les données après création
        await Future.wait([
          loadOrders(),
          loadSupplierOrders(),
        ]);
      }
      
      print('Données chargées: ${orders.length} commandes clients, ${supplierOrders.length} commandes fournisseurs');
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
    } finally {
      isLoading.value = false;
      print('=== FIN CHARGEMENT DONNÉES ===');
    }
  }

  /// Rafraîchir toutes les données
  Future<void> refreshData() async {
    print('=== RAFRAÎCHISSEMENT DONNÉES ===');
    try {
      await loadAllData();
      update();
      _showSuccessSnackBar('Données actualisées avec succès');
    } catch (e) {
      print('Erreur lors du rafraîchissement: $e');
      _showErrorSnackBar('Erreur lors de l\'actualisation des données');
    }
  }

  Future<void> loadOrders() async {
    print('=== CHARGEMENT COMMANDES CLIENTS ===');
    try {
      // Charger toutes les commandes clients avec leurs relations
      final clientOrders = await isar.orders
          .filter()
          .orderDateIsNotNull()
          .sortByOrderDateDesc()
          .findAll();
      
      print('Commandes clients trouvées: ${clientOrders.length}');
      
      // Charger les relations pour chaque commande
      for (final order in clientOrders) {
        await order.customerLink.load();
        await order.orderItems.load();
        for (final item in order.orderItems) {
          await item.productLink.load();
        }
        await order.createdByLink.load();
      }
      
      orders.assignAll(clientOrders);
      updateFilteredLists();
      print('Commandes clients assignées: ${orders.length}');
      
      // Charger la dette pour chaque client unique
      final customerIds = orders
          .map((o) => o.customerLink.value?.id)
          .whereType<int>()
          .toSet();
      
      print('Clients uniques trouvés: ${customerIds.length}');
      
      for (final id in customerIds) {
        final debts = await customerService.getDebtsForCustomer(id);
        final unpaid = debts.firstWhereOrNull((d) => d.status != DebtStatusIsar.paid);
        debtsByCustomerId[id] = unpaid;
      }
      print('=== FIN CHARGEMENT COMMANDES CLIENTS ===');
    } catch (e) {
      print('Erreur lors du chargement des commandes clients: $e');
      _showErrorSnackBar('Erreur lors du chargement des commandes clients');
    }
  }

  /// Créer une nouvelle commande client
  Future<void> createClientOrder({
    required String customerName,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      // Vérifier si le client existe
      final customers = await isar.customers
          .filter()
          .nameContains(customerName, caseSensitive: false)
          .findAll();
      
      if (customers.isEmpty) {
        _showErrorSnackBar('Client "$customerName" non trouvé');
        return;
      }

      final customer = customers.first;
      final orderItems = <OrderItem>[];
      double totalPrice = 0;
      // Vérification stricte du stock
      for (final item in items) {
        final productName = item['productName'] as String;
        final quantity = item['quantity'] as int;
        final unitPrice = item['unitPrice'] as double;
        final products = await isar.products
            .filter()
            .nameContains(productName, caseSensitive: false)
            .findAll();
        if (products.isNotEmpty) {
          final product = products.first;
          if ((product.stockQuantity ?? 0) < quantity) {
            Get.snackbar(
              'Stock insuffisant',
              'Le stock de ${product.name} est insuffisant.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
            return;
          }
        }
      }
      // Création des articles de commande et calcul du total
      for (final item in items) {
        final productName = item['productName'] as String;
        final quantity = item['quantity'] as int;
        final unitPrice = item['unitPrice'] as double;
        final products = await isar.products
            .filter()
            .nameContains(productName, caseSensitive: false)
            .findAll();
        if (products.isNotEmpty) {
          final product = products.first;
          final orderItem = OrderItem(
            quantity: quantity,
            unitPriceAtOrder: unitPrice,
          );
          orderItem.productLink.value = product;
          orderItems.add(orderItem);
          totalPrice += quantity * unitPrice;
        }
      }
      if (orderItems.isEmpty) {
        _showErrorSnackBar('Aucun produit valide trouvé');
        return;
      }
      // Créer la commande client et décrémenter le stock
      final order = Order(
        orderNumber: 'CMD-${DateTime.now().millisecondsSinceEpoch}',
        orderDate: DateTime.now(),
        totalPrice: totalPrice,
        status: OrderStatusIsar.pending,
        notes: notes,
      );
      await isar.writeTxn(() async {
        order.customerLink.value = customer;
        final users = await isar.users.where().findAll();
        if (users.isNotEmpty) {
          order.createdByLink.value = users.first;
        }
        await isar.orders.put(order);
        await order.customerLink.save();
        await order.createdByLink.save();
        // Sauvegarder les articles et décrémenter le stock
        for (final item in orderItems) {
          item.orderLink.value = order;
          await isar.orderItems.put(item);
          await item.productLink.save();
          await item.orderLink.save();
          // Décrémenter le stock
          final product = item.productLink.value;
          if (product != null) {
            product.stockQuantity = (product.stockQuantity ?? 0) - (item.quantity ?? 0);
            await isar.products.put(product);
          }
        }
      });
      await loadOrders();
      await refreshData();
      await refreshProducts();
      Get.snackbar(
        'Succès',
        'Commande client créée et stock mis à jour.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Erreur lors de la création de la commande client: $e');
      _showErrorSnackBar('Erreur lors de la création de la commande client');
    }
  }

  /// Supprimer une commande client
  Future<void> deleteClientOrder(Order order) async {
    try {
      await isar.writeTxn(() async {
        // Supprimer d'abord les articles
        await order.orderItems.load();
        for (final item in order.orderItems) {
          await isar.orderItems.delete(item.id!);
        }
        // Puis supprimer la commande
        await isar.orders.delete(order.id!);
      });

      await loadOrders();
      await refreshProducts();
      _showSuccessSnackBar('Commande client supprimée avec succès');
    } catch (e) {
      print('Erreur lors de la suppression: $e');
      _showErrorSnackBar('Erreur lors de la suppression de la commande');
    }
  }

  /// Marquer une commande client comme livrée
  Future<void> markClientOrderAsDelivered(Order order) async {
    try {
      await isar.writeTxn(() async {
        order.status = OrderStatusIsar.delivered;
        order.expectedDeliveryDate = DateTime.now();
        await isar.orders.put(order);
      });

      await loadOrders();
      _showSuccessSnackBar('Commande marquée comme livrée');
    } catch (e) {
      print('Erreur lors de la mise à jour: $e');
      _showErrorSnackBar('Erreur lors de la mise à jour du statut');
    }
  }

  Future<void> loadSupplierOrders() async {
    print('=== CHARGEMENT COMMANDES FOURNISSEURS ===');
    try {
      final supplierOrdersList = await isar.supplierOrders
          .filter()
          .orderDateIsNotNull()
          .sortByOrderDateDesc()
          .findAll();
      
      print('Commandes fournisseurs trouvées: ${supplierOrdersList.length}');
      
      // Charger les relations pour chaque commande fournisseur si besoin
      for (final order in supplierOrdersList) {
        await order.supplierLink.load();
        await order.supplierOrderItems.load();
        for (final item in order.supplierOrderItems) {
          await item.productLink.load();
        }
        await order.createdByLink.load();
      }
      
      supplierOrders.assignAll(supplierOrdersList);
      updateFilteredLists();
      print('Commandes fournisseurs assignées: ${supplierOrders.length}');
      print('=== FIN CHARGEMENT COMMANDES FOURNISSEURS ===');
    } catch (e) {
      print('Erreur lors du chargement des commandes fournisseurs: $e');
      _showErrorSnackBar('Erreur lors du chargement des commandes fournisseurs');
    }
  }

  /// Créer une nouvelle commande fournisseur
  Future<void> createSupplierOrder({
    required String supplierName,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      // Vérifier si le fournisseur existe
      final suppliers = await isar.suppliers
          .filter()
          .nameContains(supplierName, caseSensitive: false)
          .findAll();
      
      if (suppliers.isEmpty) {
        _showErrorSnackBar('Fournisseur "$supplierName" non trouvé');
        return;
      }

      final supplier = suppliers.first;
      final supplierOrderItems = <SupplierOrderItem>[];
      double totalPrice = 0;

      // Créer les articles de commande
      for (final item in items) {
        final productName = item['productName'] as String;
        final quantity = item['quantity'] as int;
        final unitCost = item['unitCost'] as double;

        final products = await isar.products
            .filter()
            .nameContains(productName, caseSensitive: false)
            .findAll();

        if (products.isNotEmpty) {
          final product = products.first;
          final orderItem = SupplierOrderItem(
            quantityOrdered: quantity,
            unitCost: unitCost,
          );
          orderItem.productLink.value = product;
          supplierOrderItems.add(orderItem);
          totalPrice += quantity * unitCost;
        }
      }

      if (supplierOrderItems.isEmpty) {
        _showErrorSnackBar('Aucun produit valide trouvé');
        return;
      }

      // Créer la commande fournisseur
      final order = SupplierOrder(
        orderNumber: 'CF-${DateTime.now().millisecondsSinceEpoch}',
        orderDate: DateTime.now(),
        totalPrice: totalPrice,
        status: SupplierOrderStatusIsar.draft,
        notes: notes,
      );

      await isar.writeTxn(() async {
        order.supplierLink.value = supplier;
        
        // Récupérer l'utilisateur connecté
        final users = await isar.users.where().findAll();
        if (users.isNotEmpty) {
          order.createdByLink.value = users.first;
        }

        await isar.supplierOrders.put(order);
        await order.supplierLink.save();
        await order.createdByLink.save();

        // Sauvegarder les articles
        for (final item in supplierOrderItems) {
          item.supplierOrderLink.value = order;
          await isar.supplierOrderItems.put(item);
          await item.productLink.save();
          await item.supplierOrderLink.save();
        }
      });

      // Recharger les données
      await loadSupplierOrders();
      await refreshData();
      await refreshProducts();
      Get.snackbar(
        'Succès',
        'Commande fournisseur créée avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
    } catch (e) {
      print('Erreur lors de la création de la commande fournisseur: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de la création de la commande fournisseur',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Supprimer une commande fournisseur
  Future<void> deleteSupplierOrder(SupplierOrder order) async {
    try {
      await isar.writeTxn(() async {
        // Supprimer d'abord les articles
        await order.supplierOrderItems.load();
        for (final item in order.supplierOrderItems) {
          await isar.supplierOrderItems.delete(item.id!);
        }
        // Puis supprimer la commande
        await isar.supplierOrders.delete(order.id!);
      });

      await loadSupplierOrders();
      await refreshData();
      await refreshProducts();
      Get.snackbar(
        'Succès',
        'Commande fournisseur supprimée avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Erreur lors de la suppression: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de la suppression de la commande fournisseur',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Marquer une commande fournisseur comme reçue (réapprovisionnement)
  Future<void> markSupplierOrderAsReceived(SupplierOrder order) async {
    try {
      await isar.writeTxn(() async {
        for (final item in order.supplierOrderItems) {
          await item.productLink.load();
          final product = item.productLink.value;
          if (product != null) {
            product.stockQuantity = (product.stockQuantity ?? 0) + (item.quantityOrdered ?? 0);
            await isar.products.put(product);
          }
        }
        order.status = SupplierOrderStatusIsar.received;
        order.actualDeliveryDate = DateTime.now();
        await isar.supplierOrders.put(order);
      });
      await loadSupplierOrders();
      await refreshData();
      await refreshProducts();
      Get.snackbar(
        'Stock réapprovisionné',
        'Le stock a été mis à jour.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Erreur lors de la mise à jour: $e');
      _showErrorSnackBar('Erreur lors de la mise à jour du statut');
    }
  }

  /// Créer des données de test si aucune commande n'existe
  Future<void> createTestData() async {
    print('=== CRÉATION DONNÉES DE TEST ===');
    try {
      // Vérifier s'il y a des clients
      final customers = await isar.customers.where().findAll();
      if (customers.isEmpty) {
        print('Aucun client trouvé, création d\'un client de test');
        final testCustomer = Customer(
          name: 'Client Test',
          email: 'test@example.com',
          phone: '0123456789',
        );
        await isar.writeTxn(() async {
          await isar.customers.put(testCustomer);
        });
      }

      // Vérifier s'il y a des fournisseurs
      final suppliers = await isar.suppliers.where().findAll();
      if (suppliers.isEmpty) {
        print('Aucun fournisseur trouvé, création d\'un fournisseur de test');
        final testSupplier = Supplier(
          name: 'Fournisseur Test',
          email: 'fournisseur@example.com',
          phone: '0987654321',
        );
        await isar.writeTxn(() async {
          await isar.suppliers.put(testSupplier);
        });
      }

      // Vérifier s'il y a des produits
      final products = await isar.products.where().findAll();
      if (products.isEmpty) {
        print('Aucun produit trouvé, création d\'un produit de test');
        final testProduct = Product(
          name: 'Produit Test',
          salePrice: 29.99,
          stockQuantity: 100,
        );
        await isar.writeTxn(() async {
          await isar.products.put(testProduct);
        });
      }

      // Vérifier s'il y a des commandes clients
      final existingOrders = await isar.orders.where().findAll();
      if (existingOrders.isEmpty) {
        print('Aucune commande client trouvée, création d\'une commande de test');
        await _createTestClientOrder();
      }

      // Vérifier s'il y a des commandes fournisseurs
      final existingSupplierOrders = await isar.supplierOrders.where().findAll();
      if (existingSupplierOrders.isEmpty) {
        print('Aucune commande fournisseur trouvée, création d\'une commande de test');
        await _createTestSupplierOrder();
      }

      print('=== FIN CRÉATION DONNÉES DE TEST ===');
    } catch (e) {
      print('Erreur lors de la création des données de test: $e');
    }
  }

  Future<void> _createTestClientOrder() async {
    try {
      final customers = await isar.customers.where().findAll();
      final products = await isar.products.where().findAll();
      final users = await isar.users.where().findAll();

      if (customers.isNotEmpty && products.isNotEmpty) {
        final order = Order(
          orderNumber: 'CMD-${DateTime.now().millisecondsSinceEpoch}',
          orderDate: DateTime.now(),
          totalPrice: 59.98,
          status: OrderStatusIsar.pending,
        );

        await isar.writeTxn(() async {
          order.customerLink.value = customers.first;
          if (users.isNotEmpty) {
            order.createdByLink.value = users.first;
          }
          await isar.orders.put(order);
          await order.customerLink.save();
          await order.createdByLink.save();

          // Créer un article de commande
          final orderItem = OrderItem(
            quantity: 2,
            unitPriceAtOrder: 29.99,
          );
          orderItem.productLink.value = products.first;
          orderItem.orderLink.value = order;
          await isar.orderItems.put(orderItem);
          await orderItem.productLink.save();
          await orderItem.orderLink.save();
        });
        print('Commande client de test créée');
      }
    } catch (e) {
      print('Erreur lors de la création de la commande client de test: $e');
    }
  }

  Future<void> _createTestSupplierOrder() async {
    try {
      final suppliers = await isar.suppliers.where().findAll();
      final products = await isar.products.where().findAll();
      final users = await isar.users.where().findAll();

      if (suppliers.isNotEmpty && products.isNotEmpty) {
        final order = SupplierOrder(
          orderNumber: 'CF-${DateTime.now().millisecondsSinceEpoch}',
          orderDate: DateTime.now(),
          totalPrice: 149.95,
          status: SupplierOrderStatusIsar.draft,
        );

        await isar.writeTxn(() async {
          order.supplierLink.value = suppliers.first;
          if (users.isNotEmpty) {
            order.createdByLink.value = users.first;
          }
          await isar.supplierOrders.put(order);
          await order.supplierLink.save();
          await order.createdByLink.save();

          // Créer un article de commande fournisseur
          final orderItem = SupplierOrderItem(
            quantityOrdered: 5,
            unitCost: 29.99,
          );
          orderItem.productLink.value = products.first;
          orderItem.supplierOrderLink.value = order;
          await isar.supplierOrderItems.put(orderItem);
          await orderItem.productLink.save();
          await orderItem.supplierOrderLink.save();
        });
        print('Commande fournisseur de test créée');
      }
    } catch (e) {
      print('Erreur lors de la création de la commande fournisseur de test: $e');
    }
  }

  Debt? getDebtForOrder(Order order) {
    final customerId = order.customerLink.value?.id;
    if (customerId == null) return null;
    return debtsByCustomerId[customerId];
  }

  Future<void> recordDebtPaymentForOrder(Order order, double amount, String method) async {
    final customerId = order.customerLink.value?.id;
    if (customerId == null) return;
    final debt = debtsByCustomerId[customerId];
    if (debt == null) return;
    
    try {
      await customerService.recordDebtPayment(
        debtId: debt.id!,
        amountPaid: amount,
        paymentMethod: method,
      );
      
      // Rafraîchir la dette
      final debts = await customerService.getDebtsForCustomer(customerId);
      final unpaid = debts.firstWhereOrNull((d) => d.status != DebtStatusIsar.paid);
      debtsByCustomerId[customerId] = unpaid;
      update();
    } catch (e) {
      print('Erreur lors de l\'enregistrement du paiement: $e');
    }
  }

  /// Obtenir le nombre total de commandes clients
  int get clientOrdersCount => orders.length;

  /// Obtenir le nombre total de commandes fournisseurs
  int get supplierOrdersCount => supplierOrders.length;

  /// Mettre à jour les listes filtrées
  void updateFilteredLists() {
    final search = searchQuery.value.toLowerCase();
    
    if (search.isEmpty) {
      filteredClientOrders.assignAll(orders);
      filteredSupplierOrders.assignAll(supplierOrders);
    } else {
      final filteredClients = orders.where((order) {
        final customerName = order.customerLink.value?.name?.toLowerCase() ?? '';
        final orderNumber = order.orderNumber?.toLowerCase() ?? '';
        final status = order.status?.toString().toLowerCase() ?? '';
        return customerName.contains(search) || 
               orderNumber.contains(search) || 
               status.contains(search);
      }).toList();
      
      final filteredSuppliers = supplierOrders.where((order) {
        final supplierName = order.supplierLink.value?.name?.toLowerCase() ?? '';
        final orderNumber = order.orderNumber?.toLowerCase() ?? '';
        final status = order.status?.toString().toLowerCase() ?? '';
        return supplierName.contains(search) || 
               orderNumber.contains(search) || 
               status.contains(search);
      }).toList();
      
      filteredClientOrders.assignAll(filteredClients);
      filteredSupplierOrders.assignAll(filteredSuppliers);
    }
  }

  /// Obtenir le statut coloré pour une commande client
  Color getOrderStatusColor(OrderStatusIsar? status) {
    switch (status) {
      case OrderStatusIsar.pending:
        return Colors.orange;
      case OrderStatusIsar.processing:
        return Colors.blue;
      case OrderStatusIsar.shipped:
        return Colors.purple;
      case OrderStatusIsar.delivered:
        return Colors.green;
      case OrderStatusIsar.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Obtenir le statut coloré pour une commande fournisseur
  Color getSupplierOrderStatusColor(SupplierOrderStatusIsar? status) {
    switch (status) {
      case SupplierOrderStatusIsar.draft:
        return Colors.grey;
      case SupplierOrderStatusIsar.sent:
        return Colors.blue;
      case SupplierOrderStatusIsar.partiallyReceived:
        return Colors.orange;
      case SupplierOrderStatusIsar.received:
        return Colors.green;
      case SupplierOrderStatusIsar.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formater la date pour l'affichage
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Obtenir le nombre d'articles dans une commande client
  int getOrderItemsCount(Order order) {
    return order.orderItems.length;
  }

  /// Obtenir le nombre d'articles dans une commande fournisseur
  int getSupplierOrderItemsCount(SupplierOrder order) {
    return order.supplierOrderItems.length;
  }

  /// Rafraîchir la liste des produits (pour la vue fournisseur)
  Future<void> refreshProducts() async {
    try {
      // Recharge la liste des produits
      final products = await isar.products.where().findAll();
      // Si tu as une variable observable pour les produits, fais :
      // this.products.assignAll(products);
      update();
    } catch (e) {
      print('Erreur lors du rafraîchissement des produits: $e');
    }
  }
}
