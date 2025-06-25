// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';
import '../../data/controller/saleService.dart';

class AddOrderController extends GetxController {
  final products = <Product>[].obs;
  final customers = <Customer>[].obs;
  final cartItems = <SaleItem>[].obs;
  final selectedCustomer = Rxn<Customer>();
  final paymentMethod = ''.obs;
  final isLoading = false.obs;

  late final Isar isar;
  late final SaleService saleService;

  var currentSale;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    saleService = SaleService(isar);
    loadProducts();
    loadCustomers();
  }

  Future<void> loadProducts() async {
    final result = await isar.products.where().findAll();
    products.assignAll(result);
  }

  Future<void> loadCustomers() async {
    final result = await isar.customers.where().findAll();
    customers.assignAll(result);
  }

  void addProductToCart(Product product, int quantity) {
    final existing = cartItems
        .firstWhereOrNull((item) => item.productLink.value?.id == product.id);
    if (existing != null) {
      existing.quantity = (existing.quantity ?? 0) + quantity;
      existing.totalPrice =
          (existing.quantity ?? 0) * (existing.unitPriceAtSale ?? 0.0);
      cartItems.refresh();
    } else {
      final item = SaleItem(
        quantity: quantity,
        unitPriceAtSale: product.salePrice ?? 0.0,
      );
      item.productLink.value = product;
      item.totalPrice = (item.quantity ?? 0) * (item.unitPriceAtSale ?? 0.0);
      cartItems.add(item);
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      cartItems[index].quantity = newQuantity;
      cartItems[index].totalPrice =
          newQuantity * (cartItems[index].unitPriceAtSale ?? 0.0);
      cartItems.refresh();
    } else {
      cartItems.removeAt(index);
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.totalPrice ?? 0.0));
  double get vat => subtotal * 0.2;
  double get total => subtotal + vat;

  Future<void> saveOrder() async {
    if (selectedCustomer.value == null || cartItems.isEmpty) {
      Get.snackbar('Erreur', 'Sélectionnez un client et ajoutez des produits.');
      return;
    }
    isLoading.value = true;
    await saleService.processNewSale(
      items: cartItems.toList(),
      customerId: selectedCustomer.value!.id,
      paymentMethod:
          paymentMethod.value.isNotEmpty ? paymentMethod.value : 'Espèces',
    );
    isLoading.value = false;
    Get.snackbar('Succès', 'Commande enregistrée !');
    cartItems.clear();
  }
}
