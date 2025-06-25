import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'newsale_controller.dart';

class NewsaleView extends GetView<NewsaleController> {
  NewsaleView({super.key}) {
        Get.lazyPut(() => NewsaleView());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacings.xxl),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: AppSpacings.xxl),
                Text('Chargement...', style: AppTypography.titleMedium),
              ],
            ),
          );
        }
        return Column(
          children: [
            // Header moderne
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(AppSpacings.l, 60, AppSpacings.l, AppSpacings.xxl),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacings.m),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.primaryDarker],
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Icon(AppIcons.newSale, color: AppColors.textOnPrimary, size: 28),
                  ),
                  SizedBox(width: AppSpacings.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nouvelle Vente', style: AppTypography.titleLarge),
                        SizedBox(height: AppSpacings.xs),
                        Text('Enregistrez une nouvelle vente',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(AppIcons.close, color: AppColors.textLight, size: 24),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacings.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sélection du client
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
                      child: Padding(
                        padding: AppSpacings.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Client', style: AppTypography.titleMedium),
                            SizedBox(height: AppSpacings.s),
                            DropdownButtonFormField(
                              value: controller.selectedCustomer.value,
                              items: controller.customers
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c.name ?? 'Sans nom', style: AppTypography.bodyMedium),
                                      ))
                                  .toList(),
                              onChanged: (value) => controller.selectedCustomer.value = value,
                              decoration: InputDecoration(
                                hintText: 'Sélectionner un client',
                                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                                filled: true,
                                fillColor: AppColors.backgroundInput,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacings.l),
                    // Ajout de produit
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
                      child: Padding(
                        padding: AppSpacings.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ajouter un produit', style: AppTypography.titleMedium),
                            SizedBox(height: AppSpacings.s),
                            DropdownButtonFormField(
                              items: controller.products
                                  .map((p) => DropdownMenuItem(
                                        value: p,
                                        child: Text('${p.name} - ${(p.salePrice ?? 0).toStringAsFixed(2)} f', style: AppTypography.bodyMedium),
                                      ))
                                  .toList(),
                              onChanged: (product) {
                                if (product != null) controller.addProductToCart(product);
                              },
                              decoration: InputDecoration(
                                hintText: 'Sélectionner un produit',
                                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                                filled: true,
                                fillColor: AppColors.backgroundInput,
                              ),
                            ),
                            SizedBox(height: AppSpacings.m),
                            Text('Articles', style: AppTypography.titleLarge),
                            SizedBox(height: AppSpacings.s),
                            if (controller.cart.isEmpty)
                              Text('Aucun article dans le panier.', style: AppTypography.bodyMedium),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.cart.length,
                              separatorBuilder: (context, index) => Divider(height: AppSpacings.l),
                              itemBuilder: (context, index) {
                                final item = controller.cart[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundWhite,
                                    borderRadius: AppRadius.defaultRadius,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppSpacings.m, horizontal: AppSpacings.l),
                                    title: Text(item.product.name ?? '',
                                        style: AppTypography.bodyLarge,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    subtitle: Text(
                                        '${item.product.salePrice?.toStringAsFixed(2) ?? '0.00'} f',
                                        style: AppTypography.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    leading: Icon(AppIcons.cart, color: AppColors.primaryColor),
                                    trailing: SizedBox(
                                      width: 120,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove, color: AppColors.textLight),
                                            onPressed: () {
                                              if (item.quantity > 1) {
                                                controller.updateQuantity(item.product, item.quantity - 1);
                                              } else {
                                                controller.removeProductFromCart(item.product);
                                              }
                                            },
                                          ),
                                          Flexible(
                                              child: Text('${item.quantity}', style: AppTypography.bodyLarge)),
                                          IconButton(
                                            icon: Icon(AppIcons.add, color: AppColors.primaryColor),
                                            onPressed: () => controller.updateQuantity(item.product, item.quantity + 1),
                                          ),
                                          IconButton(
                                            icon: Icon(AppIcons.delete, color: AppColors.errorColor),
                                            onPressed: () => controller.removeProductFromCart(item.product),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacings.l),
                    // Paiement et remise
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
                      child: Padding(
                        padding: AppSpacings.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mode de paiement', style: AppTypography.titleMedium),
                            SizedBox(height: AppSpacings.s),
                            DropdownButtonFormField<String>(
                              value: controller.paymentMethod.value.isEmpty ? null : controller.paymentMethod.value,
                              items: const [
                                DropdownMenuItem(value: 'Espèces', child: Text('Espèces')),
                                DropdownMenuItem(value: 'Carte Bancaire', child: Text('Carte Bancaire')),
                                DropdownMenuItem(value: 'Mobile Money', child: Text('Mobile Money')),
                              ],
                              onChanged: (value) => controller.paymentMethod.value = value ?? '',
                              decoration: InputDecoration(
                                hintText: 'Sélectionner un mode de paiement',
                                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                                filled: true,
                                fillColor: AppColors.backgroundInput,
                              ),
                            ),
                            SizedBox(height: AppSpacings.m),
                            Row(
                              children: [
                                Text('Remise : ', style: AppTypography.bodyLarge),
                                SizedBox(width: AppSpacings.s),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: controller.discount.value.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '0.0',
                                      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                                      filled: true,
                                      fillColor: AppColors.backgroundInput,
                                    ),
                                    onChanged: (val) {
                                      final d = double.tryParse(val) ?? 0.0;
                                      controller.discount.value = d;
                                    },
                                  ),
                                ),
                                Text('f', style: AppTypography.bodyLarge),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacings.l),
                    // Total à payer
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
                      child: Padding(
                        padding: AppSpacings.cardPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total à payer :', style: AppTypography.titleLarge),
                            Obx(() => Text(
                                  '${controller.total.toStringAsFixed(2)} f',
                                  style: AppTypography.titleLarge.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bouton principal
            Container(
              padding: AppSpacings.screenPadding,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.processSale,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppSpacings.xl),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
                  elevation: 2,
                ),
                icon: Icon(AppIcons.success),
                label: Text('Valider la vente', style: AppTypography.titleLarge),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class SaleItem {
  final String name;
  final String quantity;
  final double price;

  SaleItem({required this.name, required this.quantity, required this.price});
}
