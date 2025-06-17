import 'package:get/get.dart';

// import 'product_list_view.dart';
class Product {
  final String name;
  final String category;
  final int stock;
  final String price;
  final String initial;

  Product({
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.initial,
  });
}
class ProductListController extends GetxController {
  int selectedTab = 0;
  final List<Product> products = [
    Product(
      name: "Pommes Gala Bio",
      category: "Fruits",
      stock: 56,
      price: "2.99f/kg",
      initial: "P",
    ),
    Product(
      name: "Savon Artisanal Lavande",
      category: "Hygiène",
      stock: 12,
      price: "4.50/U",
      initial: "S",
    ),
    Product(
      name: "Lait Demi-écrémé",
      category: "Produits laitiers",
      stock: 8,
      price: "1.20/L",
      initial: "L",
    ),
    Product(
      name: "Pain Complet",
      category: "Boulangerie",
      stock: 0,
      price: "3.50f/kg",
      initial: "P",
    ),
    Product(
      name: "Eau Minérale 1L",
      category: "Boissons",
      stock: 24,
      price: "0.80f/U",
      initial: "E",
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
