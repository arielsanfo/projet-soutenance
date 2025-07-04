import 'package:get/get.dart';
import '../../data/controller/expenseService.dart';
import '../../data/storage.dart';

class ExpenseReportController extends GetxController {
  final ExpenseService expenseService;
  ExpenseReportController(this.expenseService);

  final RxList<Expense> expenses = <Expense>[].obs;

  // Période sélectionnée
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  double get total => filteredExpenses.fold(0.0, (sum, e) => sum + (e.amount ?? 0));

  List<Expense> get filteredExpenses => expenses.where((e) =>
      (e.expenseDate?.month == selectedMonth.value) &&
      (e.expenseDate?.year == selectedYear.value)).toList();

  void setPeriod(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    update();
  }

  Future<void> loadExpenses() async {
    final loaded = await expenseService.getAllExpenses();
    expenses.assignAll(loaded);
    update();
  }

  Future<void> addExpense(Expense expense) async {
    await expenseService.saveExpense(expense);
    await loadExpenses();
  }

  Future<void> removeExpense(Expense expense) async {
    await expenseService.isar.writeTxn(() async {
      await expenseService.isar.expenses.delete(expense.id!);
    });
    await loadExpenses();
  }

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }
}
