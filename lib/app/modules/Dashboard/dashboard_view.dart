import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
// import 'package:flutter_application_1/app/modules/Login/login_controller.dart';
import 'package:flutter_application_1/app/data/controller/userServices.dart';

import 'package:get/get.dart';

import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({super.key}) {
    Get.lazyPut(() => DashboardController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FutureBuilder<String?>(
          future: SessionManager.getUserName(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Text(
                'Bonjour, ${snapshot.data}',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
            return Text(
              'Dashboard',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.primaryColor),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      
      ),
      drawer: _buildUserDrawer(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte d'informations utilisateur
            _buildUserInfoCard(),
            SizedBox(height: AppSpacings.l),
            
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

  Widget _buildUserDrawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: SessionManager.getSessionInfo(),
        builder: (context, snapshot) {
          final sessionInfo = snapshot.data;
          final userName = sessionInfo?['user_name'] ?? 'Utilisateur';
          final userEmail = sessionInfo?['user_email'] ?? '';
          final userRole = sessionInfo?['user_role'] ?? 'Utilisateur';
          
          // Générer les initiales pour l'avatar
          final initials = userName.isNotEmpty
              ? userName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
              : 'U';
          
          return Column(
            children: [
              // Header du drawer avec informations utilisateur
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + AppSpacings.l,
                  bottom: AppSpacings.l,
                  left: AppSpacings.l,
                  right: AppSpacings.l,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // CircleAvatar cliquable pour aller au profil
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Fermer le drawer
                        _navigateToProfile();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.textOnPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.textOnPrimary,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacings.m),
                    Text(
                      userName,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.s),
                    Text(
                      userEmail,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.s),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        userRole,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu du drawer
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: 'Mon Profil',
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToProfile();
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: 'Paramètres',
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(Routes.SETTINGS);
                      },
                    ),
                    Divider(color: AppColors.greyLight),
                    _buildDrawerItem(
                      icon: Icons.shopping_cart,
                      title: 'Ventes',
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(Routes.NEWSALE);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: 'Clients',
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(Routes.CLIENT_LIST);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.inventory,
                      title: 'Produits',
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(Routes.PRODUCT_LIST);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.local_shipping,
                      title: 'Fournisseurs',
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(Routes.SUPPLIER_LIST);
                      },
                    ),
                    Divider(color: AppColors.greyLight),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      title: 'Se déconnecter',
                      onTap: () async {
                        Navigator.pop(context);
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Row(
                              children: [
                                Icon(Icons.logout, color: AppColors.tagRedText),
                                SizedBox(width: 12),
                                Expanded(child: Text('Déconnexion')),
                              ],
                            ),
                            content: Text('Voulez-vous vraiment vous déconnecter ?', textAlign: TextAlign.center),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text('Annuler'),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.logout),
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.tagRedText,
                                  foregroundColor: AppColors.textOnPrimary,
                                ),
                                label: Text('Se déconnecter'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await SessionManager.clearSession();
                          SessionNotificationService.notifyLogout();
                          Get.offAllNamed(Routes.LOGIN);
                        }
                      },
                      textColor: AppColors.tagRedText,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColors.primaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          color: textColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacings.l,
        vertical: AppSpacings.s,
      ),
    );
  }

  void _navigateToProfile() async {
    final currentUser = await SessionManager.getCurrentUser();
    if (currentUser != null) {
      Get.toNamed(Routes.PROFILE, arguments: currentUser);
    } else {
      Get.snackbar(
        'Erreur',
        'Impossible de récupérer les informations du profil',
        backgroundColor: AppColors.tagRedText,
        colorText: AppColors.textOnPrimary,
      );
    }
  }

  Widget _buildUserInfoCard() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: SessionManager.getSessionInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final sessionInfo = snapshot.data!;
          return Container(
            padding: EdgeInsets.all(AppSpacings.l),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.accentColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacings.m),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
                SizedBox(width: AppSpacings.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessionInfo['user_name'] ?? 'Utilisateur',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        sessionInfo['user_email'] ?? '',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.greyMedium,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Rôle: ${sessionInfo['user_role'] ?? 'Utilisateur'}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
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
        return SizedBox.shrink();
      },
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
    return InkWell(
      onTap: () {
        // Naviguer vers la liste des ventes du jour
        Get.toNamed(Routes.LIST_SALE, arguments: {'filter': 'today'});
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textOnPrimary.withOpacity(0.7),
                    size: 16,
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
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    final quickActions = [
      {
        'icon': AppIcons.orders,
        'color': AppColors.primaryColor,
        'label': 'Commande',
        'onTap': () {
          Get.toNamed(Routes.MANAGEMENT_ORDER);
        },
      },
      {
        'icon': Icons.point_of_sale,
        'label': 'Vente',
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
        'icon': Icons.reset_tv,
        'label': 'Depenses',
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
        'icon': AppIcons.debt,
        'label': 'Dettes',
        'color': Colors.red.shade500,
        'onTap': () {
          Get.toNamed(Routes.DETTES);
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
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
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
                  Icon(
                    action['icon'] as IconData,
                    size: 25,
                    color: Colors.indigo[400],
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
