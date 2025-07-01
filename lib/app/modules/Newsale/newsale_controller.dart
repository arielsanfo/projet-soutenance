import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/saleService.dart';
import '../../data/controller/productService.dart';
import '../../data/controller/customerService.dart';
import '../../data/storage.dart';
import 'package:flutter/material.dart';
import '../ListSale/list_sale_controller.dart';

class CartProduct {
  final Product product;
  int quantity;
  CartProduct({required this.product, this.quantity = 1});
  }

class NewsaleController extends GetxController {
  late final SaleService saleService;
  late final ProductService productService;
  late final CustomerService customerService;

  final products = <Product>[].obs;
  final customers = <Customer>[].obs;
  final cart = <CartProduct>[].obs;
  final selectedCustomer = Rxn<Customer>();
  final paymentMethod = ''.obs;
  final isLoading = false.obs;
  final discount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    saleService = SaleService(isar);
    productService = ProductService(isar);
    customerService = CustomerService(isar);
    loadProducts();
    loadCustomers();
  }

  Future<void> loadProducts() async {
    products.value = await productService.getAllProducts();
  }

  Future<void> loadCustomers() async {
    customers.value = await customerService.getAllCustomers();
  }

  void addProductToCart(Product product) {
    final existing = cart.firstWhereOrNull((cp) => cp.product.id == product.id);
    if (existing != null) {
      existing.quantity++;
      cart.refresh();
    } else {
      cart.add(CartProduct(product: product));
    }
  }

  void removeProductFromCart(Product product) {
    cart.removeWhere((cp) => cp.product.id == product.id);
  }

  void updateQuantity(Product product, int quantity) {
    final cp = cart.firstWhereOrNull((cp) => cp.product.id == product.id);
    if (cp != null) {
      cp.quantity = quantity;
      cart.refresh();
    }
  }

  double get total =>
      cart.fold(
          0.0, (sum, cp) => sum + (cp.product.salePrice ?? 0) * cp.quantity) -
      discount.value;

  Future<void> processSale() async {
    print('TEST PRINT TERMINAL');
    if (cart.isEmpty) {
      print('PANIER VIDE');
      Get.snackbar('Erreur', 'Ajoutez au moins un produit à la vente.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedCustomer.value == null) {
      print('CLIENT NON SÉLECTIONNÉ');
      Get.snackbar('Erreur', 'Sélectionnez un client.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (paymentMethod.value.isEmpty) {
      print('PAIEMENT NON SÉLECTIONNÉ');
      Get.snackbar('Erreur', 'Sélectionnez un mode de paiement.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    print('AVANT processNewSale');
    try {
      final saleItems = cart
          .map((cp) => SaleItem(
                quantity: cp.quantity,
                unitPriceAtSale: cp.product.salePrice ?? 0,
              )..productLink.value = cp.product)
          .toList();
      await saleService.processNewSale(
        items: saleItems,
        customerId: selectedCustomer.value!.id,
        paymentMethod: paymentMethod.value,
        discount: discount.value,
      );
      print('APRÈS processNewSale');
      Get.snackbar('Succès', 'Vente enregistrée avec succès.',
          backgroundColor: Colors.green, colorText: Colors.white);
      cart.clear();
      discount.value = 0.0;
      paymentMethod.value = '';
      selectedCustomer.value = null;
      // Rafraîchir la liste des ventes si ListSaleController est présent
      final listSaleController = Get.isRegistered<ListSaleController>()
          ? Get.find<ListSaleController>()
          : null;
      listSaleController?.loadSales();
    } catch (e, stack) {
      print('ERREUR CATCH : $e');
      print('STACKTRACE : $stack');
      Get.snackbar('Erreur',
          'Erreur lors de l\'enregistrement de la vente :\n$e\n\n$stack',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 8));
    } finally {
      isLoading.value = false;
    }
  }
}
