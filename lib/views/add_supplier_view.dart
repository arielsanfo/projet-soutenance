import 'package:flutter/material.dart';
// import 'package:flutter_application_1/customs/app_constante.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
// import 'package:flutter_application_1/views/list_supplier_view.dart';

class AddSupplierScreen extends StatefulWidget {
  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _productsController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Ajouter Fournisseur', style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacings.xl),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _companyController,
                  label: 'Nom de l\'entreprise',
                ),
                SizedBox(height: AppSpacings.m),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email de contact',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: AppSpacings.m),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Téléphone',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: AppSpacings.m),
                _buildTextField(
                  controller: _addressController,
                  label: 'Adresse complète',
                  maxLines: 2,
                ),
                SizedBox(height: AppSpacings.m),
                _buildTextField(
                  controller: _contactController,
                  label: 'Nom du contact principal',
                ),
                SizedBox(height: AppSpacings.m),
                _buildTextField(
                  controller: _productsController,
                  label: 'Produits principaux, notes...',
                  maxLines: 3,
                ),
                SizedBox(height: AppSpacings.m),
                _buildTextField(
                  controller: _paymentController,
                  label: 'Conditions de paiement (ex: Net 30)',
                ),
                SizedBox(height: AppSpacings.xl),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.backgroundInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.l),
          borderSide: BorderSide(color: AppColors.greyDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.l),
          borderSide: BorderSide(color: AppColors.greyMedium, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacings.l,
          vertical: AppSpacings.m,
        ),
        labelStyle: TextStyle(color: AppColors.greyMedium),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire';
        }
        if (keyboardType == TextInputType.emailAddress &&
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email invalide';
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddSupplierScreen()),
        );
        if (_formKey.currentState!.validate()) {
          // Enregistrement des données
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(double.infinity, AppSpacings.xxxl * 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacings.l),
        ),
      ),
      child: Text(
        'Enregistrer Fournisseur',
        style: AppTypography.bodyLarge.copyWith(color: AppColors.textOnPrimary),
      ),
    );
  }
}
