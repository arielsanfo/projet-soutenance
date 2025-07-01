import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/Expense_Report/expense_report_controller.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';


class ExpenseReportView extends GetView<ExpenseReportController> {
   ExpenseReportView({super.key}){
        Get.lazyPut(() => ExpenseReportView());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Rapport des Dépenses', style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main title
            Text('Dépenses', style: AppTypography.headline1),
            SizedBox(height: AppSpacings.l),

            // Period selector
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.xxl,
                vertical: AppSpacings.xl,
              ),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: AppRadius.defaultRadius,
                border: Border.all(color: AppColors.greyMedium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mai 2024', style: AppTypography.titleMedium),
                  Icon(Icons.arrow_drop_down, color: AppColors.greyDark),
                ],
              ),
            ),
            SizedBox(height: AppSpacings.xxl),

            // Total expenses
            Text('Total Dépenses (Mai)', style: AppTypography.titleMedium),
            SizedBox(height: AppSpacings.m),
            Text(
              '875.50 €',
              style: AppTypography.headline1.apply(
                color: AppColors.primaryDarker,
              ),
            ),
            SizedBox(height: AppSpacings.xxxl),

            // Bar chart placeholder
            Container(
              height: 200,
              padding: EdgeInsets.all(AppSpacings.l),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: AppRadius.defaultRadius,
              ),
              child: Center(
                child: Text(
                  '[Graphique Barres: Loyer, Fournitures, Marketing, Salaires]',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium,
                ),
              ),
            ),
            SizedBox(height: AppSpacings.xxl),

            // Expense list title
            Text('Dépenses détaillées', style: AppTypography.titleLarge),
            SizedBox(height: AppSpacings.l),

            // Expense list
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: expenses.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppSpacings.s),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Container(
                  padding: EdgeInsets.all(AppSpacings.l),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: AppRadius.defaultRadius,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expense.name,
                        style: TextStyle(fontSize: AppSpacings.l),
                      ),
                      Text(
                        '${expense.amount} €',
                        style: AppTypography.titleSmall.apply(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: AppSpacings.xxxxl * 2,
            ), // Space for the floating button
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: () {
            //
          },
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.defaultRadius),
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
            child: Text('Ajouter une Dépense',
                style: TextStyle(fontSize: AppSpacings.l)),
          ),
        ),
      ),
    );
  }
}

class Expense {
  final String name;
  final String amount;

  Expense(this.name, this.amount);
}

final List<Expense> expenses = [
  Expense('Loyer Boutique - Mai', '600.00'),
  Expense('Facture Électricité', '75.50'),
  Expense('Fournitures de bureau', '120.00'),
  Expense('Campagne marketing', '80.00'),
  Expense('Salaires employés', '500.00'),
  Expense('Abonnement logiciel', '29.99'),
];
  


// Sample expense data


