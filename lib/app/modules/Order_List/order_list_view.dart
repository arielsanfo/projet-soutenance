import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'order_list_controller.dart';

class OrderListView extends GetView<OrderListController> {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Détails Commande Client #C20240078',
            style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientInfo(),
            SizedBox(height: AppSpacings.l),
            _buildOrderedItems(),
            SizedBox(height: AppSpacings.l),
            _buildTotalSection(),
            SizedBox(height: AppSpacings.l),
            _buildStatusTrackingSection(),
            SizedBox(height: AppSpacings.xl),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Béatrice Martin', style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.s),
        Text('12 Rue de la Paix, 75002 Paris', style: AppTypography.bodyMedium),
        Divider(height: AppSpacings.l),
      ],
    );
  }

  Widget _buildOrderedItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Articles Commandés', style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.l),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.items.length,
          separatorBuilder: (context, index) => SizedBox(height: AppSpacings.l),
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return Row(
              children: [
                Container(
                  width: AppSpacings.s,
                  height: AppSpacings.s,
                  margin: EdgeInsets.only(right: AppSpacings.s),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text('${item['name']} x${item['qty']}',
                      style: AppTypography.bodyMedium),
                ),
                Text('${(item['price'] * item['qty']).toStringAsFixed(2)} €',
                    style: AppTypography.bodyMedium),
              ],
            );
          },
        ),
        Divider(height: AppSpacings.xxl, color: AppColors.greyMedium),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total:', style: AppTypography.titleMedium),
        Text('${controller.totalAmount.toStringAsFixed(2)} €',
            style:
                AppTypography.titleLarge.apply(color: AppColors.primaryColor)),
      ],
    );
  }

  Widget _buildStatusTrackingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statut & Suivi', style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.xl),
        DropdownButtonFormField<String>(
          value: controller.selectedStatus,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacings.xl, vertical: AppSpacings.xxl),
          ),
          items: ['En préparation', 'Envoyée', 'Livrée', 'Annulée']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status, style: AppTypography.titleSmall),
                  ))
              .toList(),
          onChanged: (String? value) {
            //
          },
        ),
        SizedBox(height: AppSpacings.xxl),
        TextFormField(
          controller: controller.trackingController,
          decoration: InputDecoration(
            hintText: 'N° de suivi (si applicable)',
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacings.xl, vertical: AppSpacings.xxl),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(Routes.DETAILS_ORDER);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(double.infinity, AppSpacings.xxl * 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacings.l),
        ),
      ),
      child: Text('Mettre à Jour la Commande',
          style: AppTypography.bodyLarge.apply(color: AppColors.textOnPrimary)),
    );
  }
}
