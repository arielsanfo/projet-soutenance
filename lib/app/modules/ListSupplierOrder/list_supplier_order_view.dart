import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'list_supplier_order_controller.dart';

class ListSupplierOrderView extends GetView<ListSupplierOrderController> {
  const ListSupplierOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Fiche Fournisseur', style: AppTypography.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: Column(
        children: [
          // Section Informations Générales
          Padding(
            padding: EdgeInsets.all(AppSpacings.l),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryColor,
                  child: Text('BF',
                      style: AppTypography.titleLarge
                          .apply(color: AppColors.textOnPrimary)),
                ),
                SizedBox(width: AppSpacings.l),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BioFrais Distribution',
                      style: AppTypography.titleMedium,
                    ),
                    SizedBox(height: AppSpacings.s),
                    Text(
                      'contact@biofrais.com',
                      style: AppTypography.bodyMedium.apply(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    SizedBox(height: AppSpacings.s),
                    Text(
                      '04 11 22 33 44',
                      style: AppTypography.bodyMedium.apply(
                        color: AppColors.greyDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Barre de Navigation Secondaire
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.greyLight)),
            ),
            child: Row(
              children: [
                _buildTab('Détails', 0),
                _buildTab('Produits (25)', 1),
                _buildTab('Commandes (8)', 2),
              ],
            ),
          ),

          // Contenu Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                children: [
                  _buildInfoCard(
                    title: 'Adresse',
                    content: 'Zone Agroparc, 84000 Avignon',
                  ),
                  SizedBox(height: AppSpacings.l),
                  _buildInfoCard(
                    title: 'Contact Principal',
                    content: 'Mme. Sophie Bernard\nResponsable Commerciale',
                  ),
                  SizedBox(height: AppSpacings.l),
                  _buildInfoCard(
                    title: 'Conditions de paiement',
                    content: 'Net 30 jours',
                  ),
                ],
              ),
            ),
          ),

          // Bouton Action Principal
          Container(
            padding: EdgeInsets.all(AppSpacings.l),
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.shopping_cart, color: AppColors.textOnPrimary),
              label: Text(
                'Nouvelle Commande',
                style: AppTypography.bodyLarge.apply(
                  color: AppColors.textOnPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.l),
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = index == controller.selectedTabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.DETAILS_SUPPLIER);
        },
        //  setState(() => controller.selectedTabIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.primaryColor : AppColors.greyMedium,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Card(
      color: AppColors.greyLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacings.l),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.xxxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.bodyMedium.apply(
                color: AppColors.greyMedium,
              ),
            ),
            SizedBox(height: AppSpacings.l),
            Text(content, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
