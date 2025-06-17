import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails: Pommes Gala Bio'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Image du produit
          Container(
            height: AppSpacings.xxxxl * 4.5,
            width: double.infinity,
            color: AppColors.greyMedium,
            alignment: Alignment.center,
            child: Icon(AppIcons.image,
                size: AppSpacings.xxxl * 2, color: AppColors.greyDark),
          ),

          // Contenu défilable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et UGS
                  Text(
                    'Pommes Gala Bio',
                    style: AppTypography.titleLarge,
                  ),
                  SizedBox(height: AppSpacings.l),
                  Text(
                    'UGS: FRT-PGB-001',
                    style: AppTypography.titleSmall,
                  ),
                  SizedBox(height: AppSpacings.l),

                  // Badge de stock
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.l, vertical: AppSpacings.s),
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'En Stock',
                      style: AppTypography.titleSmall
                          .apply(color: AppColors.tagGreenText),
                    ),
                  ),
                  SizedBox(height: AppSpacings.xxxl),

                  // Description
                  Text(
                    'Description',
                    style: AppTypography.titleMedium,
                  ),
                  SizedBox(height: AppSpacings.l),
                  Text(
                    'Délicieuses pommes Gala issues de l\'agriculture biologique, parfaites pour une collation saine.',
                    style: TextStyle(fontSize: AppSpacings.l),
                  ),
                  SizedBox(height: AppSpacings.xxl),

                  // Prix et quantité (Row)
                  Row(
                    children: [
                      // Prix
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Prix de vente',
                          value: '2.99 €',
                          subtitle: '/kg',
                        ),
                      ),
                      SizedBox(width: AppSpacings.l),

                      Expanded(
                        child: _buildInfoCard(
                          title: 'Quantité',
                          value: '56',
                          subtitle: 'unités',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.l),

                  // Catégorie
                  _buildInfoCard(
                    title: 'Catégorie',
                    value: 'Fruits',
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),

          // Barre d'actions
          Container(
            padding: EdgeInsets.all(AppSpacings.l),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: AppColors.greyMedium,
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                // Bouton Modifier
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.ADD_PRODUCT);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tagGreenText,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.defaultRadius,
                      ),
                    ),
                    icon: Icon(AppIcons.edit),
                    label: Text('Modifier'),
                  ),
                ),
                SizedBox(width: AppSpacings.l),

                // Bouton Supprimer
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action de suppression
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.defaultRadius),
                    ),
                    icon: Icon(AppIcons.delete),
                    label: Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    String? subtitle,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: AppRadius.defaultRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight,
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleSmall,
          ),
          SizedBox(height: AppSpacings.s),
          Text(
            value,
            style: AppTypography.titleMedium,
          ),
          if (subtitle != null) ...[
            SizedBox(height: AppSpacings.s),
            Text(
              subtitle,
              style: AppTypography.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
