import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
// import '../../helpers/app_constante.dart';
import 'order_list_controller.dart';
import '../../data/storage.dart';

class OrderListView extends GetView<OrderListController> {
  OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Commandes clients', style: AppTypography.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.sales.isEmpty) {
          return Center(
              child: Text('Aucune commande trouvée',
                  style: AppTypography.bodyMedium));
        }
        return ListView.separated(
          padding: EdgeInsets.all(AppSpacings.l),
          itemCount: controller.sales.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacings.m),
          itemBuilder: (context, index) {
            final sale = controller.sales[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                contentPadding: EdgeInsets.all(AppSpacings.l),
                title: Text('Vente #${sale.saleNumber ?? sale.id}',
                    style: AppTypography.titleMedium),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    SizedBox(height: 4),
                    FutureBuilder<Customer?>(
                      future: sale.customerLink.value == null
                          ? null
                          : Future.value(sale.customerLink.value),
                      builder: (context, snapshot) {
                        final name = snapshot.data?.name ?? 'Client inconnu';
                        return Text(name,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.textSecondary));
                      },
                    ),
                    SizedBox(height: 4),
                    Text(
                        'Date : ${sale.saleDate?.toString().split(' ').first ?? ''}',
                        style: AppTypography.bodySmall),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${(sale.totalPrice ?? 0.0).toStringAsFixed(2)} €',
                        style: AppTypography.titleSmall
                            .copyWith(color: AppColors.primaryColor)),
                    SizedBox(height: 8),
                    _buildStatusChip(sale.status),
                  ],
                ),
                onTap: () => controller.goToDetails(sale),
              ),
            );
          },
        );
      }),
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
