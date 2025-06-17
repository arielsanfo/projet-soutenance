import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class AddOrderController extends GetxController {
  final List<CartItem> cartItems = [
    CartItem(id: 'P1', name: 'Pommes Gala Bio (1kg)', price: 2.99, quantity: 2),
    CartItem(id: 'P2', name: 'Bananes Cavendish', price: 1.49, quantity: 3),
    CartItem(id: 'P3', name: 'Lait Demi-écrémé 1L', price: 0.99, quantity: 1),
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get vat => subtotal * 0.2;
  double get total => subtotal + vat;

  void updateQuantity(int index, int newQuantity) {
    // setState(() {
    if (newQuantity > 0) {
      cartItems[index] = cartItems[index].copyWith(quantity: newQuantity);
    } else {
      cartItems.removeAt(index);
    }
    // });
  }

  void removeItem(int index) {
    // setState(() {
    cartItems.removeAt(index);
    // });
  }

  void proceedToPayment(BuildContext context) {
    // Logique de paiement ici
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paiement en cours...')),
    );
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
