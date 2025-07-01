import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
// import '../../helpers/app_constante.dart';
import 'details_order_controller.dart';
import '../../data/storage.dart';

class DetailsOrderView extends GetView<DetailsOrderController> {
  DetailsOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Obx(() => Text(
              'Commande #${controller.sale.value?.saleNumber ?? ''}',
              style: AppTypography.titleLarge,
            )),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(AppIcons.receipt, color: AppColors.primaryColor, size: 26),
            tooltip: 'Voir détails commande',
            onPressed: () {
              final sale = controller.sale.value;
              debugPrint('Sale envoyé: ${sale?.id}');
              if (sale != null && sale.id != null) {
                Get.toNamed('/details-order', arguments: sale.id);
              } else {
                AppSnackbars.showInfo('Aucune commande', 'Aucune commande à afficher.');
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        final sale = controller.sale.value;
        final customer = controller.customer.value;
        if (sale == null) {
          return Center(
              child: Text('Commande non trouvée',
                  style: AppTypography.bodyMedium));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Infos client
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: AppColors.primaryColor),
                          SizedBox(width: AppSpacings.s),
                          Text('Client', style: AppTypography.titleMedium),
                        ],
                      ),
                      SizedBox(height: AppSpacings.s),
                      Text(customer?.name ?? 'Client inconnu',
                          style: AppTypography.bodyMedium),
                      if (customer?.address != null &&
                          customer!.address!.isNotEmpty)
                        Text(customer.address!,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.l),
              // Articles
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shopping_cart,
                              color: AppColors.primaryColor),
                          SizedBox(width: AppSpacings.s),
                          Text('Articles commandés',
                              style: AppTypography.titleMedium),
                        ],
                      ),
                      SizedBox(height: AppSpacings.s),
                      ...controller.saleItems
                          .map((item) => FutureBuilder<Product?>(
                                future: item.productLink.value == null
                                    ? null
                                    : Future.value(item.productLink.value),
                                builder: (context, snapshot) {
                                  final name = snapshot.data?.name ?? 'Produit';
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                '$name x${item.quantity}',
                                                style:
                                                    AppTypography.bodyMedium)),
                                        Text(
                                            '${(item.totalPrice ?? 0.0).toStringAsFixed(2)} €',
                                            style: AppTypography.bodyMedium),
                                      ],
                                    ),
                                  );
                                },
                              )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.l),
              // Récapitulatif
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.l),
                  child: Column(
                    children: [
                      _buildPriceRow(
                          'Sous-total',
                          (sale.totalPrice ?? 0.0) -
                              (sale.totalTaxAmount ?? 0.0)),
                      _buildPriceRow('TVA', sale.totalTaxAmount ?? 0.0),
                      Divider(),
                      _buildPriceRow('Total', sale.totalPrice ?? 0.0,
                          isBold: true),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.l),
              // Statut et paiement
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.primaryColor),
                          SizedBox(width: AppSpacings.s),
                          Text('Statut & Paiement',
                              style: AppTypography.titleMedium),
                        ],
                      ),
                      SizedBox(height: AppSpacings.s),
                      Row(
                        children: [
                          _buildStatusChip(sale.status),
                          SizedBox(width: AppSpacings.l),
                          Text('Paiement : ${sale.paymentMethod ?? 'N/A'}',
                              style: AppTypography.bodySmall),
                        ],
                      ),
                      if (sale.notes != null && sale.notes!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: AppSpacings.s),
                          child: Text('Notes : ${sale.notes}',
                              style: AppTypography.bodySmall),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall),
        Text(
          '${amount.toStringAsFixed(2)} €',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.primaryColor : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(SaleStatusIsar? status) {
    String label = 'Inconnu';
    Color color = Colors.grey;
    switch (status) {
      case SaleStatusIsar.completed:
        label = 'Complétée';
        color = Colors.green;
        break;
      case SaleStatusIsar.cancelled:
        label = 'Annulée';
        color = Colors.red;
        break;
      case SaleStatusIsar.refunded:
        label = 'Remboursée';
        color = Colors.orange;
        break;
      default:
        label = 'En cours';
        color = Colors.blueGrey;
    }
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }


}
