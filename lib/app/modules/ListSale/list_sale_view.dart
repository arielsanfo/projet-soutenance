import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'list_sale_controller.dart';

class ListSaleView extends GetView<ListSaleController> {
  const ListSaleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header avec design moderne
          Container(
            padding: EdgeInsets.fromLTRB(
                AppSpacings.l, 60, AppSpacings.l, AppSpacings.xxl),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacings.m),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryDarker,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        AppIcons.sales,
                        color: AppColors.textOnPrimary,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: AppSpacings.l),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestion des Ventes',
                            style: AppTypography.titleLarge,
                          ),
                          SizedBox(height: AppSpacings.xs),
                          Text(
                            'Suivez et gérez vos ventes',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.xl),
                // Barre de recherche améliorée
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundInput,
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.searchSales,
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '🔍 Rechercher par numéro, client ou date...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                      prefixIcon: Icon(
                        AppIcons.search,
                        size: 24,
                        color: AppColors.primaryColor,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: AppSpacings.l,
                        horizontal: AppSpacings.xl,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste des ventes
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              child: Obx(() {
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                        SizedBox(height: AppSpacings.xxl),
                        Text(
                          'Chargement des ventes...',
                          style: AppTypography.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredSales.isEmpty) {
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
                          child: Icon(
                            AppIcons.sales,
                            size: 64,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: AppSpacings.xxl),
                        Text(
                          'Aucune vente trouvée',
                          style: AppTypography.titleMedium,
                        ),
                        SizedBox(height: AppSpacings.s),
                        Text(
                          'Commencez par créer votre première vente',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                  itemCount: controller.filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = controller.filteredSales[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacings.m),
                      child: SaleCard(sale: sale, controller: controller),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),

      // Bouton d'ajout amélioré
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Get.toNamed('/newsale'),
          icon: Icon(AppIcons.add, size: 24),
          label: Text(
            'Nouvelle Vente',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class SaleCard extends StatelessWidget {
  final dynamic sale;
  final ListSaleController controller;

  const SaleCard({super.key, required this.sale, required this.controller});

  void _showDeleteConfirmation(BuildContext context, dynamic sale) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacings.s),
                decoration: BoxDecoration(
                  color: AppColors.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Icon(
                  AppIcons.warningTriangle,
                  color: AppColors.warningColor,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacings.m),
              Text(
                'Confirmer la suppression',
                style: AppTypography.titleMedium,
              ),
            ],
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer cette vente ?',
            style: AppTypography.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteSale(sale);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(
                'Supprimer',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final saleNumber = sale.saleNumber ?? 'Vente';
    final saleDate = sale.saleDate != null
        ? sale.saleDate!.toLocal().toString().split(" ")[0]
        : "-";
    final customerName = sale.customerLink.value?.name ?? 'Client non spécifié';
    final totalPrice = (sale.totalPrice ?? 0).toStringAsFixed(2);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(25.0),
        onTap: () {
          Get.toNamed(Routes.DETAIL_SALE, arguments: sale.id);
        },
        child: Container(
          padding: EdgeInsets.all(AppSpacings.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: AppColors.backgroundWhite,
          ),
          child: Row(
            children: [
              // Avatar avec icône de vente
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryDarker,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  AppIcons.sales,
                  color: AppColors.textOnPrimary,
                  size: 28,
                ),
              ),
              SizedBox(width: AppSpacings.l),
              // Détails de la vente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saleNumber,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacings.xs),
                    Row(
                      children: [
                        Icon(
                          AppIcons.calendar,
                          size: 16,
                          color: AppColors.textLight,
                        ),
                        SizedBox(width: AppSpacings.xs),
                        Text(
                          saleDate,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacings.xs),
                    Row(
                      children: [
                        Icon(
                          AppIcons.person,
                          size: 16,
                          color: AppColors.textLight,
                        ),
                        SizedBox(width: AppSpacings.xs),
                        Expanded(
                          child: Text(
                            customerName,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacings.xs),
                    Row(
                      children: [
                        Icon(
                          AppIcons.money,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: AppSpacings.xs),
                        Text(
                          '$totalPrice f',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Menu contextuel amélioré
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    AppIcons.moreVert,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  onSelected: (value) {
                    if (value == 'details') {
                      Get.toNamed(Routes.DETAIL_SALE, arguments: sale.id);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, sale);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'details',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: AppColors.primaryColor),
                          SizedBox(width: AppSpacings.s),
                          Text('Voir détails'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppSpacings.s),
                            decoration: BoxDecoration(
                              color: AppColors.errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Icon(
                              AppIcons.delete,
                              size: 18,
                              color: AppColors.errorColor,
                            ),
                          ),
                          SizedBox(width: AppSpacings.m),
                          Text(
                            'Supprimer',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
