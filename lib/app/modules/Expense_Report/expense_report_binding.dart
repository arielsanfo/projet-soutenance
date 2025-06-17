import 'package:get/get.dart';

import 'expense_report_controller.dart';

class ExpenseReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseReportController>(
      () => ExpenseReportController(),
    );
  }
}
