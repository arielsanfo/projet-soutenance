import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/app_constante.dart';
import '../../data/storage.dart';
import '../../routes/app_pages.dart';
import 'product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  ProductListView({super.key}) {
    Get.lazyPut(() => ProductListView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Liste des Produits',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: AppSpacings.m),
            decoration: BoxDecoration(
              color: AppColors.primaryDarker,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(AppIcons.list, color: AppColors.textOnPrimary),
            onPressed: () {
                // Action pour changer la vue
            },
            ),
          ),
        ],
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
                  'Chargement des produits...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
        children: [
            // Barre de recherche
            Container(
              margin: EdgeInsets.all(AppSpacings.l),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyLight.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            child: TextField(
                onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                  hintText: "🔍 Rechercher un produit, SKU...",
                  hintStyle: TextStyle(
                    color: AppColors.greyMedium,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    AppIcons.search,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacings.l,
                    vertical: AppSpacings.m,
                  ),
                ),
              ),
            ),

            // Onglets de filtrage
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              padding: EdgeInsets.all(AppSpacings.s),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyLight.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            child: Row(
              children: [
                Flexible(
                    child: _buildTabButton(0, "Tous", controller.totalProducts),
                  ),
                Flexible(
                  child: _buildTabButton(
                        1, "Stock Bas", controller.lowStockProducts),
                ),
                Flexible(
                  child: _buildTabButton(
                        2, "Hors Stock", controller.outOfStockProducts),
                ),
              ],
            ),
          ),

            SizedBox(height: AppSpacings.m),

            // Liste des produits
          Expanded(
              child: controller.filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
                      itemCount: controller.filteredProducts.length,
              itemBuilder: (context, index) {
                        final product = controller.filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
        );
      }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.ADD_PRODUCT);
        },
          icon: Icon(AppIcons.add, size: 24),
          label: Text(
            'Ajouter un Produit',
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.products,
            size: 80,
            color: AppColors.greyMedium,
          ),
          SizedBox(height: AppSpacings.l),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'Aucun produit trouvé'
                : 'Aucun produit disponible',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacings.s),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'Essayez de modifier vos critères de recherche'
                : 'Commencez par ajouter votre premier produit',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, int count) {
    return Expanded(
      child: InkWell(
        onTap: () {
          controller.onTabChanged(index);
        },
        child: Column(
          children: [
            Text(
              "$label ($count)",
              style: TextStyle(
                fontWeight: controller.selectedTab.value == index
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: AppTypography.fontSizeSmall,
                color: controller.selectedTab.value == index
                    ? AppColors.primaryColor
                    : Colors.grey,
              ),
            ),
            SizedBox(height: AppSpacings.xxs),
            if (controller.selectedTab.value == index)
              Container(height: AppSpacings.m, color: AppColors.secondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacings.m),
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
      child: ListTile(
        onTap: () => controller.navigateToProductDetails(product),
        contentPadding: EdgeInsets.all(AppSpacings.l),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _getColorForInitial(controller.getProductInitial(product)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:
                    _getColorForInitial(controller.getProductInitial(product))
                        .withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
          child: Text(
              controller.getProductInitial(product),
              style: AppTypography.titleMedium.copyWith(
              color: AppColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          product.name ?? 'Sans nom',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacings.xs),
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
                product.categoryLink.value?.name ?? 'Sans catégorie',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: AppSpacings.s),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacings.s,
                    vertical: AppSpacings.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: controller.getStockColor(product).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Stock: ${(product.stockQuantity ?? 0).toString()}",
                    style: AppTypography.bodySmall.copyWith(
                      color: controller.getStockColor(product),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "${product.salePrice?.toStringAsFixed(2) ?? 'N/A'} fcfa",
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: PopupMenuButton<String>(
            icon: Icon(AppIcons.moreVert,
                size: 20, color: AppColors.textSecondary),
            onSelected: (value) {
              switch (value) {
                case 'details':
                  controller.navigateToProductDetails(product);
                  break;
                case 'edit':
                  Get.toNamed(Routes.ADD_PRODUCT, arguments: product);
                  break;
                case 'delete':
                  _showDeleteConfirmation(product);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'details',
                child: Row(
                  children: [
                    Icon(AppIcons.info,
                        color: AppColors.primaryColor, size: 20),
                    SizedBox(width: AppSpacings.s),
                    Text('Afficher les détails'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(AppIcons.edit,
                        color: AppColors.tagGreenText, size: 20),
                    SizedBox(width: AppSpacings.s),
                    Text('Modifier'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(AppIcons.delete,
                        color: AppColors.errorColor, size: 20),
                    SizedBox(width: AppSpacings.s),
                    Text('Supprimer'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    Get.dialog(
      AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text(
            'Voulez-vous vraiment supprimer "${product.name}" ? Cette action est irréversible.'),
        actions: [
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                await controller.deleteProduct(product);
                Get.back(); // Ferme la dialog
              } catch (e) {
                Get.back(); // Ferme la dialog
              }
            },
          ),
        ],
      ),
    );
  }

  Color _getColorForInitial(String initial) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[initial.codeUnitAt(0) % colors.length];
  }
}
