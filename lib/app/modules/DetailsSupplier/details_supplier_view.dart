import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import '../../../app/data/storage.dart';
import 'details_supplier_controller.dart';

class DetailsSupplierView extends GetView<DetailsSupplierController> {
  DetailsSupplierView({super.key});

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
                          Obx(() => Text(
                                controller.supplier.value?.name ?? 'Détails Fournisseur',
                                style: AppTypography.titleLarge,
                              )),
                          SizedBox(height: AppSpacings.xs),
                          Text(
                            'Informations détaillées du fournisseur',
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
              ],
            ),
          ),

          // Contenu principal
          Expanded(
            child: Obx(() {
              final supplier = controller.supplier.value;
              if (supplier == null) {
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
                          AppIcons.warningTriangle,
                          size: 64,
                          color: AppColors.warningColor,
                        ),
                      ),
                      SizedBox(height: AppSpacings.xxl),
                      Text(
                        'Fournisseur non trouvé',
                        style: AppTypography.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacings.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Informations principales
                    _buildSupplierCard(supplier),
                    SizedBox(height: AppSpacings.l),

                    // Section Contact
                    _buildContactSection(supplier),
                    SizedBox(height: AppSpacings.l),

                    // Section Produits et conditions
                    _buildProductsSection(),
                    SizedBox(height: AppSpacings.xxl),

                    // Boutons d'action
                    _buildActionButtons(),
                  ],
                ),
              );
            }),
          ),

          // Bouton pour voir les commandes livrées
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
                icon: Icon(AppIcons.orders, color: AppColors.textOnPrimary, size: 24),
                label: Text(
                  'Voir commandes livrées',
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
                onPressed: () {
                  controller.navigateToSupplierOrders();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierCard(Supplier supplier) {
    return _buildInfoCard(
      title: 'Informations principales',
      icon: AppIcons.suppliers,
      children: [
        _buildInfoRow('Nom de l\'entreprise', supplier.name ?? 'Non spécifié'),
        if (supplier.contactPerson != null &&
            supplier.contactPerson!.isNotEmpty)
          _buildInfoRow('Contact principal', supplier.contactPerson!),
      ],
    );
  }

  Widget _buildContactSection(Supplier supplier) {
    return _buildInfoCard(
      title: 'Informations de contact',
      icon: AppIcons.person,
      children: [
        if (supplier.email != null && supplier.email!.isNotEmpty)
          _buildInfoRow('Email', supplier.email!, isEmail: true),
        if (supplier.phone != null && supplier.phone!.isNotEmpty)
          _buildInfoRow('Téléphone', supplier.phone!),
        if (supplier.address != null && supplier.address!.isNotEmpty)
          _buildInfoRow('Adresse', supplier.address!),
      ],
    );
  }

  Widget _buildProductsSection() {
    return _buildInfoCard(
      title: 'Produits et conditions',
      icon: AppIcons.inventory,
      children: [
        _buildInfoRow('Produits principaux', controller.products),
        _buildInfoRow('Conditions de paiement', controller.paymentConditions),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(50.0),
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
              Container(
                padding: EdgeInsets.all(AppSpacings.s),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25.0),
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
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.l),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isEmail = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacings.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSpacings.xs),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: isEmail ? AppColors.primaryColor : AppColors.textPrimary,
              fontWeight: isEmail ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
              onPressed: controller.navigateToEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 0,
              ),
              icon: Icon(AppIcons.edit, color: AppColors.textOnPrimary, size: 20),
              label: Text(
                'Modifier',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textOnPrimary,
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
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _showDeleteDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 0,
              ),
              icon: Icon(AppIcons.delete, color: AppColors.textOnPrimary, size: 20),
              label: Text(
                'Supprimer',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog() {
    final supplier = controller.supplier.value;
    if (supplier == null) return;

    showDialog(
      context: Get.context!,
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
            'Êtes-vous sûr de vouloir supprimer "${supplier.name}" ?\n\nCette action est irréversible.',
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
                controller.deleteSupplier();
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
}
