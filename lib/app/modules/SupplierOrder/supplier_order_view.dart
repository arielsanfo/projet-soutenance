import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'supplier_order_controller.dart';

class SupplierOrderView extends GetView<SupplierOrderController> {
   SupplierOrderView({super.key}){
    Get.lazyPut(()=>SupplierOrderView());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        title: Text('Nouvelle Cde Fournisseur'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Sélection du Fournisseur
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'Choisir un fournisseur'),
              value: controller.selectedSupplier,
              items: [
                DropdownMenuItem(
                  value: 'Fournisseur 1',
                  child: Text('Fournisseur 1'),
                ),
                DropdownMenuItem(
                  value: 'Fournisseur 2',
                  child: Text('Fournisseur 2'),
                ),
                DropdownMenuItem(
                  value: 'Fournisseur 3',
                  child: Text('Fournisseur 3'),
                ),
              ],
              onChanged: (value) {
                // setState(() {
                //   controller.selectedSupplier = value;
                // });
              },
            ),

            SizedBox(height: AppSpacings.s),

            // Section Référence Interne
            TextField(
              controller: controller.internalRefController,
              decoration: InputDecoration(
                hintText: 'Référence interne (optionnel)',
              ),
            ),

            SizedBox(height: AppSpacings.l),

            // Section Ajouter des Produits
            Text('Ajouter des Produits', style: AppTypography.titleMedium),

            SizedBox(height: AppSpacings.s),

            // Champ Choisir produit
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'Choisir produit'),
              value: controller.selectedProduct,
              items: [
                DropdownMenuItem(
                  value: 'Huile d\'Olive Bio',
                  child: Text('Huile d\'Olive Bio '),
                ),
                DropdownMenuItem(
                  value: 'Pâtes Complètes',
                  child: Text('Pâtes Complètes '),
                ),
                DropdownMenuItem(
                  value: 'Riz Basmati',
                  child: Text('Riz Basmati'),
                ),
              ],
              onChanged: (value) {
                // setState(() {
                //   controller.selectedProduct = value;
                // });
              },
            ),

            SizedBox(height: AppSpacings.s),

            // Champ Quantité
            TextField(
              decoration: InputDecoration(hintText: 'Qté'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // setState(() {
                //   controller.quantity = value;
                // });
              },
            ),

            SizedBox(height: AppSpacings.s),

            // Bouton d'ajout de produit
            ElevatedButton(
              onPressed: () {
                if (controller.selectedProduct != null &&
                    controller.quantity.isNotEmpty) {
                  // setState(() {
                  //   controller.products.add({
                  //     'name': controller.selectedProduct!,
                  //     'quantity': controller.quantity,
                  //   });
                  //   controller.selectedProduct = null;
                  //   controller.quantity = '';
                  // });
                }
              },
              child: Container(
                height: AppSpacings.xxl * 2,
                alignment: Alignment.center,
                child: Icon(AppIcons.add, color: AppColors.primaryColor),
              ),
            ),

            SizedBox(height: AppSpacings.l),

            // Liste des Produits Ajoutés
            if (controller.products.isNotEmpty) ...[
              ...controller.products.map(
                (product) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacings.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product['name'], style: AppTypography.bodyMedium),
                      Text('Qté: ${product['quantity']}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.s),
            ],

            // Section Notes pour le Fournisseur
            TextField(
              controller: controller.notesController,
              decoration: InputDecoration(
                hintText: 'Notes pour le fournisseur...',
                contentPadding: EdgeInsets.all(AppSpacings.l),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            SizedBox(height: AppSpacings.l),

            // Bouton d'Envoi de la Commande
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LIST_SUPPLIER_ORDER);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.s),
                ),
              ),
              child: Text(
                'Envoyer la Commande',
                style: AppTypography.titleMedium
                    .apply(color: AppColors.textOnPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
