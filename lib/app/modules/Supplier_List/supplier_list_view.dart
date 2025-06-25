import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import '../../../app/data/storage.dart';
import 'supplier_list_controller.dart';

class SupplierListView extends GetView<SupplierListController> {
  SupplierListView({super.key});

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
                        AppIcons.suppliers,
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
                            'Gestion des Fournisseurs',
                            style: AppTypography.titleLarge,
                          ),
                          SizedBox(height: AppSpacings.xs),
                          Text(
                            'Gérez vos fournisseurs en toute simplicité',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        AppIcons.close,
                        color: AppColors.textLight,
                        size: 24,
                      ),
                      onPressed: () => Get.back(),
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
                    onChanged: controller.searchSuppliers,
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '🔍 Rechercher un fournisseur...',
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

          // Liste des fournisseurs
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
                          'Chargement des fournisseurs...',
                          style: AppTypography.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredSuppliers.isEmpty) {
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
                            AppIcons.suppliers,
                            size: 64,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: AppSpacings.xxl),
                        Text(
                          'Aucun fournisseur trouvé',
                          style: AppTypography.titleMedium,
                        ),
                        SizedBox(height: AppSpacings.s),
                        Text(
                          'Commencez par ajouter votre premier fournisseur',
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
                  itemCount: controller.filteredSuppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = controller.filteredSuppliers[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacings.m),
                      child: SupplierCard(
                        supplier: supplier,
                        controller: controller,
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          // Bouton d'ajout amélioré
          Container(
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
            child: Container(
              width: double.infinity,
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
              child: ElevatedButton.icon(
                icon: Icon(AppIcons.add, color: AppColors.textOnPrimary, size: 24),
                label: Text(
                  'Ajouter Fournisseur',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacings.l,
                    horizontal: AppSpacings.xxxl,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 0,
                ),
                onPressed: controller.navigateToAdd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final SupplierListController controller;

  const SupplierCard({super.key, required this.supplier, required this.controller});

  void _showDeleteConfirmation(BuildContext context, Supplier supplier) {
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
            'Êtes-vous sûr de vouloir supprimer "${supplier.name}" ?',
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
                controller.deleteSupplier(supplier);
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
    final name = supplier.name ?? 'Sans nom';
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
        onTap: () async {
          final result = await Get.toNamed('/details-supplier', arguments: supplier);
          if (result == true) {
            Get.snackbar(
              'Succès',
              'Le fournisseur "$name" a bien été supprimé.',
              backgroundColor: AppColors.successColor,
              colorText: AppColors.textOnPrimary,
            );
            controller.loadSuppliers();
          }
        },
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
              // Détails du fournisseur
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
                    if (supplier.contactPerson != null &&
                        supplier.contactPerson!.isNotEmpty) ...[
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
                              'Contact: ${supplier.contactPerson}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textLight,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (supplier.email != null &&
                        supplier.email!.isNotEmpty) ...[
                      SizedBox(height: AppSpacings.xs),
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
                              supplier.email!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (supplier.phone != null &&
                        supplier.phone!.isNotEmpty) ...[
                      SizedBox(height: AppSpacings.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: AppSpacings.xs),
                          Text(
                            supplier.phone!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textLight,
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
                    if (value == 'details') {
                      controller.navigateToDetails(supplier);
                    } else if (value == 'edit') {
                      controller.navigateToEdit(supplier);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, supplier);
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