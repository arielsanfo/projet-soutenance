import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import '../../../app/data/storage.dart';
import 'detail_supplier_order_controller.dart';

class DetailSupplierOrderView extends GetView<DetailSupplierOrderController> {
  DetailSupplierOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Obx(() => Text(
              'Commande ${controller.supplierOrder.value?.orderNumber ?? ''}',
          style: AppTypography.titleLarge,
            )),
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          );
        }

        final supplierOrder = controller.supplierOrder.value;
        if (supplierOrder == null) {
          return Center(
            child: Text(
              'Commande non trouvée',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _buildSupplierCard(supplierOrder),
                  SizedBox(height: AppSpacings.l),
                  _buildOrderItemsSection(),
                  SizedBox(height: AppSpacings.l),
                  Divider(
                      height: 2, thickness: 1, color: AppColors.primaryColor),
                  _buildTotalsSection(),
                  SizedBox(height: AppSpacings.l),
                  _buildStatusAndNotesSection(),
                  SizedBox(height: AppSpacings.l),
                ],
              ),
            ),
          ),
            _buildActionButtons(),
        ],
        );
      }),
    );
  }

  Widget _buildSupplierCard(SupplierOrder order) {
    return Container(
        padding: EdgeInsets.all(AppSpacings.l),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Icon(Icons.business, color: AppColors.primaryColor, size: 20),
              SizedBox(width: AppSpacings.s),
            Text(
              'Fournisseur',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.m),
          FutureBuilder<Supplier?>(
            future: Future.value(order.supplierLink.value),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final supplier = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Text(
                      supplier.name ?? 'Nom non spécifié',
              style: AppTypography.titleMedium,
            ),
                    if (supplier.email != null && supplier.email!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: AppSpacings.xs),
                        child: Text(
                          supplier.email!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    if (supplier.phone != null && supplier.phone!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: AppSpacings.xs),
                        child: Text(
                          supplier.phone!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                );
              }
              return Text(
                'Fournisseur non spécifié',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shopping_cart, color: AppColors.primaryColor, size: 20),
            SizedBox(width: AppSpacings.s),
        Text(
          'Articles Commandés',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacings.m),
        Obx(() {
          if (controller.orderItems.isEmpty) {
            return Container(
              padding: EdgeInsets.all(AppSpacings.l),
                  decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyLight),
              ),
              child: Center(
                child: Text(
                  'Aucun article dans cette commande',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: controller.orderItems.map((item) {
              return Container(
                margin: EdgeInsets.only(bottom: AppSpacings.m),
                padding: EdgeInsets.all(AppSpacings.m),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyLight.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: AppColors.primaryColor,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppSpacings.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          FutureBuilder<Product?>(
                            future: Future.value(item.productLink.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Text(
                                  snapshot.data!.name ?? 'Produit non spécifié',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }
                              return Text(
                                'Produit non spécifié',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: AppSpacings.xs),
                      Text(
                            'Qté: ${item.quantityOrdered ?? 0}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                          '${(item.unitCost ?? 0.0).toStringAsFixed(2)} €/unité',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppSpacings.xs),
                    Text(
                          '${(item.totalCost ?? 0.0).toStringAsFixed(2)} €',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildTotalsSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacings.l),
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
      child: Column(
        children: [
          _buildTotalRow('Sous-total:', controller.subtotal),
          SizedBox(height: AppSpacings.s),
          _buildTotalRow('TVA (20%):', controller.vat),
          Divider(height: AppSpacings.m, thickness: 1),
          _buildTotalRow('Total:', controller.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isTotal = false}) {
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
            color: isTotal ? AppColors.primaryColor : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAndNotesSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacings.l),
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
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryColor, size: 20),
              SizedBox(width: AppSpacings.s),
        Text(
          'Statut & Notes',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.m),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.m, vertical: AppSpacings.s),
            decoration: BoxDecoration(
              color: _getStatusColor(controller.orderStatus).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStatusColor(controller.orderStatus).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(controller.orderStatus),
                  color: _getStatusColor(controller.orderStatus),
                  size: 16,
                ),
                SizedBox(width: AppSpacings.s),
                Text(
                  controller.orderStatus,
                  style: AppTypography.bodyMedium.copyWith(
                    color: _getStatusColor(controller.orderStatus),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacings.m),
        TextField(
          controller: controller.notesController,
            decoration: InputDecoration(
              hintText: 'Notes sur la commande...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.greyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
            ),
          maxLines: 3,
        ),
      ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Brouillon':
        return Colors.grey;
      case 'Envoyée':
        return Colors.blue;
      case 'Partiellement reçue':
        return Colors.orange;
      case 'Réceptionnée':
        return Colors.green;
      case 'Annulée':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Brouillon':
        return Icons.edit;
      case 'Envoyée':
        return Icons.send;
      case 'Partiellement reçue':
        return Icons.pending;
      case 'Réceptionnée':
        return Icons.check_circle;
      case 'Annulée':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.check_circle, color: Colors.white, size: 18),
              label: Text(
                'Réceptionner',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.m),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.receiveItems,
            ),
          ),
          SizedBox(width: AppSpacings.m),
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(Icons.edit, color: AppColors.primaryColor, size: 18),
              label: Text(
                'Modifier',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryColor),
                padding: EdgeInsets.symmetric(vertical: AppSpacings.m),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.editOrder,
            ),
          ),
        ],
      ),
    );
  }
}
