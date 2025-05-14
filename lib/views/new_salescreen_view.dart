

import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  final List<CartItem> _cartItems = [
    CartItem(id: 'P1', name: 'Pommes Gala Bio (1kg)', price: 2.99, quantity: 2),
    CartItem(id: 'P2', name: 'Bananes Cavendish', price: 1.49, quantity: 3),
    CartItem(id: 'P3', name: 'Lait Demi-écrémé 1L', price: 0.99, quantity: 1),
  ];

  double get _subtotal => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get _vat => _subtotal * 0.2;
  double get _total => _subtotal + _vat;

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _proceedToPayment() {
    // Logique de paiement ici
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paiement en cours...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title:  Text('Nouvelle vente '),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Section Panier
          Padding(
            padding:  EdgeInsets.all(AppSpacings.xl),
            child: Text(
              'Panier (${_cartItems.length} articles)',
           style: AppTypography.titleLarge.apply(color: AppColors.secondaryColor),
            ),
          ),
          
          // Liste des articles
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return _buildCartItem(item, index);
              },
            ),
          ),
          
          // Récapitulatif des prix
          Container(
            padding:  EdgeInsets.all(AppSpacings.xxxl),
            decoration: BoxDecoration(
              color:AppColors.backgroundWhite,
              borderRadius: AppRadius.defaultRadius,
              // borderRadius:  BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color:AppColors.greyMedium,
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(1, 2)
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPriceRow('Sous-total:', _subtotal),
                 SizedBox(height: AppSpacings.l),
                _buildPriceRow('TVA (20%):', _vat),
                 SizedBox(height: AppSpacings.l),
                _buildPriceRow('Total:', _total, isBold: true),
                 SizedBox(height: AppSpacings.l),
                
                // Bouton de paiement
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _proceedToPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding:  EdgeInsets.symmetric(vertical: AppSpacings.xl),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.defaultRadius,
                      ),
                    ),
                    icon:  Icon(AppIcons.credit_card, color: AppColors.textOnPrimary),
                    label:  Text(
                      'Procéder au Paiement',
                style: AppTypography.titleSmall.apply(color: AppColors.textOnPrimary),
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

  Widget _buildCartItem(CartItem item, int index) {
    return Card(
      margin:  EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.m),
      child: Padding(
        padding:  EdgeInsets.all(AppSpacings.m),
        child: Row(
          children: [
            // Indicateur visuel
            Container(
              width: AppSpacings.xxxxl,
              height: AppSpacings.xxxl,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: AppRadius.defaultRadius,
              ),
              child: Text(
                item.id,
               style: AppTypography.bodyLarge.apply(color: AppColors.backgroundInput),
              ),
            ),
             SizedBox(width: AppSpacings.l),
            
            // Détails de l'article
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style:  AppTypography.titleSmall,
                  ),
                   SizedBox(height: AppSpacings.m),
                  Text(
                    '${item.price} € x ${item.quantity} = ${(item.price * item.quantity).toStringAsFixed(2)} €',
                    style: AppTypography.bodySmall.apply(color: AppColors.greyDark)
                  ),
                ],
              ),
            ),
            
            // Contrôle de quantité
            SizedBox(
              width: AppSpacings.xxxxl *2,
              child: TextField(
                controller: TextEditingController(text: item.quantity.toString()),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:  EdgeInsets.symmetric(vertical: AppSpacings.s),
                ),
                onSubmitted: (value) {
                  final newQuantity = int.tryParse(value) ?? item.quantity;
                  _updateQuantity(index, newQuantity);
                },
              ),
            ),
             SizedBox(width: AppSpacings.s),
            
            // Bouton de suppression
            IconButton(
              icon:  Icon(AppIcons.close, color:AppColors.errorColor),
              onPressed: () => _removeItem(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
       style: AppTypography.titleSmall,
        ),
        Text(
          '${amount.toStringAsFixed(2)} fcfa',
          style: TextStyle(
            fontSize: AppSpacings.l,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.primaryColor : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}