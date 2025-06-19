import 'package:isar/isar.dart';
import '../storage.dart';

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Dépenses (ExpenseService)
//----------------------------------------------------------------------------//
class ExpenseService {
  final Isar isar;
  ExpenseService(this.isar);
  
  /// Sauvegarder une dépense.
  Future<Expense> saveExpense(Expense expense, {Id? userId}) async {
    await isar.writeTxn(() async {
        if(userId != null) expense.recordedByLink.value = await isar.users.get(userId);
        await isar.expenses.put(expense);
        await expense.recordedByLink.save();
    });
    return expense;
  }
  
  /// Obtenir toutes les dépenses.
  Future<List<Expense>> getAllExpenses() async {
      return await isar.expenses.where().sortByExpenseDateDesc().findAll();
  }
}
