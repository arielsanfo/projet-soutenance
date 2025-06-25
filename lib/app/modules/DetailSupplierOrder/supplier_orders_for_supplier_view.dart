import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'supplier_orders_for_supplier_controller.dart';
import '../../../helpers/app_constante.dart';

class SupplierOrdersForSupplierView
    extends GetView<SupplierOrdersForSupplierController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commandes livrées'),
        backgroundColor: AppColors.backgroundWhite,
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundLight,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.orders.isEmpty) {
          return Center(
              child: Text('Aucune commande livrée pour ce fournisseur.'));
        }
        return ListView.separated(
          padding: EdgeInsets.all(AppSpacings.l),
          itemCount: controller.orders.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacings.l),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return Card(
              child: ListTile(
                title: Text('Commande #${order.orderNumber}'),
                subtitle: Text(
                    'Date: ${order.orderDate?.toString().split(' ').first ?? ''}'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.toNamed('/detail-supplier-order', arguments: order);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
