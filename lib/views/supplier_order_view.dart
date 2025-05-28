import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';

class NewSupplierOrderPage extends StatefulWidget {
  const NewSupplierOrderPage({super.key});

  @override
  State<NewSupplierOrderPage> createState() => _NewSupplierOrderPageState();
}

class _NewSupplierOrderPageState extends State<NewSupplierOrderPage> {
  final List<Map<String, dynamic>> _products = [];
  final TextEditingController _internalRefController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedSupplier;
  String? _selectedProduct;
  String _quantity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        title:  Text('Nouvelle Cde Fournisseur'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Sélection du Fournisseur
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'Choisir un fournisseur'),
              value: _selectedSupplier,
              items: [
                DropdownMenuItem(
                  value: 'Fournisseur 1',
                  child: Text('Fournisseur 1'),
                ),
                DropdownMenuItem(
                  value: 'Fournisseur 2',
                  child: Text('Fournisseur 2'),
                ),
                DropdownMenuItem(
                  value: 'Fournisseur 3',
                  child: Text('Fournisseur 3'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSupplier = value;
                });
              },
            ),

            SizedBox(height: AppSpacings.s),

            // Section Référence Interne
            TextField(
              controller: _internalRefController,
              decoration: InputDecoration(
                hintText: 'Référence interne (optionnel)',
              ),
            ),

            SizedBox(height: AppSpacings.l),

            // Section Ajouter des Produits
            Text('Ajouter des Produits', style: AppTypography.titleMedium),

            SizedBox(height: AppSpacings.s),

            // Champ Choisir produit
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: 'Choisir produit'),
              value: _selectedProduct,
              items: [
                DropdownMenuItem(
                  value: 'Huile d\'Olive Bio',
                  child: Text('Huile d\'Olive Bio '),
                ),
                DropdownMenuItem(
                  value: 'Pâtes Complètes',
                  child: Text('Pâtes Complètes '),
                ),
                DropdownMenuItem(
                  value: 'Riz Basmati',
                  child: Text('Riz Basmati'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                });
              },
            ),

            SizedBox(height: AppSpacings.s),

            // Champ Quantité
            TextField(
              decoration: InputDecoration(hintText: 'Qté'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
            ),

            SizedBox(height: AppSpacings.s),

            // Bouton d'ajout de produit
            ElevatedButton(
              onPressed: () {
                if (_selectedProduct != null && _quantity.isNotEmpty) {
                  setState(() {
                    _products.add({
                      'name': _selectedProduct!,
                      'quantity': _quantity,
                    });
                    _selectedProduct = null;
                    _quantity = '';
                  });
                }
              },
              child: Container(
                height: AppSpacings.xxl*2,
                alignment: Alignment.center,
                child: Icon(AppIcons.add, color: AppColors.primaryColor),
              ),
            ),

            SizedBox(height: AppSpacings.l),

            // Liste des Produits Ajoutés
            if (_products.isNotEmpty) ...[
              ..._products.map(
                (product) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacings.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product['name'], style: AppTypography.bodyMedium),
                      Text('Qté: ${product['quantity']}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.s),
            ],

            // Section Notes pour le Fournisseur
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'Notes pour le fournisseur...',
                contentPadding: EdgeInsets.all(AppSpacings.l),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            SizedBox(height: AppSpacings.l),

            // Bouton d'Envoi de la Commande
            ElevatedButton(
              onPressed: () {
                // Logique d'envoi de la commande
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.s),
                ),
              ),
              child: Text(
                'Envoyer la Commande',
                style: AppTypography.titleMedium.apply(color: AppColors.textOnPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
