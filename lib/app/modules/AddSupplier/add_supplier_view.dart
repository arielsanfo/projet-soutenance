import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'add_supplier_controller.dart';

class AddSupplierView extends GetView<AddSupplierController> {
  AddSupplierView({super.key}) {
    Get.lazyPut(() => AddSupplierView());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header avec design moderne
          Container(
            padding: EdgeInsets.fromLTRB(
                AppSpacings.l, 60, AppSpacings.l, AppSpacings.xxl),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacings.m),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryDarker,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        AppIcons.suppliers,
                        color: AppColors.textOnPrimary,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: AppSpacings.l),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                controller.isEditMode.value
                                    ? 'Modifier Fournisseur'
                                    : 'Ajouter Fournisseur',
                                style: AppTypography.titleLarge,
                              )),
                          SizedBox(height: AppSpacings.xs),
                          Text(
                            'Gérez vos fournisseurs en toute simplicité',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        AppIcons.close,
                        color: AppColors.textLight,
                        size: 24,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Formulaire
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.xl),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: controller.companyController,
                        label: 'Nom de l\'entreprise *',
                        icon: AppIcons.business,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le nom de l\'entreprise est obligatoire';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.contactController,
                        label: 'Nom du contact principal',
                        icon: AppIcons.person,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.emailController,
                        label: 'Email de contact',
                        icon: AppIcons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.phoneController,
                        label: 'Téléphone',
                        icon: AppIcons.phone,
                        keyboardType: TextInputType.phone,
                        validator: controller.validatePhone,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.addressController,
                        label: 'Adresse complète',
                        icon: AppIcons.location,
                        maxLines: 2,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.productsController,
                        label: 'Produits principaux, notes...',
                        icon: AppIcons.inventory,
                        maxLines: 3,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.paymentController,
                        label: 'Conditions de paiement (ex: Net 30)',
                        icon: AppIcons.payment,
                      ),
                      SizedBox(height: AppSpacings.xxl),
                      Obx(() => _buildSaveButton()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: EdgeInsets.all(AppSpacings.s),
            padding: EdgeInsets.all(AppSpacings.s),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: AppColors.backgroundWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacings.l,
            vertical: AppSpacings.m,
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.saveSupplier,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(
            vertical: AppSpacings.xxxl,
            horizontal: AppSpacings.xxxl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacings.s),
                  Text(
                    'Enregistrement...',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcons.save,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                  SizedBox(width: AppSpacings.s),
                  Text(
                    controller.isEditMode.value
                        ? 'Modifier Fournisseur'
                        : 'Enregistrer Fournisseur',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
