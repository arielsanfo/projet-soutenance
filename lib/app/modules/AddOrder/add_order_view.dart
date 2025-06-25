import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import '../../data/storage.dart';
// import '../../helpers/app_constante.dart';
import 'add_order_controller.dart';

class AddOrderView extends GetView<AddOrderController> {
  AddOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Nouvelle commande', style: AppTypography.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(AppSpacings.s),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: AppRadius.medium,
            ),
            child: Icon(AppIcons.backArrow, color: AppColors.primaryColor, size: 20),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(AppIcons.receipt, color: AppColors.primaryColor, size: 26),
            tooltip: 'Voir détails commande',
            onPressed: () {
              final sale = controller.currentSale.value;
              if (sale != null) {
                Get.toNamed(Routes.DETAILS_ORDER, arguments: sale.id);
              } else {
                AppSnackbars.showInfo('Aucune commande', 'Aucune commande à afficher.');
              }
            },
          ),
        ],
      ),
      body: Obx(() => Column(
            children: [
              // Sélection du client
              Padding(
                padding: AppSpacings.screenPadding,
                child: Card(
                  elevation: 3,
                  shadowColor: AppColors.primaryColor.withOpacity(0.08),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.rLarge)),
                  child: Padding(
                    padding: AppSpacings.cardPadding,
                    child: DropdownButtonFormField<int>(
                      value: controller.selectedCustomer.value?.id,
                      items: controller.customers
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Row(
                                  children: [
                                    Icon(AppIcons.person, color: AppColors.primaryColor, size: 20),
                                    SizedBox(width: AppSpacings.s),
                                    Text(c.name ?? '', style: AppTypography.bodyMedium),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (id) {
                        final customer = controller.customers.firstWhereOrNull((c) => c.id == id);
                        controller.selectedCustomer.value = customer;
                      },
                      decoration: InputDecoration(
                        labelText: 'Sélectionner un client',
                        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.l, vertical: AppSpacings.m),
                        filled: true,
                        fillColor: AppColors.backgroundInput,
                        prefixIcon: Icon(AppIcons.customers, color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),

              // Panier
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.l, vertical: AppSpacings.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Panier', style: AppTypography.titleLarge),
                    Text('(${controller.cartItems.length} articles)',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => controller.cartItems.isEmpty
                      ? Center(
                          child: Text('Aucun article dans le panier', style: AppTypography.bodyMedium))
                      : ListView.builder(
                          itemCount: controller.cartItems.length,
                          padding: EdgeInsets.only(bottom: AppSpacings.xxl),
                          itemBuilder: (context, index) {
                            final item = controller.cartItems[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: AppSpacings.l, vertical: AppSpacings.s),
                              elevation: 2,
                              shadowColor: AppColors.primaryColor.withOpacity(0.06),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.rLarge)),
                              child: Padding(
                                padding: AppSpacings.cardPadding,
                                child: Row(
                                  children: [
                                    // Nom produit
                                    Expanded(
                                      child: FutureBuilder<Product?>(
                                        future: item.productLink.value == null
                                            ? null
                                            : Future.value(item.productLink.value),
                                        builder: (context, snapshot) {
                                          final name = snapshot.data?.name ?? 'Produit';
                                          return Text(name, style: AppTypography.titleSmall);
                                        },
                                      ),
                                    ),
                                    // Quantité
                                    SizedBox(
                                      width: 60,
                                      child: TextField(
                                        controller: TextEditingController(text: (item.quantity ?? 0).toString()),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                                        ),
                                        onSubmitted: (value) {
                                          final newQuantity = int.tryParse(value) ?? (item.quantity ?? 1);
                                          controller.updateQuantity(index, newQuantity);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: AppSpacings.s),
                                    // Prix total ligne
                                    Text('${(item.totalPrice ?? 0.0).toStringAsFixed(2)} €',
                                        style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryColor)),
                                    IconButton(
                                      icon: Icon(AppIcons.delete, color: AppColors.errorColor),
                                      onPressed: () => controller.removeItem(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),

              // Récapitulatif et validation
              Container(
                padding: AppSpacings.cardPadding,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.rLarge)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyLight.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPriceRow('Sous-total', controller.subtotal),
                    SizedBox(height: AppSpacings.s),
                    _buildPriceRow('TVA (20%)', controller.vat),
                    Divider(),
                    _buildPriceRow('Total', controller.total, isBold: true),
                    SizedBox(height: AppSpacings.m),
                    // Sélection mode de paiement
                    DropdownButtonFormField<String>(
                      value: controller.paymentMethod.value.isNotEmpty ? controller.paymentMethod.value : null,
                      items: [
                        DropdownMenuItem(value: 'Espèces', child: Row(children: [Icon(AppIcons.payment, size: 18), SizedBox(width: 8), Text('Espèces')])) ,
                        DropdownMenuItem(value: 'Carte Bancaire', child: Row(children: [Icon(AppIcons.credit_card, size: 18), SizedBox(width: 8), Text('Carte Bancaire')])) ,
                        DropdownMenuItem(value: 'Mobile Money', child: Row(children: [Icon(AppIcons.payment, size: 18), SizedBox(width: 8), Text('Mobile Money')])) ,
                      ],
                      onChanged: (v) => controller.paymentMethod.value = v ?? '',
                      decoration: InputDecoration(
                        labelText: 'Mode de paiement',
                        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                        filled: true,
                        fillColor: AppColors.backgroundInput,
                        prefixIcon: Icon(AppIcons.payment, color: AppColors.primaryColor),
                      ),
                    ),
                    SizedBox(height: AppSpacings.m),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: controller.isLoading.value
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(color: AppColors.textOnPrimary, strokeWidth: 2))
                            : Icon(AppIcons.success, color: AppColors.textOnPrimary),
                        label: Text('Valider la commande', style: AppTypography.bodyLarge.apply(color: AppColors.textOnPrimary)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.rLarge)),
                          elevation: 0,
                        ),
                        onPressed: controller.isLoading.value ? null : controller.saveOrder,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(AppIcons.add, color: AppColors.textOnPrimary),
        label: Text('Ajouter un produit', style: AppTypography.labelLarge.copyWith(color: AppColors.textOnPrimary)),
        backgroundColor: AppColors.primaryColor,
        onPressed: () => _showAddProductSheet(context),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall),
        Text(
          '${amount.toStringAsFixed(2)} €',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.primaryColor : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showAddProductSheet(BuildContext context) {
    final ctrl = Get.find<AddOrderController>();
    int quantity = 1;
    Product? selectedProduct;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.rLarge)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacings.l,
            right: AppSpacings.l,
            top: AppSpacings.xl,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacings.xl,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ajouter un produit', style: AppTypography.titleMedium),
                  SizedBox(height: AppSpacings.l),
                  DropdownButtonFormField<int>(
                    value: selectedProduct?.id,
                    items: ctrl.products
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name ?? '', style: AppTypography.bodyMedium),
                            ))
                        .toList(),
                    onChanged: (id) {
                      setState(() => selectedProduct = ctrl.products.firstWhereOrNull((p) => p.id == id));
                    },
                    decoration: InputDecoration(
                      labelText: 'Produit',
                      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                      filled: true,
                      fillColor: AppColors.backgroundInput,
                      prefixIcon: Icon(AppIcons.products, color: AppColors.primaryColor),
                    ),
                  ),
                  SizedBox(height: AppSpacings.l),
                  Row(
                    children: [
                      Text('Quantité', style: AppTypography.bodyMedium),
                      SizedBox(width: AppSpacings.l),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rDefault)),
                            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),
                          onChanged: (v) => quantity = int.tryParse(v) ?? 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: selectedProduct == null || quantity < 1
                          ? null
                          : () {
                              ctrl.addProductToCart(selectedProduct!, quantity);
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.rLarge)),
                        elevation: 0,
                      ),
                      icon: Icon(AppIcons.add, color: AppColors.textOnPrimary),
                      label: Text('Ajouter au panier', style: AppTypography.bodyLarge.apply(color: AppColors.textOnPrimary)),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

