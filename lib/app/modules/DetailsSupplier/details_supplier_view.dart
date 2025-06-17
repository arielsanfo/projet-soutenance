import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'details_supplier_controller.dart';

class DetailsSupplierView extends GetView<DetailsSupplierController> {
  const DetailsSupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(
          'Détails Cde Fournisseur #F20240012',
          style: AppTypography.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Fournisseur
                  _buildSupplierCard(),
                  SizedBox(height: AppSpacings.l),

                  // Section Articles
                  _buildOrderItemsSection(),
                  SizedBox(height: AppSpacings.l),
                  Divider(
                      height: 2, thickness: 1, color: AppColors.primaryColor),

                  // Section Totaux
                  _buildTotalsSection(context),
                  SizedBox(height: AppSpacings.l),

                  // Section Statut & Notes
                  _buildStatusAndNotesSection(),
                  SizedBox(height: AppSpacings.l),
                ],
              ),
            ),
          ),

          // Boutons d'action
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSupplierCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fournisseur',
              style: AppTypography.titleLarge,
            ),
            SizedBox(height: AppSpacings.s),
            Text(
              'BioFrais Distribution',
              style: AppTypography.titleMedium,
            ),
            SizedBox(height: AppSpacings.s),
            Text(
              'contact@biofrais.com',
              style: AppTypography.bodySmall
                  .apply(color: AppColors.secondaryColor),
            ),
            Text(
              '04 11 22 33 44',
              style: AppTypography.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Articles Commandés',
          style: AppTypography.titleLarge,
        ),
        SizedBox(height: AppSpacings.s),
        ...controller.orderItems.map((item) {
          final total = item['quantity'] * item['unitPrice'];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacings.l),
            child: Row(
              children: [
                // Image de démonstration (remplacer par une vraie image)
                Container(
                  width: AppSpacings.xxxxl * 1.5,
                  height: AppSpacings.xxxxl * 1.5,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: AppRadius.defaultRadius,
                  ),
                  child: Icon(
                    Icons.shopping_basket,
                    color: AppColors.greyLight,
                  ),
                ),
                SizedBox(width: AppSpacings.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: AppTypography.bodyMedium.fontSize,
                        ),
                      ),
                      SizedBox(height: AppSpacings.s),
                      Text(
                        'Qté: ${item['quantity']}',
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item['unitPrice'].toStringAsFixed(2)} €/unité',
                      style: AppTypography.bodyMedium,
                    ),
                    SizedBox(height: AppSpacings.s),
                    Text(
                      '${total.toStringAsFixed(2)} €',
                      style: AppTypography.titleSmall
                          .apply(color: AppColors.tagGreenText),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTotalsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacings.s),
      child: Column(
        children: [
          _buildTotalRow('Sous-total:', controller.subtotal),
          SizedBox(height: AppSpacings.s),
          _buildTotalRow('TVA (20%):', controller.vat),
          SizedBox(height: AppSpacings.s),
          _buildTotalRow(
            'Total:',
            controller.total,
            isTotal: true,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal
                ? AppTypography.titleMedium.fontSize
                : AppTypography.bodyMedium.fontSize,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} €',
          style: TextStyle(
            fontSize: isTotal
                ? AppTypography.titleMedium.fontSize
                : AppTypography.bodyMedium.fontSize,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAndNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statut & Notes',
          style: TextStyle(
            fontSize: AppTypography.titleMedium.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacings.s),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(hintText: 'Statut'),
          value: controller.orderStatus,
          items: [
            DropdownMenuItem(value: 'Brouillon', child: Text('Brouillon')),
            DropdownMenuItem(value: 'Envoyée', child: Text('Envoyée')),
            DropdownMenuItem(value: 'En cours', child: Text('En cours')),
            DropdownMenuItem(
              value: 'Réceptionnée',
              child: Text('Réceptionnée'),
            ),
            DropdownMenuItem(value: 'Annulée', child: Text('Annulée')),
          ],
          onChanged: (value) {
            // setState(() {
            controller.orderStatus = value!;
            // });
          },
        ),
        SizedBox(height: AppSpacings.l),
        TextField(
          controller: controller.notesController,
          decoration: InputDecoration(hintText: 'Notes fournisseur...'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacings.l),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.s),
                ),
              ),
              onPressed: () {
                Get.toNamed(Routes.LIST_SUPPLIER_ORDER);
              },
              child: Text(
                textAlign: TextAlign.center,
                'Réceptionner la Commande',
                style: AppTypography.titleSmall
                    .apply(color: AppColors.textOnPrimary),
              ),
            ),
          ),
          SizedBox(width: AppSpacings.s),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.tagGreenText,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.s),
                ),
              ),
              onPressed: () {
                // Action de modification
              },
              child: Text(
                textAlign: TextAlign.center,
                'Modifier Commande',
                style: AppTypography.titleSmall
                    .apply(color: AppColors.textOnPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
