import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'expense_report_controller.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import '../../data/storage.dart';

class AddExpenseView extends StatelessWidget {
  AddExpenseView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Loyer', 'Fournitures', 'Marketing', 'Salaires', 'Autre'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Nouvelle Dépense', style: AppTypography.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 420),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.receipt_long, color: AppColors.primaryColor, size: 48),
                  SizedBox(height: 12),
                  Text('Ajouter une dépense', style: AppTypography.headline1, textAlign: TextAlign.center),
                  SizedBox(height: AppSpacings.xl),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom de la dépense',
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  SizedBox(height: AppSpacings.l),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Montant (FCFA)',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Champ obligatoire';
                      final n = double.tryParse(value);
                      if (n == null || n <= 0) return 'Montant invalide';
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacings.l),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: _categories.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Icon(Icons.label, size: 16, color: AppColors.primaryColor),
                          SizedBox(width: 6),
                          Text(cat),
                        ],
                      ),
                    )).toList(),
                    onChanged: (val) => _selectedCategory = val,
                    decoration: InputDecoration(
                      labelText: 'Catégorie',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                    ),
                    validator: (value) => value == null ? 'Sélectionner une catégorie' : null,
                  ),
                  SizedBox(height: AppSpacings.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text('Enregistrer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        shadowColor: AppColors.primaryColor.withOpacity(0.12),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final controller = Get.find<ExpenseReportController>();
                          await controller.addExpense(
                            Expense(
                              description: _nameController.text.trim(),
                              amount: double.parse(_amountController.text.trim()),
                              category: _selectedCategory!,
                              expenseDate: DateTime.now(),
                            ),
                          );
                          Get.back();
                          Get.snackbar('Succès', 'Dépense ajoutée avec succès', backgroundColor: AppColors.successColor, colorText: AppColors.textOnPrimary, icon: Icon(Icons.check_circle, color: Colors.white));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 