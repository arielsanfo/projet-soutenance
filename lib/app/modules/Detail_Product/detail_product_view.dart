import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/app_constante.dart';
import 'detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Obx(() => Text(
              controller.product.value?.name ?? 'Détails du produit',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w600,
              ),
            )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
                SizedBox(height: AppSpacings.l),
                Text(
                  'Chargement des détails...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        if (controller.product.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.error,
                  size: 80,
                  color: AppColors.greyMedium,
                ),
                SizedBox(height: AppSpacings.l),
                Text(
                  'Produit non trouvé',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacings.s),
                Text(
                  'Le produit que vous recherchez n\'existe pas',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final product = controller.product.value!;

        return Column(
        children: [
          Container(
            height: AppSpacings.xxxxl * 4.5,
            width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyLight.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(),
          ),
                    )
                  : _buildImagePlaceholder(),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacings.l),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(16),
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
                  Text(
                            product.name!,
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                  ),
                          if (product.sku != null &&
                              product.sku!.isNotEmpty) ...[
                            SizedBox(height: AppSpacings.s),
                  Container(
                    padding: EdgeInsets.symmetric(
                                horizontal: AppSpacings.s,
                                vertical: AppSpacings.xxs,
                              ),
                    decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'UGS: ${product.sku}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacings.l),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.l,
                        vertical: AppSpacings.m,
                      ),
                      decoration: BoxDecoration(
                        color: (product.stockQuantity ?? 0) > 0
                            ? AppColors.tagGreenBackground
                            : AppColors.tagRedBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (product.stockQuantity ?? 0) > 0
                                ? AppColors.tagGreenText.withOpacity(0.2)
                                : AppColors.errorColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                    ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            (product.stockQuantity ?? 0) > 0
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: (product.stockQuantity ?? 0) > 0
                                ? AppColors.tagGreenText
                                : AppColors.errorColor,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacings.s),
                          Text(
                            (product.stockQuantity ?? 0) > 0
                                ? 'En Stock'
                                : 'Hors Stock',
                            style: AppTypography.titleSmall.copyWith(
                              color: (product.stockQuantity ?? 0) > 0
                                  ? AppColors.tagGreenText
                                  : AppColors.errorColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                    ),
                  ),
                  SizedBox(height: AppSpacings.xxxl),
                    if (product.description != null &&
                        product.description!.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.all(AppSpacings.l),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(16),
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
                                Icon(
                                  AppIcons.info,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: AppSpacings.s),
                  Text(
                    'Description',
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacings.m),
                            Text(
                              product.description!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                  ),
                  SizedBox(height: AppSpacings.l),
                    ],
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Prix de vente',
                            value:
                                '${product.salePrice?.toStringAsFixed(2) ?? 'N/A'} fcfa',
                            icon: AppIcons.credit_card,
                            color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: AppSpacings.l),
                      Expanded(
                        child: _buildInfoCard(
                            title: 'Stock disponible',
                            value: product.stockQuantity?.toString() ?? 'N/A',
                          subtitle: 'unités',
                            icon: AppIcons.inventory,
                            color: controller.getStockColor(product),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.l),
                    if (product.categoryLink.value != null)
                  _buildInfoCard(
                    title: 'Catégorie',
                        value: product.categoryLink.value!.name ?? 'N/A',
                        icon: AppIcons.category,
                        color: AppColors.secondaryColor,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
            _buildActionBar(),
          ],
        );
      }),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight,
            AppColors.backgroundWhite,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacings.l),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              AppIcons.image,
              size: AppSpacings.xxxxl * 1.5,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: AppSpacings.m),
          Text(
            'Aucune image disponible',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
              boxShadow: [
                BoxShadow(
            color: AppColors.greyLight.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tagGreenText.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                  controller.navigateToEdit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tagGreenText,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                      ),
                  elevation: 0,
                    ),
                icon: Icon(AppIcons.edit, size: 20),
                label: Text(
                  'Modifier',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
                  ),
                ),
                SizedBox(width: AppSpacings.l),
                Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.errorColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                  controller.deleteProduct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                    ),
                icon: Icon(AppIcons.delete, size: 20),
                label: Text(
                  'Supprimer',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    String? subtitle,
    IconData? icon,
    Color? color,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: color ?? AppColors.primaryColor,
                  size: 20,
                ),
                SizedBox(width: AppSpacings.s),
              ],
              Expanded(
                child: Text(
            title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.s),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: color ?? AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            SizedBox(height: AppSpacings.xs),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
