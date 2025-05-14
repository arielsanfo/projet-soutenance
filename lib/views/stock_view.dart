import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';

class StockMovementScreen extends StatelessWidget {
  StockMovementScreen({super.key});

  final List<Movement> movements = [
    Movement(
      type: 'Réception',
      reference: 'Commande Fournisseur #CF-089',
      product: 'Huile d\'Olive Bio',
      quantity: 20,
      date: DateTime(2024, 5, 4),
    ),
    Movement(
      type: 'Vente',
      reference: 'Vente #202400120',
      product: 'Savon Artisanal',
      quantity: -2,
      date: DateTime(2024, 5, 3),
    ),
    Movement(
      type: 'Ajustement',
      reference: 'Ajustement: Casse',
      product: 'Oeufs Bio',
      quantity: -3,
      date: DateTime(2024, 5, 2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Mouvements de Stock', style: AppTypography.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barre de Filtre
          Padding(
            padding: EdgeInsets.all(AppSpacings.xl),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filtrer par produit, date...',
                prefixIcon: Icon(AppIcons.search, color: AppColors.greyDark),
                filled: true,
                fillColor: AppColors.greyLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Liste des Mouvements
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              itemCount: movements.length + 1,
              separatorBuilder:
                  (context, index) => SizedBox(height: AppSpacings.s),
              itemBuilder: (context, index) {
                if (index == movements.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacings.s),
                    child: Center(
                      child: Text(
                        'Fin de l\'historique récent.',
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  );
                }
                return _buildMovementCard(movements[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementCard(Movement movement) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: AppRadius.defaultRadius,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.greyLight,
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Container(
            padding: EdgeInsets.all(AppSpacings.l),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: _getIconColor(movement.type).withOpacity(0.1),
              borderRadius: AppRadius.defaultRadius,
            ),
            child: Icon(
              _getMovementIcon(movement.type),
              color: _getIconColor(movement.type),
              size: AppSpacings.xxl,
            ),
          ),
          SizedBox(width: AppSpacings.xl),

          // Détails
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type et référence
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${movement.type} ',
                        style: AppTypography.titleSmall,
                      ),
                      TextSpan(
                        text: movement.reference,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacings.l),

                // Produit et quantité
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Produit: ',
                        style: AppTypography.bodyMedium,
                      ),
                      TextSpan(
                        text: movement.product,
                        style: AppTypography.titleSmall,
                        // style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            ' (${movement.quantity > 0 ? '+' : ''}${movement.quantity} unités)',
                        style: TextStyle(
                          color:
                              movement.quantity > 0
                                  ? AppColors.tagGreenText
                                  : AppColors.errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacings.l),

                // Date
                Text(
                  _formatDate(movement.date),
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMovementIcon(String type) {
    switch (type) {
      case 'Réception':
        return AppIcons.arrow_forward;
      case 'Vente':
        return AppIcons.arrow_update;
      default:
        return AppIcons.build;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'Réception':
        return AppColors.tagGreenText;
      case 'Vente':
        return AppColors.errorColor;
      default:
        return AppColors.tagOrangeText;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    return const [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ][month - 1];
  }
}

class Movement {
  final String type;
  final String reference;
  final String product;
  final int quantity;
  final DateTime date;

  const Movement({
    required this.type,
    required this.reference,
    required this.product,
    required this.quantity,
    required this.date,
  });
}
