import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'tracking_order_controller.dart';

class TrackingOrderView extends GetView<TrackingOrderController> {
 TrackingOrderView({super.key}){
    Get.lazyPut(()=>TrackingOrderView());
  }
  @override
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
              backgroundColor: AppColors.backgroundWhite,

        title: Text('Suivi Commande Fournisseur'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Informations Générales
            _buildOrderStatusCard(),
            SizedBox(height: AppSpacings.l),

            // Section Articles
            _buildOrderItemsSection(),
            SizedBox(height: AppSpacings.l),

            // Section Total
            _buildTotalSection(),
            SizedBox(height: AppSpacings.l),

            // Section Actions
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.s,
                vertical: AppSpacings.s,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Envoyée',
              style: AppTypography.titleSmall.apply(color: AppColors.greyLight),
              ),
            ),
            SizedBox(height: AppSpacings.xs),
            Text(
              'Fournisseur: BioFrais Distribution',
        style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppSpacings.s),
            Text(
              'Date commande: 03 Mai 2024 | Livraison estimée: 08 Mai 2024',
                    style: AppTypography.bodyMedium,

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
          'Articles',
            style: AppTypography.titleLarge,

        ),
        SizedBox(height: AppSpacings.s),
        ...controller.orderItems.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacings.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['name'],
        style: AppTypography.bodyMedium,
                ),
                Text(
                  'Qté: ${item['quantity']}',
        style: AppTypography.bodyMedium.apply(color: AppColors.secondaryColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Estimé:',
          style: TextStyle(
            fontSize: AppTypography.titleMedium.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${controller.total.toStringAsFixed(2)} €',
                 style: AppTypography.titleLarge.apply(color: AppColors.primaryColor),

        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
               style: AppTypography.titleLarge,

        ),
        SizedBox(height: AppSpacings.xl),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacings.s),
              ),
              side: BorderSide(color: AppColors.greyLight),
            ),
            onPressed: () {
              _showPartialReceptionDialog("");
            },
            child: Text(
              'Marquer comme Reçue Partiellement',
        style: AppTypography.bodyMedium.apply(color: AppColors.textOnPrimary),
            ),
          ),
        ),
        SizedBox(height: AppSpacings.s),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacings.s),
              ),
            ),
            onPressed: () {
              _showCompleteReceptionDialog("");
            },
            child: Text(
              'Marquer comme Reçue Totalement',
              style: TextStyle(color: AppColors.textOnPrimary),
            ),
          ),
        ),
        SizedBox(height: AppSpacings.s),
        Center(
          child: TextButton(
            onPressed: () {
              _showProblemReportDialog("");
            },
            child: Text(
              'Signaler un problème',
              
              style: TextStyle(decoration: AppTypography.bodyMedium.decoration,color: AppColors.tagRedText),
            ),
          ),
        ),
      ],
    );
  }

  void _showPartialReceptionDialog(dynamic context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Réception partielle'),
            content: Text(
              'Voulez-vous marquer cette commande comme partiellement reçue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Commande marquée comme partiellement reçue',
                      ),
                    ),
                  );
                },
                child: Text('Confirmer'),
              ),
            ],
          ),
    );
  }

  void _showCompleteReceptionDialog(dynamic context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Réception complète'),
            content: Text(
              'Voulez-vous marquer cette commande comme totalement reçue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Commande marquée comme totalement reçue'),
                    ),
                  );
                },
                child: Text('Confirmer'),
              ),
            ],
          ),
    );
  }

  void _showProblemReportDialog(dynamic context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Signaler un problème'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Décrivez le problème rencontré...',
              ),
              maxLines: 5,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Problème signalé avec succès')),
                  );
                },
                child: Text('Envoyer'),
              ),
            ],
          ),
    );
  }
}
