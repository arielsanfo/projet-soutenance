import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'management_order_controller.dart';

class ManagementOrderView extends GetView<ManagementOrderController> {
   ManagementOrderView({super.key}){
        Get.lazyPut(() => ManagementOrderView());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Gestion des Commandes', style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: Column(
        children: [
          _buildNavigationTabs(),
          _buildSearchBar(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(AppSpacings.l),
              itemCount: controller.orders
                  .where(
                    (o) => controller.isClientSelected
                        ? o['type'] == 'client'
                        : o['type'] == 'supplier',
                  )
                  .length,
              separatorBuilder: (context, index) => Divider(height: 24),
              itemBuilder: (context, index) {
                final order = controller.orders
                    .where(
                      (o) => controller.isClientSelected
                          ? o['type'] == 'client'
                          : o['type'] == 'supplier',
                    )
                    .toList()[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildNewOrderButton(),
    );
  }

  Widget _buildNavigationTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacings.l,
        vertical: AppSpacings.s,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              // onTap: () => setState(() => controller.isClientSelected = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.isClientSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Commandes Clients (15)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.isClientSelected
                        ? AppColors.primaryColor
                        : AppColors.greyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              // onTap: () => setState(() => controller.isClientSelected = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: !controller.isClientSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Commandes Fournisseurs (4)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !controller.isClientSelected
                        ? AppColors.primaryColor
                        : AppColors.greyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacings.l,
        vertical: AppSpacings.s,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher par ID, client/fournisseur',
          prefixIcon: Icon(Icons.search, color: AppColors.greyMedium),
          filled: true,
          fillColor: AppColors.greyLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacings.l),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppSpacings.l,
            horizontal: AppSpacings.l,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppSpacings.l),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacings.l),
            decoration: BoxDecoration(
              color: order['type'] == 'client'
                  ? AppColors.greyLight
                  : AppColors.greyLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              order['type'] == 'client' ? Icons.person : Icons.local_shipping,
              color: order['type'] == 'client'
                  ? AppColors.primaryColor
                  : AppColors.primaryColor,
            ),
          ),
          SizedBox(width: AppSpacings.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order['id'], style: AppTypography.bodyMedium),
                SizedBox(height: AppSpacings.s),
                Text(
                  '${order['type'] == 'client' ? 'Client: ' : 'Fournisseur: '}${order['name']}',
                  style: AppTypography.bodyMedium.apply(
                    color: AppColors.greyMedium,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  order['date'],
                  style: AppTypography.bodyMedium.apply(
                    color: AppColors.greyMedium,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order['amount'].toStringAsFixed(2)} €',
                style: AppTypography.bodyMedium,
              ),
              SizedBox(height: AppSpacings.s),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.l,
                  vertical: AppSpacings.s,
                ),
                decoration: BoxDecoration(
                  color: order['status'] == 'En préparation'
                      ? AppColors.greyLight
                      : AppColors.greyLight,
                  borderRadius: BorderRadius.circular(AppSpacings.l),
                ),
                child: Text(
                  order['status'],
                  style: AppTypography.bodyMedium.apply(
                    color: order['status'] == 'En préparation'
                        ? AppColors.tagOrangeText
                        : AppColors.tagBlueText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewOrderButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Get.toNamed(Routes.INVENTORY);
        },
        icon: Row(
          children: [
            Icon(
              Icons.add,
              size: AppSpacings.l,
              color: AppColors.textOnPrimary,
            ),
            SizedBox(width: AppSpacings.s),
            Icon(
              Icons.person,
              size: AppSpacings.l,
              color: AppColors.textOnPrimary,
            ),
          ],
        ),
        label: Text(
          'Nouvelle Commande Client',
          style: AppTypography.bodyMedium.apply(color: AppColors.textOnPrimary),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacings.l),
          ),
        ),
      ),
    );
  }
}
