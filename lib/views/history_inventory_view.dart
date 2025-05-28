import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';


class HistoryIventoryScreen extends StatefulWidget {
  const HistoryIventoryScreen({super.key});

  @override
  State<HistoryIventoryScreen> createState() => _HistoryIventoryScreenState();
}

class _HistoryIventoryScreenState extends State<HistoryIventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String productName = "Huile d'Olive Bio";
  final int currentStock = 32;
  final String unit = "bouteilles";

  final List<InventoryMovement> movements = [
    InventoryMovement(
      type: "Réception",
      reference: "Cde Fournisseur #F20240010",
      date: "01 Mai 2024",
      quantity: 24,
      stockAfter: 35,
      isPositive: true,
    ),
    InventoryMovement(
      type: "Vente",
      reference: "#C20240068",
      date: "02 Mai 2024",
      quantity: 2,
      stockAfter: 33,
      isPositive: false,
    ),
    InventoryMovement(
      type: "Vente",
      reference: "#C20240072",
      date: "03 Mai 2024",
      quantity: 1,
      stockAfter: 32,
      isPositive: false,
    ),
    InventoryMovement(
      type: "Ajustement",
      reference: "Casse",
      date: "28 Avril 2024",
      quantity: 3,
      stockAfter: 11,
      isPositive: false,
    ),
    InventoryMovement(
      type: "Réception",
      reference: "Cde Fournisseur #F20240008",
      date: "25 Avril 2024",
      quantity:15,
      stockAfter: 14,
      isPositive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.backgroundWhite,
      appBar: AppBar(
        title:  Text(
          "Historique d'Inventaire",
style: AppTypography.titleLarge,        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Product Information Section
          Padding(
            padding:  EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.inventory_outlined, 
                        color: AppColors.tagBlueText, size: 30),
                     SizedBox(width: AppSpacings.m),
                     Text(
                      "PRODUIT",
                   style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
                 SizedBox(height: AppSpacings.m),
                Text(
                  productName,
                style: AppTypography.titleLarge,
                ),
                 SizedBox(height: AppSpacings.m),
                Text(
                  "Stock Actuel: $currentStock $unit",
                 style: AppTypography.titleSmall,
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.xl),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Filtrer par date, type...",
                prefixIcon:  Icon(AppIcons.search, size: 20),
                filled: true,
                fillColor: AppColors.backgroundInput,
                contentPadding:  EdgeInsets.symmetric(vertical: AppSpacings.s),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.m),
                  borderSide: BorderSide(color: AppColors.greyLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.m),
                  borderSide: BorderSide(color: AppColors.greyLight),
                ),
              ),
            ),
          ),

          // Movements List Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
            child: Row(
              children: [
                 Text(
                  "MOUVEMENTS",
                  style: AppTypography.titleSmall,
                ),
                 Spacer(),
                Text(
                  "${movements.length} éléments",
                style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),

          // Movements List
          Expanded(
            child: ListView.builder(
              padding:  EdgeInsets.symmetric(horizontal: AppSpacings.l),
              itemCount: movements.length,
              itemBuilder: (context, index) {
                return _buildMovementCard(movements[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementCard(InventoryMovement movement) {
    return Card(
      child: Padding(
        padding:  EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${movement.type} ${movement.reference}",
           style: AppTypography.titleSmall,
            ),
             SizedBox(height: AppSpacings.s),
            Row(
              children: [
                Icon(
                  _getMovementIcon(movement.type),
                  size: 16,
                  color: _getMovementColor(movement.type),
                ),
                 SizedBox(width: AppSpacings.s),
                Text(
                  movement.date,
                 style: AppTypography.bodyMedium,
                ),
                 SizedBox(width: AppSpacings.s),
                Text(
                  "Quantité: ${movement.isPositive ? '+' : '-'}${movement.quantity}",
                  style: TextStyle(
                    fontSize: 11,
                    color: movement.isPositive ? AppColors.tagGreenText :AppColors.tagRedText,
                  ),
                ),
                 SizedBox(width: AppSpacings.s),
                Text(
                  "Stock: ${movement.stockAfter}",
                  style: TextStyle(
                    fontSize: 11,
                    color:AppColors.greyDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMovementIcon(String type) {
    switch (type) {
      case "Réception":
        return Icons.arrow_circle_down;
      case "Vente":
        return Icons.arrow_circle_up;
      case "Ajustement":
        return Icons.adjust;
      default:
        return Icons.circle;
    }
  }

  Color _getMovementColor(String type) {
    switch (type) {
      case "Réception":
        return Colors.green;
      case "Vente":
        return Colors.blue;
      case "Ajustement":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class InventoryMovement {
  final String type;
  final String reference;
  final String date;
  final int quantity;
  final int stockAfter;
  final bool isPositive;

  InventoryMovement({
    required this.type,
    required this.reference,
    required this.date,
    required this.quantity,
    required this.stockAfter,
    required this.isPositive,
  });
}