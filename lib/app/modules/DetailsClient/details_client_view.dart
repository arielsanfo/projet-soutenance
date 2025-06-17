import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'details_client_controller.dart';

class DetailsClientView extends GetView<DetailsClientController> {
  const DetailsClientView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Fiche Client: B. Martin', style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          children: [
            _buildClientInfo(),
            SizedBox(height: AppSpacings.l),
            _buildNavigationTabs(),
            SizedBox(height: AppSpacings.l),
            _buildAddressCard(),
            SizedBox(height: AppSpacings.l),
            _buildNotesCard(),
            SizedBox(height: AppSpacings.l),
            _buildDebtCard(),
            SizedBox(height: AppSpacings.l),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primaryColor,
          child: Text(
            'BM',
            style: AppTypography.titleLarge.apply(color: AppColors.borderLight),
          ),
        ),
        SizedBox(height: AppSpacings.l),
        Text('Béatrice Martin', style: AppTypography.titleLarge),
        SizedBox(height: AppSpacings.s),
        Text(
          'beatrice.martin@email.com',
          style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium),
        ),
        SizedBox(height: AppSpacings.s),
        Text(
          '+33 6 12 34 56 78',
          style: AppTypography.bodyMedium.apply(color: AppColors.greyDark),
        ),
      ],
    );
  }

  Widget _buildNavigationTabs() {
    return Row(
      children: [
        Expanded(child: _buildTabItem('Infos', isSelected: true)),
        Expanded(child: _buildTabItem('Achats (12)')),
        Expanded(child: _buildTabItem('Dettes')),
      ],
    );
  }

  Widget _buildTabItem(String text, {bool isSelected = false}) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            //
          },
          child: Text(
            text,
            style: AppTypography.bodyMedium.apply(
              color: isSelected ? AppColors.primaryColor : AppColors.greyMedium,
            ),
          ),
        ),
        if (isSelected) Container(height: 2, color: AppColors.primaryColor),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppSpacings.l),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adresse',
            style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium),
          ),
          SizedBox(height: AppSpacings.s),
          Text(
            '12 Rue de la Paix, 75002 Paris',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppSpacings.l),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium),
          ),
          SizedBox(height: AppSpacings.s),
          Text(
            'Préfère les produits bio. Demande souvent des conseils.',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDebtCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppSpacings.l),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solde de Dettes',
            style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium),
          ),
          SizedBox(height: AppSpacings.s),
          Text(
            '12.00 €',
            style: AppTypography.titleLarge.apply(color: AppColors.tagRedText),
          ),
          SizedBox(height: AppSpacings.l),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              minimumSize: Size(double.infinity, AppSpacings.xxxl * 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacings.l),
              ),
            ),
            child: Text(
              'Enregistrer un paiement',
              style: AppTypography.bodyMedium.apply(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(Routes.ADD_CLIENT);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(double.infinity, AppSpacings.xxxl * 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacings.l),
        ),
      ),
      child: Container(
        child: Text(
          'Modifier Fiche Client',
          style: AppTypography.bodyMedium.apply(color: AppColors.textOnPrimary),
        ),
      ),
    );
  }
}
