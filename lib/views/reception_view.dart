import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';

class ReceptionScreen extends StatefulWidget {
  const ReceptionScreen({super.key});

  @override
  State<ReceptionScreen> createState() => _ReceptionScreenState();
}

class _ReceptionScreenState extends State<ReceptionScreen> {
  // Données de démonstration
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Huile d\'Olive Bio (Carton de 12)',
      'orderedQty': 2,
      'receivedQty': 2,
      'status': 'complete',
    },
    {
      'name': 'Pâtes Complètes (Pack de 6)',
      'orderedQty': 5,
      'receivedQty': 3,
      'status': 'partial',
    },
    {
      'name': 'Riz Basmati (Sac de 5kg)',
      'orderedQty': 3,
      'receivedQty': 0,
      'status': 'missing',
    },
  ];

  void _updateReceivedQty(int index, String value) {
    setState(() {
      int qty = int.tryParse(value) ?? 0;
      _products[index]['receivedQty'] = qty;

      // Mettre à jour le statut
      if (qty == _products[index]['orderedQty']) {
        _products[index]['status'] = 'complete';
      } else if (qty == 0) {
        _products[index]['status'] = 'missing';
      } else {
        _products[index]['status'] = 'partial';
      }
    });
  }

  void _incrementQty(int index) {
    setState(() {
      _products[index]['receivedQty']++;
      if (_products[index]['receivedQty'] == _products[index]['orderedQty']) {
        _products[index]['status'] = 'complete';
      } else {
        _products[index]['status'] = 'partial';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réception Commande #F20240012'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Fournisseur
                  _buildSupplierCard(),
                  SizedBox(height: AppSpacings.l),

                  // Section Produits
                  _buildProductsSection(),
                ],
              ),
            ),
          ),

          // Bouton de validation
          _buildValidationButton(context),
        ],
      ),
    );
  }

  Widget _buildSupplierCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fournisseur',
              style: AppTypography.bodyMedium.apply(color: AppColors.greyDark),
            ),
            SizedBox(height: AppSpacings.s),
            Text('BioFrais Distribution', style: AppTypography.titleMedium),
            SizedBox(height: AppSpacings.s),
            Text(
              'contact@biofrais.com',
              style: AppTypography.bodyMedium.apply(color: AppColors.greyDark),
            ),
            Text(
              '04 11 22 33 44',
              style: AppTypography.bodyMedium.apply(color: AppColors.greyDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Produits à Réceptionner', style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.s),
        ..._products.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacings.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product['name'],
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    _buildStatusIndicator(product['status']),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                Text(
                  'Qté Commandée: ${product['orderedQty']}',
                  style: AppTypography.bodyMedium.apply(
                    color: AppColors.greyDark,
                  ),
                ),
                SizedBox(height: AppSpacings.s),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: product['orderedQty'].toString(),
                          labelText: 'Qté Réceptionnée',
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text:
                              product['receivedQty'] > 0
                                  ? product['receivedQty'].toString()
                                  : '',
                        ),
                        onChanged: (value) => _updateReceivedQty(index, value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () => _incrementQty(index),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacings.m),
                          ),
                        ),
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.l),
                Divider(height: AppSpacings.s, color: AppColors.greyLight),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStatusIndicator(String status) {
    switch (status) {
      case 'complete':
        return Icon(Icons.check_circle, color: AppColors.accentColor);
      case 'partial':
        return Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.accentColor),
            SizedBox(width: AppSpacings.s),
            Text(
              'Écart',
              style: AppTypography.bodyMedium.apply(
                color: AppColors.accentColor,
              ),
            ),
          ],
        );
      case 'missing':
        return Icon(Icons.error_outline, color: AppColors.errorColor);
      default:
        return SizedBox();
    }
  }

  Widget _buildValidationButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacings.l),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          minimumSize: Size(double.infinity, AppSpacings.l),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacings.m),
          ),
        ),
        onPressed: () {
          // Logique de validation
          final allComplete = _products.every((p) => p['status'] == 'complete');

          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(
                    allComplete
                        ? 'Valider la réception?'
                        : 'Réception incomplète',
                  ),
                  content: Text(
                    allComplete
                        ? 'Confirmez-vous la réception complète de cette commande?'
                        : 'Certains produits n\'ont pas été réceptionnés en totalité. Souhaitez-vous tout de même valider?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              allComplete
                                  ? 'Réception validée avec succès'
                                  : 'Réception partielle enregistrée',
                            ),
                          ),
                        );
                      },
                      child: Text('Confirmer'),
                    ),
                  ],
                ),
          );
        },
        child: Text(
          'Valider la Réception',
          style: AppTypography.bodyMedium.apply(color: Colors.white),
        ),
      ),
    );
  }
}
