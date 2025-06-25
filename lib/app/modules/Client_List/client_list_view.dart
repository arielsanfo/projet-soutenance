import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import '../../data/storage.dart';

import 'package:get/get.dart';

import 'client_list_controller.dart';

class ClientListView extends GetView<ClientListController> {
  const ClientListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Gestion des Clients',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(AppSpacings.s),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: AppRadius.medium,
            ),
            child: Icon(
              AppIcons.backArrow,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          onPressed: (){
            Get.toNamed(Routes.DASHBOARD);
          },
        ),
      ),
      body: Column(
        children: [
          // Header avec design moderne
          Container(
            padding: EdgeInsets.fromLTRB(
                AppSpacings.l, 20, AppSpacings.l, AppSpacings.l),
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
                        AppIcons.customers,
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
                            'Gestion des Clients',
                            style: AppTypography.titleLarge,
                          ),
                          SizedBox(height: AppSpacings.xs),
                          Text(
                            'Gérez vos clients en toute simplicité',
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
                  child: SearchBar(
                    hintText: '🔍 Rechercher un client...',
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),

          // Liste des clients
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              child: Obx(() {
                if (controller.clients.isEmpty) {
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
                            AppIcons.customers,
                            size: 64,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: AppSpacings.xxl),
                        Text(
                          'Aucun client trouvé',
                          style: AppTypography.titleMedium,
                        ),
                        SizedBox(height: AppSpacings.s),
                        Text(
                          'Commencez par ajouter votre premier client',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredClients.isEmpty &&
                    controller.searchQuery.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSpacings.xxl),
                          decoration: BoxDecoration(
                            color: AppColors.warningColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            AppIcons.search,
                            size: 64,
                            color: AppColors.warningColor,
                          ),
                        ),
                        SizedBox(height: AppSpacings.xxl),
                        Text(
                          'Aucun résultat trouvé',
                          style: AppTypography.titleMedium,
                        ),
                        SizedBox(height: AppSpacings.s),
                        Text(
                          'Aucun client ne correspond à "${controller.searchQuery.value}"',
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
                  itemCount: controller.filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = controller.filteredClients[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacings.m),
                      child: ClientCard(client: client, controller: controller),
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
          onPressed: () {
            Get.toNamed(Routes.ADD_CLIENT);
          },
          icon: Icon(AppIcons.person, size: 24),
          label: Text(
            'Ajouter un Client',
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

class SearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchBar({super.key, required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
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
    );
  }
}

class ClientCard extends StatelessWidget {
  final Customer client;
  final ClientListController controller;

  const ClientCard({super.key, required this.client, required this.controller});

  void _showDeleteConfirmation(BuildContext context, Customer customer) {
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
            'Êtes-vous sûr de vouloir supprimer ${customer.name} ?',
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
                controller.deleteCustomer(customer);
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
    final name = client.name ?? '';
    final initials = name.isNotEmpty
        ? name
            .trim()
            .split(' ')
            .map((e) => e.isNotEmpty ? e[0] : '')
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    // Générer une couleur basée sur le nom
    final colors = [
      AppColors.primaryColor,
      AppColors.accentColor,
      AppColors.secondaryColor,
      AppColors.warningColor,
      Colors.teal.shade500,
      Colors.pink.shade500,
      Colors.indigo.shade500,
    ];
    final avatarColor = colors[name.hashCode % colors.length];

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(25.0),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(AppSpacings.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: AppColors.backgroundWhite,
          ),
          child: Row(
            children: [
              // Avatar avec couleur dynamique
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: avatarColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacings.l),
              // Détails du client
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacings.xs),
                    if (client.email?.isNotEmpty == true) ...[
                      Row(
                        children: [
                          Icon(
                            AppIcons.email,
                            size: 16,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: AppSpacings.xs),
                          Expanded(
                            child: Text(
                              client.email!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textLight,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (client.phone?.isNotEmpty == true) ...[
                      SizedBox(height: AppSpacings.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: AppSpacings.xs),
                          Text(
                            client.phone!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (client.address?.isNotEmpty == true) ...[
                      SizedBox(height: AppSpacings.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: AppSpacings.xs),
                          Expanded(
                            child: Text(
                              client.address!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                    if (value == 'edit') {
                      controller.editCustomer(client);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, client);
                    } else if (value == 'details') {
                      controller.navigateToDetails(client);
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
                      value: 'edit',
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppSpacings.s),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Icon(
                              AppIcons.edit,
                              size: 18,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: AppSpacings.m),
                          Text(
                            'Modifier',
                            style: AppTypography.labelMedium,
                          ),
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