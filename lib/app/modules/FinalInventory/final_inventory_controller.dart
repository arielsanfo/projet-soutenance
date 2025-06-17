import 'package:get/get.dart';

class FinalInventoryController extends GetxController {
    final List<Map<String, dynamic>> products = [
    {
      'name': 'Farine T55',
      'theoretical': 56,
      'unit': 'unités',
      'physical': null,
      'variance': 0,
      'reason': null
    },
    {
      'name': 'Sucre en Poudre',
      'theoretical': 20,
      'unit': 'kg',
      'physical': null,
      'variance': 0,
      'reason': null
    },
    {
      'name': 'Œufs',
      'theoretical': 120,
      'unit': 'pièces',
      'physical': null,
      'variance': 0,
      'reason': null
    }
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
