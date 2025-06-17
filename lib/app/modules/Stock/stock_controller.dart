import 'package:get/get.dart';
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

class StockController extends GetxController {
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
