import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({super.key}) {
    Get.lazyPut(() => AddProductView());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: GetBuilder<AddProductController>(
          builder: (controller) => Text(
            controller.isEditing ? 'Modifier le Produit' : 'Nouveau Produit',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _imageSelection(),
              SizedBox(height: AppSpacings.xxxl),
              _buildFormField(
                controller: controller.nameController,
                label: 'Nom du produit',
                hint: 'Ex: Pommes Gala Bio',
                icon: AppIcons.products,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacings.xxl),
              _buildFormField(
                controller: controller.descriptionController,
                label: 'Description',
                hint: 'Décrivez le produit en détail...',
                icon: AppIcons.info,
                maxLines: 2,
              ),
              SizedBox(height: AppSpacings.xxl),
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: controller.priceController,
                      label: 'Prix de vente',
                      hint: '0.00',
                      icon: AppIcons.credit_card,
                      keyboardType: TextInputType.number,
                      prefix: 'fcfa ',
                    ),
                  ),
                  SizedBox(width: AppSpacings.l),
                  Expanded(
                    child: _buildFormField(
                      controller: controller.stockController,
                      label: 'Stock initial',
                      hint: '0',
                      icon: AppIcons.inventory,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacings.xxl),
              _buildFormField(
                controller: controller.categoryController,
                label: 'Catégorie',
                hint: 'Ex: Vêtements, Électronique',
                icon: AppIcons.category,
              ),
              SizedBox(height: AppSpacings.xxl),
              _buildFormField(
                controller: controller.skuController,
                label: 'SKU (Optionnel)',
                hint: 'Code produit unique',
                icon: AppIcons.barcode,
              ),
              SizedBox(height: AppSpacings.xxl),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      controller.saveProduct();
                    },
                    child: GetBuilder<AddProductController>(
                      builder: (controller) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.isEditing ? AppIcons.edit : AppIcons.add,
                            color: AppColors.textOnPrimary,
                            size: 24,
                          ),
                          SizedBox(width: AppSpacings.s),
                          Text(
                            controller.isEditing
                                ? 'Modifier le Produit'
                                : 'Enregistrer le Produit',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSelection() {
    return Container(
      height: AppSpacings.xxxxl * 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Action pour sélectionner une image
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(AppSpacings.l),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacings.l),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    AppIcons.camera,
                    size: AppSpacings.xxl * 1.5,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: AppSpacings.l),
                Text(
                  'Ajouter une image',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // SizedBox(height: AppSpacings.xs),
                // Text(
                //   'Tapez pour sélectionner une photo',
                //   style: AppTypography.bodySmall.copyWith(
                //     color: AppColors.textLight,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int? maxLines = 1,
    String? prefix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
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
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefix,
          prefixIcon: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.backgroundWhite,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacings.l,
            vertical: AppSpacings.m,
          ),
          labelStyle: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: AppColors.greyMedium,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
