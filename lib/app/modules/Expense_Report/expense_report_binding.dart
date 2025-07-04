import 'package:get/get.dart';

import 'expense_report_controller.dart';
import 'package:flutter/material.dart';

class ExpenseReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseReportController>(
      () => ExpenseReportController(),
    );
  }
}

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseReportController>(() => ExpenseReportController());
  }
}
