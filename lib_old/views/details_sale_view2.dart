import 'package:flutter/material.dart';
import '../../lib/helpers/app_constante.dart';

class SaleDetailScreen extends StatelessWidget {
  const SaleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SaleItem> items = [
      SaleItem(name: 'Pommes Gala Bio', quantity: '2kg', price: 5.98),
      SaleItem(name: 'Bananes Cavendish', quantity: '1.5kg', price: 2.24),
      SaleItem(name: 'Lait Demi-écrémé', quantity: '2 bouteilles', price: 1.98),
    ];

    final double total = items.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: Text('Détails Vente '), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Client
                  Card(
                    margin: EdgeInsets.only(bottom: AppSpacings.xxl),
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacings.xxl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Client', style: AppTypography.titleMedium),
                          SizedBox(height: AppSpacings.l),
                          Text(
                            'Alexandre Dupont',
                            style: AppTypography.titleLarge,
                          ),
                          SizedBox(height: AppSpacings.s),
                          Text(
                            'alex.d@example.com',
                            style: AppTypography.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('Articles', style: AppTypography.titleLarge),
                  SizedBox(height: AppSpacings.s),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder:
                        (context, index) => Divider(height: AppSpacings.l),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildSaleItem(item);
                    },
                  ),
                  SizedBox(height: AppSpacings.xxxl),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payé:', style: AppTypography.titleLarge),
                      Text(
                        '${total.toStringAsFixed(2)} f',
                        style: AppTypography.titleLarge.apply(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Barre d'actions
          Container(
            padding: EdgeInsets.all(AppSpacings.xl),
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyMedium,
                  spreadRadius: 1,
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action d'impression
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textLight,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.defaultRadius,
                      ),
                    ),
                    icon: Icon(AppIcons.print),
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text('Imprimer'), Text('Reçu')],
                    ),
                  ),
                ),
                SizedBox(width: AppSpacings.xl),

                // Bouton Retour
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action de retour
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.backgroundWhite,
                      padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.defaultRadius,
                      ),
                    ),
                    icon: Icon(AppIcons.refresh),
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text('Effectuer'), Text('un Retour')],
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

  Widget _buildSaleItem(SaleItem item) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.name} (${item.quantity})',
                style: AppTypography.bodyLarge,
              ),
              Text(
                '${item.price.toStringAsFixed(2)} €',
                style: AppTypography.titleSmall,
              ),
            ],
          ),
        ),
        Icon(AppIcons.chevron_right, color: AppColors.greyDark),
      ],
    );
  }
}

class SaleItem {
  final String name;
  final String quantity;
  final double price;

  SaleItem({required this.name, required this.quantity, required this.price});
}
