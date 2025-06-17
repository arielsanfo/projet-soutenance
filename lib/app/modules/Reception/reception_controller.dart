import 'package:get/get.dart';

class ReceptionController extends GetxController {
    final List<Map<String, dynamic>> products = [
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

  void updateReceivedQty(int index, String value) {
    // setState(() {
      int qty = int.tryParse(value) ?? 0;
      products[index]['receivedQty'] = qty;

      // Mettre à jour le statut
      if (qty == products[index]['orderedQty']) {
        products[index]['status'] = 'complete';
      } else if (qty == 0) {
        products[index]['status'] = 'missing';
      } else {
        products[index]['status'] = 'partial';
      }
    // });
  }

  void incrementQty(int index) {
    // setState(() {
      products[index]['receivedQty']++;
      if (products[index]['receivedQty'] == products[index]['orderedQty']) {
        products[index]['status'] = 'complete';
      } else {
        products[index]['status'] = 'partial';
      }
    // });
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
