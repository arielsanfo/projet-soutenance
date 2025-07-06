// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';
import '../../data/controller/saleService.dart';
import '../../data/controller/supplierService.dart';
import '../ManagementOrder/management_order_controller.dart';

class AddOrderController extends GetxController {
  final products = <Product>[].obs;
  final suppliers = <Supplier>[].obs;
  final cartItems = <SaleItem>[].obs;
  final selectedSupplier = Rxn<Supplier>();
  final paymentMethod = ''.obs;
  final isLoading = false.obs;

  late final Isar isar;
  late final SaleService saleService;
  late final SupplierService supplierService;

  var currentSale;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    saleService = SaleService(isar);
    supplierService = SupplierService(isar);
    loadProducts();
    loadSuppliers();
  }

  Future<void> loadProducts() async {
    final result = await isar.products.where().findAll();
    products.assignAll(result);
  }

  Future<void> loadSuppliers() async {
    final result = await supplierService.getAllSuppliers();
    suppliers.assignAll(result);
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
    if (selectedSupplier.value == null || cartItems.isEmpty) {
      Get.snackbar('Erreur', 'Sélectionnez un fournisseur et ajoutez des produits.', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      return;
    }
    isLoading.value = true;
    try {
      final items = cartItems.map((item) => {
        'productName': item.productLink.value?.name ?? '',
        'quantity': item.quantity ?? 0,
        'unitCost': item.unitPriceAtSale ?? 0.0,
      }).toList();
      final managementOrderController = Get.find<ManagementOrderController>();
      await managementOrderController.createSupplierOrder(
        supplierName: selectedSupplier.value!.name ?? '',
        items: items,
        notes: null,
      );
      isLoading.value = false;
      cartItems.clear();
      Get.back();
      Get.snackbar('Succès', 'Commande fournisseur ajoutée avec succès', backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.TOP);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Erreur', 'Erreur lors de l\'ajout de la commande fournisseur', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
    }
  }
}
