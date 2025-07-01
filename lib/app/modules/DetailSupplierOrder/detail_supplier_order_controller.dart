import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../../app/data/storage.dart';
import '../../../app/data/controller/supplierService.dart';

class DetailSupplierOrderController extends GetxController {
  final supplierOrder = Rxn<SupplierOrder>();
  final isLoading = false.obs;
  final orderItems = <SupplierOrderItem>[].obs;
  final TextEditingController notesController = TextEditingController();

  late final SupplierOrderService supplierOrderService;

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    supplierOrderService = SupplierOrderService(isar);
    _loadSupplierOrderData();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  /// Charger les données de la commande fournisseur
  void _loadSupplierOrderData() {
    final args = Get.arguments;
    if (args != null && args is SupplierOrder) {
      supplierOrder.value = args;
      _loadOrderItems();
    } else {
      Get.snackbar(
        'Erreur',
        'Commande fournisseur non trouvée',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  /// Charger les articles de la commande
  Future<void> _loadOrderItems() async {
    if (supplierOrder.value == null) return;

    try {
      await supplierOrder.value!.supplierOrderItems.load();
      orderItems.value = supplierOrder.value!.supplierOrderItems.toList();
    } catch (e) {
      print('Erreur lors du chargement des articles: $e');
    }
  }

  /// Calculer le sous-total
  double get subtotal {
    return orderItems.fold(
      0.0,
      (sum, item) => sum + (item.totalCost ?? 0.0),
    );
  }

  /// Calculer la TVA (20%)
  double get vat => subtotal * 0.2;

  /// Calculer le total
  double get total => subtotal + vat;

  /// Obtenir le statut de la commande
  String get orderStatus {
    if (supplierOrder.value?.status == null) return 'Brouillon';

    switch (supplierOrder.value!.status) {
      case SupplierOrderStatusIsar.draft:
        return 'Brouillon';
      case SupplierOrderStatusIsar.sent:
        return 'Envoyée';
      case SupplierOrderStatusIsar.partiallyReceived:
        return 'Partiellement reçue';
      case SupplierOrderStatusIsar.received:
        return 'Réceptionnée';
      case SupplierOrderStatusIsar.cancelled:
        return 'Annulée';
      default:
        return 'Brouillon';
    }
  }

  /// Mettre à jour le statut de la commande
  Future<void> updateOrderStatus(SupplierOrderStatusIsar newStatus) async {
    if (supplierOrder.value == null) return;

    try {
      supplierOrder.value!.status = newStatus;
      await supplierOrderService.updateSupplierOrder(supplierOrder.value!);

      Get.snackbar(
        'Succès',
        'Statut mis à jour avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour le statut',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Réceptionner des articles
  Future<void> receiveItems() async {
    Get.snackbar(
      'Info',
      'Fonctionnalité de réception en cours de développement',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  /// Modifier la commande
  void editOrder() {
    Get.snackbar(
      'Info',
      'Fonctionnalité de modification en cours de développement',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  /// Supprimer la commande
  Future<void> deleteOrder() async {
    if (supplierOrder.value == null) return;

    try {
      await supplierOrderService.deleteSupplierOrder(supplierOrder.value!.id!);

      Get.snackbar(
        'Succès',
        'Commande supprimée avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer la commande',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
