import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/Expense_Report/expense_report_controller.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../data/storage.dart';

// Widget filtre période
class _PeriodFilter extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final void Function(int, int) onChanged;
  _PeriodFilter({required this.selectedMonth, required this.selectedYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    final years = List.generate(6, (i) => DateTime.now().year - i);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyMedium.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: AppColors.primaryColor, size: 20),
          SizedBox(width: 6),
          DropdownButton<int>(
            value: selectedMonth,
            underline: SizedBox(),
            items: List.generate(12, (i) => DropdownMenuItem(
              value: i + 1,
              child: Text(months[i]),
            )),
            onChanged: (m) => onChanged(m!, selectedYear),
          ),
          SizedBox(width: 8),
          Icon(Icons.date_range, color: AppColors.primaryColor, size: 20),
          SizedBox(width: 6),
          DropdownButton<int>(
            value: selectedYear,
            underline: SizedBox(),
            items: years.map((y) => DropdownMenuItem(
              value: y,
              child: Text(y.toString()),
            )).toList(),
            onChanged: (y) => onChanged(selectedMonth, y!),
          ),
        ],
      ),
    );
  }
}

String _monthName(int month) {
  const months = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
  return months[month];
}

Future<void> _exportPdf(BuildContext context, ExpenseReportController controller) async {
  final pdf = pw.Document();
  final month = _monthName(controller.selectedMonth.value);
  final year = controller.selectedYear.value;
  final expenses = controller.filteredExpenses;
  pdf.addPage(
    pw.Page(
      build: (pw.Context ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Rapport des Dépenses', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Période : $month $year', style: pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 16),
          pw.Text('Total : ${controller.total.toStringAsFixed(2)} FCFA', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Nom', 'Catégorie', 'Date', 'Montant'],
            data: expenses.map((e) => [
              e.description ?? '',
              e.category ?? '',
              e.expenseDate != null ? '${e.expenseDate!.day}/${e.expenseDate!.month}/${e.expenseDate!.year}' : '',
              '${(e.amount ?? 0).toStringAsFixed(2)} FCFA',
            ]).toList(),
          ),
        ],
      ),
    ),
  );
  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

class ExpenseReportView extends GetView<ExpenseReportController> {
  ExpenseReportView({super.key});

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
      body: GetBuilder<ExpenseReportController>(
        builder: (controller) => SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PeriodFilter(
                    selectedMonth: controller.selectedMonth.value,
                    selectedYear: controller.selectedYear.value,
                    onChanged: (m, y) => controller.setPeriod(m, y),
                  ),
                  // Le bouton PDF est déplacé en bas
                ],
              ),
              SizedBox(height: AppSpacings.l),
              Text('Dépenses', style: AppTypography.headline1),
              SizedBox(height: AppSpacings.l),
              // Sélecteur de période (placeholder)
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
              // Total dynamique
              Text('Total Dépenses (${_monthName(controller.selectedMonth.value)} ${controller.selectedYear.value})', style: AppTypography.titleMedium),
              SizedBox(height: AppSpacings.m),
              Text(
                '${controller.total.toStringAsFixed(2)} FCFA',
                style: AppTypography.headline1.apply(
                  color: AppColors.primaryDarker,
                ),
              ),
              SizedBox(height: AppSpacings.xxxl),
              // Bar chart réel
              Text('Répartition par catégorie', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Container(
                height: 220,
                padding: EdgeInsets.all(AppSpacings.l),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: AppRadius.defaultRadius,
                ),
                child: controller.filteredExpenses.isEmpty
                    ? Center(child: Text('Aucune donnée pour le graphique'))
                    : _ExpenseBarChart(expenses: controller.filteredExpenses),
              ),
              SizedBox(height: AppSpacings.xxl),
              Text('Dépenses détaillées', style: AppTypography.titleLarge),
              SizedBox(height: AppSpacings.l),
              controller.filteredExpenses.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.primaryColor, size: 40),
                            SizedBox(height: 12),
                            Text('Aucune dépense enregistrée.', style: AppTypography.bodyMedium),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.filteredExpenses.length,
                      separatorBuilder: (context, index) => SizedBox(height: AppSpacings.s),
                      itemBuilder: (context, index) {
                        final expense = controller.filteredExpenses[index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(AppSpacings.l),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.defaultRadius,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.category, size: 14, color: AppColors.primaryColor),
                                            SizedBox(width: 4),
                                            Text(expense.category ?? '', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.calendar_today, size: 13, color: AppColors.secondaryColor),
                                      SizedBox(width: 2),
                                      Text(
                                        expense.expenseDate != null
                                            ? '${expense.expenseDate!.day}/${expense.expenseDate!.month}/${expense.expenseDate!.year}'
                                            : '',
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Text(expense.description ?? '', style: AppTypography.titleMedium),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${expense.amount?.toStringAsFixed(2) ?? ''} FCFA', style: AppTypography.titleLarge.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 6),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: AppRadius.defaultRadius),
                                            title: Text('Supprimer la dépense'),
                                            content: Text('Voulez-vous vraiment supprimer cette dépense ?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(ctx, false),
                                                child: Text('Annuler'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(ctx, true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.errorColor,
                                                  foregroundColor: AppColors.textOnPrimary,
                                                ),
                                                child: Text('Supprimer'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await controller.removeExpense(expense);
                                          Get.snackbar('Suppression', 'Dépense supprimée', backgroundColor: AppColors.errorColor, colorText: AppColors.textOnPrimary, icon: Icon(Icons.delete, color: Colors.white));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(Icons.delete, color: AppColors.errorColor, size: 22),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              SizedBox(height: AppSpacings.xxxxl * 2),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addExpense',
            onPressed: () {
              Get.toNamed('/add-expense');
            },
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.defaultRadius),
            label: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
              child: Text('Ajouter une Dépense', style: TextStyle(fontSize: AppSpacings.l)),
            ),
            icon: Icon(Icons.add),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'exportPdf',
            onPressed: () async {
              final controller = Get.find<ExpenseReportController>();
              await _exportPdf(context, controller);
            },
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryColor,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 28),
            tooltip: 'Exporter PDF',
          ),
        ],
      ),
    );
  }
}

// Widget du graphique à barres
class _ExpenseBarChart extends StatelessWidget {
  final List<Expense> expenses;
  const _ExpenseBarChart({required this.expenses, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Regrouper les montants par catégorie
    final Map<String, double> data = {};
    for (final e in expenses) {
      final cat = e.category ?? '';
      data[cat] = (data[cat] ?? 0) + (e.amount ?? 0);
    }
    final categories = data.keys.toList();
    final values = data.values.toList();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b)) * 1.2 + 1,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= categories.length) return Container();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(categories[idx], style: TextStyle(fontSize: 12)),
                );
              },
              reservedSize: 48,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        barGroups: List.generate(categories.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: values[i],
                color: AppColors.primaryColor,
                width: 22,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }),
      ),
    );
  }
}


