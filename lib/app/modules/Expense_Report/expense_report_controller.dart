import 'package:get/get.dart';


class Expense {
  final String name;
  final double amount;
  final String category;
  final DateTime date;

  Expense({required this.name, required this.amount, required this.category, required this.date});
}

class ExpenseReportController extends GetxController {
  final RxList<Expense> expenses = <Expense>[].obs;

  // Période sélectionnée
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  double get total => filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

  List<Expense> get filteredExpenses => expenses.where((e) => e.date.month == selectedMonth.value && e.date.year == selectedYear.value).toList();

  void setPeriod(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    update();
  }

  void addExpense(Expense expense) {
    expenses.add(expense);
    update();
  }

  void removeExpense(int index) {
    expenses.removeAt(index);
    update();
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
