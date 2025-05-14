import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';



class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion de l\'Inventaire',
          style: AppTypography.titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTotalValueCard(),
            SizedBox(height: AppSpacings.xxl),

            // Statistiques Rapides
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Articles en stock',
                    '875',
                    AppColors.tagGreenText,
                  ),
                ),
                SizedBox(width: AppSpacings.m),
                Expanded(
                  child: _buildStatCard(
                    'Articles en rupture',
                    '3',
                    AppColors.errorColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.xxxl),

            // Section Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              child: Text(
                'Actions d\'Inventaire',
                style: AppTypography.titleLarge,
              ),
            ),
            SizedBox(height: AppSpacings.l),

            _buildActionButton(
              icon: AppIcons.list,
              label: 'Voir tous les articles',
            ),
            SizedBox(height: AppSpacings.l),
            _buildActionButton(
              icon: AppIcons.swap_horiz,
              label: 'Mouvements de Stock',
            ),
            SizedBox(height: AppSpacings.l),
            _buildActionButton(
              icon: AppIcons.checklist_rtl,
              label: 'Prise d\'Inventaire',
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //
        },
        icon: Icon(AppIcons.add, color: AppColors.backgroundInput),
        label: Text(
          'Ajustement Manuel',
          style: AppTypography.titleSmall.apply(color: AppColors.textOnPrimary),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.defaultRadius),
      ),
    );
  }

  Widget _buildTotalValueCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: AppRadius.defaultRadius,
      ),
      child: Column(
        children: [
          Text('Valeur Totale du Stock', style: AppTypography.titleMedium),
          SizedBox(height: AppSpacings.s),
          Text(
            '12,345.67 €',
            style: AppTypography.titleLarge.apply(
              color: AppColors.primaryDarker,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: AppRadius.defaultRadius,
      ),
      child: Column(
        children: [
          Text(title, style: AppTypography.titleSmall),
          SizedBox(height: AppSpacings.m),
          Text(value, style: AppTypography.titleLarge.apply(color: color)),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacings.l,
        horizontal: AppSpacings.m,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppRadius.defaultRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDarker),
          SizedBox(width: AppSpacings.xl),
          Text(
            label,
            style: AppTypography.titleMedium.apply(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
