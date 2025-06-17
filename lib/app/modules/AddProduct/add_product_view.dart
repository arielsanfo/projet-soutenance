import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nouveau Produit'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.xxxl),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _imageSelection(),
              SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: controller.nameController,
                decoration:  InputDecoration(labelText: 'Nom du produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: controller.descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Décrivez le produit en détail...',
                ),
              ),
              SizedBox(height: AppSpacings.xxxl),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Prix ',
                        hintText: '0.00',
                        prefixText: 'fcfa ',
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacings.xxxl),
                  Expanded(
                    child: TextFormField(
                      controller: controller.stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stock initial',
                        hintText: '0',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: controller.categoryController,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  hintText: 'Ex: Vêtements, Électronique',
                ),
              ),
              SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: controller.skuController,
                decoration: const InputDecoration(labelText: 'SKU (Optionnel)'),
              ),
              SizedBox(height: AppSpacings.xxxl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: AppSpacings.xxxl),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.defaultRadius,
                    ),
                  ),
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produit enregistré !')),
                      );
                    }
                  },
                  child: Text(
                    'Enregistrer le Produit',
                    style: AppTypography.titleMedium.apply(
                      color: AppColors.textOnPrimary,
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
    return GestureDetector(
      onTap: () {
        //
      },
      child: Container(
        height: AppSpacings.xxxxl * 5,
        width: AppSpacings.xxxxl * 9,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.greyDark,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: AppRadius.defaultRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.camera,
              size: AppSpacings.xxxxl * 3,
              color: AppColors.greyDark,
            ),
            const SizedBox(height: AppSpacings.xxxl),
            Text('Ajouter une image', style: AppTypography.titleMedium),
          ],
        ),
      ),
    );
  }
}
