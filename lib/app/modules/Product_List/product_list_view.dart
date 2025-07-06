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

        return Column(children: [
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
          Expanded(
              child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(tabs: [
                        Tab(
                          text: "Tous (${controller.totalProducts})",
                        ),
                        Tab(
                          text: "Stock (${controller.lowStockProducts})",
                        ),
                        Tab(
                          text: "Rupture (${controller.outOfStockProducts})",
                        )
                      ]),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Tous
                            Obx(() => ListView.builder(
                              itemCount: controller.filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = controller.filteredProducts[index];
                                return _buildProductCard(product);
                              },
                            )),
                            // Stock bas
                            Obx(() {
                              final lowStockProducts = controller.filteredProducts.where((p) => (p.stockQuantity ?? 0) >= 1 && (p.stockQuantity ?? 0) < 10).toList();
                              if (lowStockProducts.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.info_outline, color: Colors.orange, size: 48),
                                        SizedBox(height: 12),
                                        Text('Aucun produit en stock bas.', style: AppTypography.titleMedium.copyWith(color: Colors.orange)),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: lowStockProducts.length,
                              itemBuilder: (context, index) {
                                  final product = lowStockProducts[index];
                                return _buildProductCard(product);
                              },
                              );
                            }),
                            // Rupture
                            Obx(() {
                              final outOfStockProducts = controller.filteredProducts.where((p) => (p.stockQuantity ?? 0) < 1).toList();
                              if (outOfStockProducts.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                                        SizedBox(height: 12),
                                        Text('Aucun produit en rupture de stock.', style: AppTypography.titleMedium.copyWith(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: outOfStockProducts.length,
                              itemBuilder: (context, index) {
                                  final product = outOfStockProducts[index];
                                  return _buildProductCard(product, showOutOfStock: true);
                              },
                              );
                            }),
                          ],
                          ),
                      )
                    ],
                  )))
        ]);
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

  Widget _buildProductCard(Product product, {bool showOutOfStock = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacings.l, vertical: AppSpacings.s),
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.12),
            child: Text(
              controller.getProductInitial(product),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                radius: 28,
              ),
              SizedBox(width: AppSpacings.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '-',
                      style: AppTypography.titleMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.categoryLink.value?.name ?? '-',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.inventory_2, size: 16, color: controller.getStockColor(product)),
                        SizedBox(width: 4),
                        Text(
                          'Stock: ${product.stockQuantity ?? 0}',
                          style: TextStyle(
                            color: controller.getStockColor(product),
            fontWeight: FontWeight.w600,
          ),
        ),
                        SizedBox(width: 12),
            Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                            color: controller.getStockColor(product).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                            controller.getStockStatus(product),
                            style: TextStyle(
                              color: controller.getStockColor(product),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                ),
              ),
            ),
                        if (showOutOfStock && (product.stockQuantity ?? 0) == 0) ...[
                          SizedBox(width: 12),
                Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning, color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                Text('Stock épuisé !', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
              ],
            ),
          ],
        ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
          child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppColors.primaryColor),
              onSelected: (value) async {
                if (value == 'details') {
                  controller.navigateToProductDetails(product);
                } else if (value == 'edit') {
                  await Get.toNamed(Routes.ADD_PRODUCT, arguments: product);
                  // Rafraîchir la liste après modification
                  await controller.refreshProducts();
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: Get.context!,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Supprimer le produit'),
                        ],
                      ),
                      content: Text('Voulez-vous vraiment supprimer ce produit ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Annuler'),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.delete),
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          label: Text('Supprimer'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await controller.deleteProduct(product);
                    Get.snackbar(
                      'Suppression',
                      'Produit supprimé avec succès',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      icon: Icon(Icons.delete, color: Colors.white),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(10),
                      borderRadius: 10,
                    );
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                      Icon(Icons.info, color: AppColors.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text('Voir détails'),
                  ],
                ),
              ),
                PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                      Icon(Icons.edit, color: AppColors.tagGreenText, size: 20),
                      SizedBox(width: 8),
                    Text('Modifier'),
                  ],
                ),
              ),
                PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                    Text('Supprimer'),
                  ],
                ),
              ),
            ],
          ),
        ),
        ],
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
