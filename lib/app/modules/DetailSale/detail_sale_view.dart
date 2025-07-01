import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../data/storage.dart';
import '../../../helpers/app_constante.dart';
import 'detail_sale_controller.dart';

class DetailSaleView extends GetView<DetailSaleController> {
  const DetailSaleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détail de la vente',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(AppSpacings.s),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: AppRadius.medium,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              AppIcons.backArrow,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacings.xl),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: AppRadius.max,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(height: AppSpacings.l),
                Text(
                  'Chargement...',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        final sale = controller.sale.value;
        if (sale == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacings.xxl),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: AppRadius.max,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    AppIcons.error,
                    size: 48,
                    color: AppColors.errorColor,
                  ),
                ),
                const SizedBox(height: AppSpacings.l),
                Text(
                  'Vente introuvable',
                  style: AppTypography.headline2.copyWith(
                    color: AppColors.errorColor,
                  ),
                ),
                const SizedBox(height: AppSpacings.s),
                Text(
                  'La vente demandée n\'existe pas ou a été supprimée.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: AppSpacings.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec numéro de vente
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacings.xxl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryDarker,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.max,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacings.m),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: AppRadius.medium,
                          ),
                          child: Icon(
                            AppIcons.receipt,
                            color: AppColors.textOnPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacings.l),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vente #${sale.saleNumber ?? '-'}',
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacings.xs),
                              Text(
                                'Détails de la transaction',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textOnPrimary.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacings.xxl),
              
              // Infos générales
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacings.xxl),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: AppRadius.max,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacings.m),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: AppRadius.medium,
                          ),
                          child: Icon(
                            AppIcons.info,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacings.m),
                        Text(
                          'Informations générales',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacings.xl),
                    
                    // Date de vente
                    _buildInfoRow(
                      icon: AppIcons.calendar,
                      label: 'Date de vente',
                      value: sale.saleDate != null
                          ? sale.saleDate!.toLocal().toString().split(" ")[0]
                          : "-",
                    ),
                    
                    // Client
                    if (sale.customerLink.value?.name != null)
                      _buildInfoRow(
                        icon: AppIcons.person,
                        label: 'Client',
                        value: sale.customerLink.value!.name!,
                      ),
                    
                    // Méthode de paiement
                    if (sale.paymentMethod != null)
                      _buildInfoRow(
                        icon: AppIcons.payment,
                        label: 'Méthode de paiement',
                        value: sale.paymentMethod!,
                      ),
                    
                    // Validé par
                    if (sale.processedByLink.value?.name != null)
                      _buildInfoRow(
                        icon: AppIcons.userShield,
                        label: 'Validé par',
                        value: sale.processedByLink.value!.name!,
                      ),
                    
                    // Notes
                    if (sale.notes != null && sale.notes!.isNotEmpty)
                      _buildInfoRow(
                        icon: AppIcons.info,
                        label: 'Notes',
                        value: sale.notes!,
                        isMultiline: true,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacings.xxl),
              
              // Articles
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacings.xxl),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: AppRadius.max,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacings.m),
                          decoration: BoxDecoration(
                            color: AppColors.accentColor.withOpacity(0.1),
                            borderRadius: AppRadius.medium,
                          ),
                          child: Icon(
                            AppIcons.cart,
                            color: AppColors.accentColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacings.m),
                        Text(
                          'Articles (${sale.saleItems.length})',
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacings.xl),
                    
                    if (sale.saleItems.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(AppSpacings.xxxl),
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: AppRadius.large,
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              AppIcons.cart,
                              size: 48,
                              color: AppColors.greyMedium,
                            ),
                            const SizedBox(height: AppSpacings.l),
                            Text(
                              'Aucun article',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacings.s),
                            Text(
                              'Cette vente ne contient aucun article.',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    
                    ...sale.saleItems.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: AppSpacings.m),
                      padding: const EdgeInsets.all(AppSpacings.l),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: AppRadius.large,
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacings.s),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: AppRadius.small,
                            ),
                            child: Icon(
                              AppIcons.packageIcon,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacings.l),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productLink.value?.name ?? 'Produit',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: AppTypography.fontWeightSemiBold,
                                  ),
                                ),
                                const SizedBox(height: AppSpacings.xs),
                                Text(
                                  '${item.quantity} x ${(item.unitPriceAtSale ?? 0).toStringAsFixed(2)} f',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacings.m,
                              vertical: AppSpacings.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(AppRadius.rCircular),
                            ),
                            child: Text(
                              '${item.totalPrice?.toStringAsFixed(2) ?? '0.00'} f',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: AppTypography.fontWeightSemiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacings.xxl),
              
              // Totaux
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacings.xxl),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: AppRadius.max,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacings.m),
                          decoration: BoxDecoration(
                            color: AppColors.warningColor.withOpacity(0.1),
                            borderRadius: AppRadius.medium,
                          ),
                          child: Icon(
                            AppIcons.chart,
                            color: AppColors.warningColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacings.m),
                        Text(
                          'Récapitulatif',
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacings.xl),
                    
                    Container(
                      padding: const EdgeInsets.all(AppSpacings.l),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(AppRadius.rLarge),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${sale.totalPrice?.toStringAsFixed(2) ?? '0.00'} f',
                                style: AppTypography.headline2.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: AppTypography.fontWeightBold,
                                ),
                              ),
                            ],
                          ),
                          if (sale.discountAmount != null && sale.discountAmount! > 0) ...[
                            const SizedBox(height: AppSpacings.m),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.borderLight,
                            ),
                            const SizedBox(height: AppSpacings.m),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Remise',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '-${sale.discountAmount!.toStringAsFixed(2)} f',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: AppColors.errorColor,
                                    fontWeight: AppTypography.fontWeightSemiBold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacings.xxxl),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryDarker,
                          ],
                        ),
                        borderRadius: AppRadius.large,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.rLarge),
                          onTap: controller.printSale,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                AppIcons.print,
                                color: AppColors.textOnPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacings.s),
                              Text(
                                'Imprimer',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacings.l),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: AppRadius.large,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.errorColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.rLarge),
                          onTap: controller.cancelSale,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                AppIcons.close,
                                color: AppColors.textOnPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacings.s),
                              Text(
                                'Annuler',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacings.xl),
            ],
          ),
        );
      }),
      backgroundColor: AppColors.backgroundLight,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacings.l),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacings.s),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: AppRadius.small,
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: AppSpacings.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: AppSpacings.xxs),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppTypography.fontWeightMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 