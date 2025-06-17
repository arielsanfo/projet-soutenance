import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'add_order_controller.dart';

class AddOrderView extends GetView<AddOrderController> {
  const AddOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Nouvelle vente '),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Section Panier
          Padding(
            padding: EdgeInsets.all(AppSpacings.xl),
            child: Text(
              'Panier (${controller.cartItems.length} articles)',
              style: AppTypography.titleLarge
                  .apply(color: AppColors.secondaryColor),
            ),
          ),

          // Liste des articles
          Expanded(
            child: ListView.builder(
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];
                return _buildCartItem(item, index);
              },
            ),
          ),

          // Récapitulatif des prix
          Container(
            padding: EdgeInsets.all(AppSpacings.xxxl),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: AppRadius.defaultRadius,
              // borderRadius:  BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    // ignore: deprecated_member_use
                    color: AppColors.greyMedium,
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(1, 2)),
              ],
            ),
            child: Column(
              children: [
                _buildPriceRow('Sous-total:', controller.subtotal),
                SizedBox(height: AppSpacings.l),
                _buildPriceRow('TVA (20%):', controller.vat),
                SizedBox(height: AppSpacings.l),
                _buildPriceRow('Total:', controller.total, isBold: true),
                SizedBox(height: AppSpacings.l),

                // Bouton de paiement
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.ORDER_LIST);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.xl),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.defaultRadius,
                      ),
                    ),
                    icon: Icon(AppIcons.credit_card,
                        color: AppColors.textOnPrimary),
                    label: Text(
                      'Procéder au Paiement',
                      style: AppTypography.titleSmall
                          .apply(color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: AppSpacings.m, vertical: AppSpacings.m),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.m),
        child: Row(
          children: [
            // Indicateur visuel
            Container(
              width: AppSpacings.xxxxl,
              height: AppSpacings.xxxl,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: AppRadius.defaultRadius,
              ),
              child: Text(
                item.id,
                style: AppTypography.bodyLarge
                    .apply(color: AppColors.backgroundInput),
              ),
            ),
            SizedBox(width: AppSpacings.l),

            // Détails de l'article
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.titleSmall,
                  ),
                  SizedBox(height: AppSpacings.m),
                  Text(
                      '${item.price} € x ${item.quantity} = ${(item.price * item.quantity).toStringAsFixed(2)} €',
                      style: AppTypography.bodySmall
                          .apply(color: AppColors.greyDark)),
                ],
              ),
            ),

            // Contrôle de quantité
            SizedBox(
              width: AppSpacings.xxxxl * 2,
              child: TextField(
                controller:
                    TextEditingController(text: item.quantity.toString()),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacings.s),
                ),
                onSubmitted: (value) {
                  final newQuantity = int.tryParse(value) ?? item.quantity;
                  controller.updateQuantity(index, newQuantity);
                },
              ),
            ),
            SizedBox(width: AppSpacings.s),

            // Bouton de suppression
            IconButton(
              icon: Icon(AppIcons.close, color: AppColors.errorColor),
              onPressed: () => controller.removeItem(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.titleSmall,
        ),
        Text(
          '${amount.toStringAsFixed(2)} fcfa',
          style: TextStyle(
            fontSize: AppSpacings.l,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.primaryColor : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
