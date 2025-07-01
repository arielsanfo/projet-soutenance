import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'prise_inventory_controller.dart';

class PriseInventoryView extends GetView<PriseInventoryController> {
   PriseInventoryView({super.key}){
        Get.lazyPut(()=>PriseInventoryView());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Prise d\'Inventaire', style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product 1 - No discrepancy
            Container(
              padding: EdgeInsets.all(AppSpacings.xxl),
              margin: EdgeInsets.only(bottom: AppSpacings.xxl),
              decoration: BoxDecoration(
                color: AppColors.backgroundInput,
                borderRadius: AppRadius.defaultRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyLight,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Produit: Clous 20mm', style: AppTypography.bodyLarge),
                  SizedBox(height: AppSpacings.xl),
                  Text(
                    'Stock Théorique: 56 unités',
                    style: AppTypography.titleMedium,
                  ),
                  SizedBox(height: AppSpacings.xl),
                  TextField(
                    controller: controller.product1Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // labelText: 'Stock Physique Compté',
                      hintText: '56',
                      filled: true,
                      fillColor: AppColors.greyLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacings.s),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.xxl,
                        vertical: AppSpacings.xl,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.l),
                  Text(
                    'Aucun écart pour ce produit.',
                    style: AppTypography.titleSmall.apply(
                      color: AppColors.tagGreenText,
                    ),
                  ),
                ],
              ),
            ),

            // Product 2 - With discrepancy
            Container(
              padding: EdgeInsets.all(AppSpacings.l),
              margin: EdgeInsets.only(bottom: AppSpacings.l),
              decoration: BoxDecoration(
                color: AppColors.backgroundInput,
                borderRadius: AppRadius.defaultRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyLight,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produit: Farine T55',
                    style: AppTypography.bodyLarge,
                  ),
                  SizedBox(height: AppSpacings.l),
                  Text(
                    'Stock Théorique: 20 kg',
                    style: AppTypography.titleMedium,
                  ),
                  SizedBox(height: AppSpacings.l),
                  TextField(
                    controller: controller.product2Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '20',
                      filled: true,
                      fillColor: AppColors.greyLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacings.s),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.xxl,
                        vertical: AppSpacings.xl,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacings.l),
                  Text(
                    'Écart: -2 kg. Raison ?',
                    style: AppTypography.bodyMedium
                        .apply(color: AppColors.tagBlueText),
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: controller.selectedReason,
                    decoration: InputDecoration(
                      labelText: 'Raison de l\'écart',
                      hintText: 'Choisir ',
                      // filled: true,
                      fillColor: AppColors.greyLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacings.s),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.xl,
                        vertical: AppSpacings.xl,
                      ),
                      // suf.arrow_drop_down),
                    ),
                    items: controller.reasons.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // setState(() {
                      controller.selectedReason = newValue;
                      // });
                    },
                  ),
                ],
              ),
            ),

            // Spacer to prevent buttons from covering content
            SizedBox(height: AppSpacings.xxxxl),
          ],
        ),
      ),

      // Bottom action buttons
      bottomSheet: Container(
        color: AppColors.greyLight,
        padding: EdgeInsets.all(AppSpacings.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.INVENTORY);
                  //
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppSpacings.s),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.s),
                  ),
                ),
                child: Text(
                  'Valider et Suivant',
                  style: AppTypography.titleMedium
                      .apply(color: AppColors.textOnPrimary),
                ),
              ),
            ),
            SizedBox(height: AppSpacings.m),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.FINAL_INVENTORY);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tagGreenText,
                  // foregroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: AppSpacings.s),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.s),
                  ),
                ),
                child: Text(
                  'Finaliser l\'Inventaire',
                  style: AppTypography.titleMedium
                      .apply(color: AppColors.textOnPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
