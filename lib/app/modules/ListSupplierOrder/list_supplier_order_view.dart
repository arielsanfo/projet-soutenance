import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
// import '../../helpers/app_constante.dart';
import 'list_supplier_order_controller.dart';
import '../../data/storage.dart';

class ListSupplierOrderView extends GetView<ListSupplierOrderController> {
  ListSupplierOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Commandes fournisseurs', style: AppTypography.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.supplierOrders.isEmpty) {
          return Center(
              child: Text('Aucune commande fournisseur trouvée',
                  style: AppTypography.bodyMedium));
        }
        return ListView.separated(
            padding: EdgeInsets.all(AppSpacings.l),
          itemCount: controller.supplierOrders.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacings.m),
          itemBuilder: (context, index) {
            final order = controller.supplierOrders[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                contentPadding: EdgeInsets.all(AppSpacings.l),
                title: Text('Commande #${order.orderNumber ?? order.id}',
                    style: AppTypography.titleMedium),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    FutureBuilder<Supplier?>(
                      future: order.supplierLink.value == null
                          ? null
                          : Future.value(order.supplierLink.value),
                      builder: (context, snapshot) {
                        final name =
                            snapshot.data?.name ?? 'Fournisseur inconnu';
                        return Text(name,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.textSecondary));
                      },
                    ),
                    SizedBox(height: 4),
                    Text(
                        'Date : ${order.orderDate?.toString().split(' ').first ?? ''}',
                        style: AppTypography.bodySmall),
                  ],
                ),
                trailing: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Text('${(order.totalPrice ?? 0.0).toStringAsFixed(2)} €',
                        style: AppTypography.titleSmall
                            .copyWith(color: AppColors.primaryColor)),
                    SizedBox(height: 8),
                    _buildStatusChip(order.status),
                  ],
                ),
                onTap: () => controller.goToDetails(order),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusChip(SupplierOrderStatusIsar? status) {
    String label = 'Inconnu';
    Color color = Colors.grey;
    switch (status) {
      case SupplierOrderStatusIsar.draft:
        label = 'Brouillon';
        color = Colors.grey;
        break;
      case SupplierOrderStatusIsar.sent:
        label = 'Envoyée';
        color = Colors.blue;
        break;
      case SupplierOrderStatusIsar.partiallyReceived:
        label = 'Partielle';
        color = Colors.orange;
        break;
      case SupplierOrderStatusIsar.received:
        label = 'Réceptionnée';
        color = Colors.green;
        break;
      case SupplierOrderStatusIsar.cancelled:
        label = 'Annulée';
        color = Colors.red;
        break;
      default:
        label = 'Inconnu';
        color = Colors.grey;
    }
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }
}
