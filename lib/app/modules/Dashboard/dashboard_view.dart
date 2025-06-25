import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({super.key}) {
    Get.lazyPut(() => DashboardView());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacings.s),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryDarker,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                AppIcons.home,
                color: AppColors.textOnPrimary,
                size: 20,
              ),
            ),
            SizedBox(width: AppSpacings.m),
            Text(
              'Tableau de bord',
              style: AppTypography.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              AppIcons.notification,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              // TODO: Naviguer vers les notifications
            },
          ),
          IconButton(
            icon: Icon(AppIcons.settings, color: AppColors.primaryColor, size: 24),
            tooltip: 'Paramètres',
            onPressed: () {
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte des ventes du jour
            _buildSalesCard(),
            SizedBox(height: AppSpacings.xl),

            // Section Accès Rapides
            _buildSectionHeader('Accès Rapides', AppIcons.home),
            SizedBox(height: AppSpacings.l),
            _buildQuickAccessGrid(context),
            SizedBox(height: AppSpacings.xxxl),

            // Section Alertes Récentes
            _buildSectionHeader('Alertes Récentes', AppIcons.notification),
            SizedBox(height: AppSpacings.l),
            _buildAlertsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacings.s),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        SizedBox(width: AppSpacings.m),
        Text(
          title,
          style: AppTypography.titleLarge,
        ),
      ],
    );
  }

  Widget _buildSalesCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryDarker,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacings.s),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    AppIcons.chart,
                    color: AppColors.textOnPrimary,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppSpacings.m),
                Text(
                  'Ventes du jour',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '12500,75 FCFA',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacings.xs),
                    Text(
                      '+15% par rapport à hier',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(AppSpacings.m),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    AppIcons.chart,
                    color: AppColors.textOnPrimary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    final quickActions = [
      {
        'icon': AppIcons.orders,
        'label': 'Nouvelle Commande',
        'color': AppColors.primaryColor,
        'onTap': () {
          Get.toNamed(Routes.ADD_ORDER);
        },
      },
      {
        'icon': AppIcons.newSale,
        'label': 'Nouvelle Vente',
        'color': AppColors.accentColor,
        'onTap': () {
          Get.toNamed(Routes.LIST_SALE);
        },
      },
      {
        'icon': AppIcons.products,
        'label': 'Produits',
        'color': AppColors.secondaryColor,
        'onTap': () {
          Get.toNamed(Routes.PRODUCT_LIST);
        },
      },
      {
        'icon': AppIcons.reports,
        'label': 'Gestion des Dépenses',
        'color': AppColors.warningColor,
        'onTap': () {
          Get.toNamed(Routes.EXPENSE_REPORT);
        },
      },
      {
        'icon': AppIcons.suppliers,
        'label': 'Fournisseurs',
        'color': Colors.teal.shade500,
        'onTap': () {
          Get.toNamed(Routes.SUPPLIER_LIST);
        },
      },
      {
        'icon': AppIcons.customers,
        'label': 'Clients',
        'color': Colors.pink.shade500,
        'onTap': () {
          Get.toNamed(Routes.CLIENT_LIST);
        },
      },
      {
        'icon': AppIcons.inventory,
        'label': 'Inventaire',
        'color': Colors.indigo.shade500,
        'onTap': () {
          Get.toNamed(Routes.INVENTORY);
        },
      },
      {
        'icon': AppIcons.returnArrow,
        'label': 'Retours',
        'color': Colors.orange.shade500,
        'onTap': () {
          Get.toNamed(Routes.RECEPTION);
        },
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacings.m,
      crossAxisSpacing: AppSpacings.m,
      childAspectRatio: 1.1,
      children: quickActions.map((action) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: action['onTap'] as Function(),
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacings.m),
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      size: 32,
                      color: action['color'] as Color,
                    ),
                  ),
                  SizedBox(height: AppSpacings.m),
                  Text(
                    action['label'] as String,
                    textAlign: TextAlign.center,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlertsList() {
    final alerts = [
      {
        'title': 'Stock bas: Pommes Gala',
        'detail': 'Plus que 5 unités en stock',
        'icon': AppIcons.lowStock,
        'color': AppColors.warningColor,
      },
      {
        'title': 'Paiement en retard',
        'detail': 'Commande #4587 en attente',
        'icon': AppIcons.credit_card,
        'color': AppColors.errorColor,
      },
      {
        'title': 'Nouveau message',
        'detail': 'Message de Jean Dupont',
        'icon': AppIcons.notification,
        'color': AppColors.primaryColor,
      },
    ];

    return Column(
      children: alerts.map((alert) {
        return Container(
          margin: EdgeInsets.only(bottom: AppSpacings.m),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(AppSpacings.l),
            leading: Container(
              padding: EdgeInsets.all(AppSpacings.s),
              decoration: BoxDecoration(
                color: (alert['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                alert['icon'] as IconData,
                color: alert['color'] as Color,
                size: 24,
              ),
            ),
            title: Text(
              alert['title'] as String,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              alert['detail'] as String,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
            ),
            trailing: Icon(
              AppIcons.arrow,
              color: AppColors.textLight,
              size: 20,
            ),
            onTap: () {
              // TODO: Gérer les actions des alertes
            },
          ),
        );
      }).toList(),
    );
  }
}
