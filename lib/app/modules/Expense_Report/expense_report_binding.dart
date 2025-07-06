import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/expenseService.dart';
// import '../../data/storage.dart';
import 'expense_report_controller.dart';
// import 'package:flutter/material.dart';

class ExpenseReportBinding extends Bindings {
  @override
  void dependencies() {
    final isar = Get.find<Isar>();
    Get.lazyPut<ExpenseService>(() => ExpenseService(isar));
    Get.lazyPut<ExpenseReportController>(
      () => ExpenseReportController(Get.find<ExpenseService>()),
    );
  }
}

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    final isar = Get.find<Isar>();
    Get.lazyPut<ExpenseService>(() => ExpenseService(isar));
    Get.lazyPut<ExpenseReportController>(() => ExpenseReportController(Get.find<ExpenseService>()));
  }
}
