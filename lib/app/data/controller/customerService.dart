import 'package:isar/isar.dart';
import '../storage.dart';

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Clients et Dettes (CustomerService)
//----------------------------------------------------------------------------//
class CustomerService {
  final Isar isar;

  CustomerService(this.isar);

  // --- Gestion des Clients ---

  /// Sauvegarder un client.
  Future<Customer> saveCustomer(Customer customer) async {
    await isar.writeTxn(() => isar.customers.put(customer));
    return customer;
  }

  /// Mettre à jour un client existant.
  Future<Customer> updateCustomer(Customer customer) async {
    await isar.writeTxn(() => isar.customers.put(customer));
    return customer;
  }

  /// Obtenir un client par son ID.
  Future<Customer?> getCustomerById(Id id) async {
    return await isar.customers.get(id);
  }

  /// Obtenir tous les clients.
  Future<List<Customer>> getAllCustomers() async {
    return await isar.customers.where().sortByName().findAll();
  }

  // --- Gestion des Dettes ---

  /// Ajouter une dette à un client.
  Future<Debt> addDebtToCustomer({
    required Id customerId,
    required double amount,
    DateTime? dueDate,
    String? notes,
    Id? relatedSaleId,
  }) async {
    final debt = Debt(
      initialAmount: amount,
      debtDate: DateTime.now(),
      dueDate: dueDate,
      notes: notes,
    );

    await isar.writeTxn(() async {
      final customer = await isar.customers.get(customerId);
      if (customer == null) throw Exception("Client non trouvé");

      debt.customerLink.value = customer;
      if (relatedSaleId != null)
        debt.relatedSaleLink.value = await isar.sales.get(relatedSaleId);

      await isar.debts.put(debt);
      await debt.customerLink.save();
      await debt.relatedSaleLink.save();
    });
    return debt;
  }

  /// Enregistrer un paiement pour une dette.
  Future<Debt?> recordDebtPayment({
    required Id debtId,
    required double amountPaid,
    required String paymentMethod,
    Id? recordedByUserId,
  }) async {
    return await isar.writeTxn(() async {
      final debt = await isar.debts.get(debtId);
      if (debt == null) return null;

      final payment = DebtPayment(
          amountPaid: amountPaid,
          paymentDate: DateTime.now(),
          paymentMethod: paymentMethod);

      debt.remainingAmount = (debt.remainingAmount ?? 0) - amountPaid;
      if (debt.remainingAmount! <= 0.01) {
        // Utiliser une tolérance pour les doubles
        debt.status = DebtStatusIsar.paid;
        debt.remainingAmount = 0;
      } else {
        debt.status = DebtStatusIsar.partiallyPaid;
      }

      payment.debtLink.value = debt;
      if (recordedByUserId != null)
        payment.recordedByLink.value = await isar.users.get(recordedByUserId);

      await isar.debts.put(debt);
      await isar.debtPayments.put(payment);
      await payment.debtLink.save();
      await payment.recordedByLink.save();

      return debt;
    });
  }

  /// Obtenir toutes les dettes d'un client.
  Future<List<Debt>> getDebtsForCustomer(Id customerId) async {
    return await isar.debts
        .filter()
        .customerLink((q) => q.idEqualTo(customerId))
        .findAll();
  }

  Future<void> delete(Id id) async {
    await isar.writeTxn(() => isar.customers.delete(id));
    await isar.writeTxn(() =>
        isar.debts.filter().customerLink((q) => q.idEqualTo(id)).deleteAll());
  }
}
