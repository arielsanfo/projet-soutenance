import 'package:flutter_application_1/app/data/controller/customerService.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';
// import '../data/controller/customerService.dart';

class DettesController extends GetxController {
  final dettes = <Debt>[].obs;
  late final Isar isar;
  late final CustomerService customerService;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    customerService = CustomerService(isar);
    loadAllDettes().then((_) async {
      // Si aucune dette n'existe, créer des données de test
      if (dettes.isEmpty) {
        await createTestDebts();
      }
    });
  }

  Future<void> loadAllDettes() async {
    final allDettes = await isar.debts.where().findAll();
    for (final d in allDettes) {
      await d.customerLink.load();
    }
    dettes.assignAll(allDettes);
  }

  Future<void> recordDebtPayment({
    required Id debtId,
    required double amountPaid,
    required String paymentMethod,
    Id? recordedByUserId,
  }) async {
    await customerService.recordDebtPayment(
      debtId: debtId,
      amountPaid: amountPaid,
      paymentMethod: paymentMethod,
      recordedByUserId: recordedByUserId,
    );
    await loadAllDettes();
  }

  Future<List<DebtPayment>> getPaymentsForDebt(Debt debt) async {
    await debt.payments.load();
    return debt.payments.toList();
  }

  Future<List<Customer>> getAllCustomers() async {
    return await isar.customers.where().findAll();
  }

  Future<List<Product>> getProductsForCustomer(Customer customer) async {
    final productSet = <Product>{};
    
    // Récupérer les produits des ventes
    final salesList = await isar.sales.filter().customerLink((q) => q.idEqualTo(customer.id!)).findAll();
    for (final sale in salesList) {
      await sale.saleItems.load();
      for (final item in sale.saleItems) {
        await item.productLink.load();
        if (item.productLink.value != null) {
          productSet.add(item.productLink.value!);
        }
      }
    }
    
    // Récupérer les produits des commandes
    final ordersList = await isar.orders.filter().customerLink((q) => q.idEqualTo(customer.id!)).findAll();
    for (final order in ordersList) {
      await order.orderItems.load();
      for (final item in order.orderItems) {
        await item.productLink.load();
        if (item.productLink.value != null) {
          productSet.add(item.productLink.value!);
        }
      }
    }
    
    return productSet.toList();
  }

  Future<List<Map<String, dynamic>>> getCustomerOrders(Customer customer) async {
    final orders = await isar.orders.filter().customerLink((q) => q.idEqualTo(customer.id!)).findAll();
    final ordersData = <Map<String, dynamic>>[];
    
    for (final order in orders) {
      await order.orderItems.load();
      final items = <Map<String, dynamic>>[];
      double totalOrder = 0;
      
      for (final item in order.orderItems) {
        await item.productLink.load();
        if (item.productLink.value != null) {
          final product = item.productLink.value!;
          final itemTotal = (item.quantity ?? 0) * (item.unitPriceAtOrder ?? 0);
          totalOrder += itemTotal;
          
          items.add({
            'product': product,
            'quantity': item.quantity ?? 0,
            'unitPrice': item.unitPriceAtOrder ?? 0,
            'total': itemTotal,
          });
        }
      }
      
      ordersData.add({
        'order': order,
        'items': items,
        'total': totalOrder,
      });
    }
    
    return ordersData;
  }

  Future<void> createManualDebt({
    required Customer customer,
    required double amount,
    required List<Product> selectedProducts,
    double? advanceAmount,
    String? notes,
  }) async {
    try {
      // Calculer le montant restant après avance
      final remainingAmount = advanceAmount != null ? amount - advanceAmount : amount;
      
      // Déterminer le statut initial
      DebtStatusIsar initialStatus;
      if (remainingAmount <= 0) {
        initialStatus = DebtStatusIsar.paid;
      } else if (advanceAmount != null && advanceAmount > 0) {
        initialStatus = DebtStatusIsar.partiallyPaid;
      } else {
        initialStatus = DebtStatusIsar.unpaid;
      }
      
      final debt = Debt(
        initialAmount: amount,
        debtDate: DateTime.now(),
        status: initialStatus,
        notes: notes ?? 'Ajustement manuel - Produits: ${selectedProducts.map((p) => p.name).join(", ")}',
      );
      
      await isar.writeTxn(() async {
        debt.customerLink.value = customer;
        // Assigner le montant restant après création
        debt.remainingAmount = remainingAmount > 0 ? remainingAmount : 0;
        await isar.debts.put(debt);
        await debt.customerLink.save();
      });
      
      // Si une avance est fournie, créer un paiement
      if (advanceAmount != null && advanceAmount > 0) {
        final payment = DebtPayment(
          amountPaid: advanceAmount,
          paymentDate: DateTime.now(),
          paymentMethod: 'Ajustement manuel',
          notes: 'Avance lors de la création de la dette',
        );
        
        await isar.writeTxn(() async {
          payment.debtLink.value = debt;
          await isar.debtPayments.put(payment);
          await payment.debtLink.save();
        });
      }
      
      // Rafraîchir la liste des dettes
      await loadAllDettes();
      
      print('Dette créée avec succès: ID=${debt.id}, Montant=${amount}, Restant=${remainingAmount}');
    } catch (e) {
      print('Erreur lors de la création de la dette: $e');
      rethrow;
    }
  }

  Future<void> createTestDebts() async {
    try {
      print('=== CRÉATION DETTES DE TEST ===');
      
      // Vérifier s'il y a des clients
      final customers = await isar.customers.where().findAll();
      if (customers.isEmpty) {
        print('Aucun client trouvé, création de clients de test');
        final testCustomers = [
          Customer(name: 'Jean Dupont', email: 'jean@example.com', phone: '0123456789'),
          Customer(name: 'Marie Martin', email: 'marie@example.com', phone: '0987654321'),
          Customer(name: 'Pierre Durand', email: 'pierre@example.com', phone: '0555666777'),
        ];
        await isar.writeTxn(() async {
          for (final customer in testCustomers) {
            await isar.customers.put(customer);
          }
        });
      }
      
      // Vérifier s'il y a des dettes
      final existingDebts = await isar.debts.where().findAll();
      if (existingDebts.isEmpty) {
        print('Aucune dette trouvée, création de dettes de test');
        final customers = await isar.customers.where().findAll();
        
        if (customers.isNotEmpty) {
          final testDebts = [
            Debt(
              initialAmount: 150.0,
              debtDate: DateTime.now().subtract(Duration(days: 30)),
              dueDate: DateTime.now().add(Duration(days: 15)),
              notes: 'Achat de produits électroniques',
              status: DebtStatusIsar.unpaid,
            ),
            Debt(
              initialAmount: 75.50,
              debtDate: DateTime.now().subtract(Duration(days: 15)),
              dueDate: DateTime.now().add(Duration(days: 5)),
              notes: 'Livraison express',
              status: DebtStatusIsar.partiallyPaid,
            ),
            Debt(
              initialAmount: 200.0,
              debtDate: DateTime.now().subtract(Duration(days: 45)),
              dueDate: DateTime.now().subtract(Duration(days: 10)),
              notes: 'Commande en gros',
              status: DebtStatusIsar.paid,
            ),
          ];
          
          await isar.writeTxn(() async {
            for (int i = 0; i < testDebts.length && i < customers.length; i++) {
              final debt = testDebts[i];
              debt.customerLink.value = customers[i];
              debt.remainingAmount = debt.initialAmount;
              
              // Ajuster le montant restant selon le statut
              if (debt.status == DebtStatusIsar.partiallyPaid) {
                debt.remainingAmount = debt.initialAmount! * 0.4; // 40% restant
              } else if (debt.status == DebtStatusIsar.paid) {
                debt.remainingAmount = 0;
              }
              
              await isar.debts.put(debt);
              await debt.customerLink.save();
            }
          });
          print('Dettes de test créées');
        }
      }
      
      // Recharger les dettes
      await loadAllDettes();
      print('=== FIN CRÉATION DETTES DE TEST ===');
    } catch (e) {
      print('Erreur lors de la création des dettes de test: $e');
    }
  }
}
