import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/storage.dart';
import '../../data/controller/supplierService.dart';

class ReceptionController extends GetxController {
  final supplierOrder = Rxn<SupplierOrder>();
  final orderItems = <SupplierOrderItem>[].obs;
  final isLoading = false.obs;
  final receptionComment = ''.obs;
  final validationHistory = <Map<String, dynamic>>[].obs; // {date, user, details}

  late final SupplierOrderService supplierOrderService;
  late final Isar isar;

  @override
  void onInit() {
    super.onInit();
    isar = Get.find<Isar>();
    supplierOrderService = SupplierOrderService(isar);
    _loadOrder();
  }

  void _loadOrder() async {
    isLoading.value = true;
    final orderId = Get.arguments as int?;
    if (orderId == null) {
      Get.snackbar('Erreur', 'Commande non trouvée');
      isLoading.value = false;
      return;
    }
    final order = await isar.supplierOrders.get(orderId);
    if (order == null) {
      Get.snackbar('Erreur', 'Commande non trouvée');
      isLoading.value = false;
      return;
    }
    await order.supplierLink.load();
    await order.supplierOrderItems.load();
    for (final item in order.supplierOrderItems) {
      await item.productLink.load();
    }
    supplierOrder.value = order;
    orderItems.assignAll(order.supplierOrderItems);
    isLoading.value = false;
  }

  void updateReceivedQty(int index, String value) {
    final qty = int.tryParse(value) ?? 0;
    orderItems[index].quantityReceived = qty;
    orderItems.refresh();
  }

  void incrementQty(int index) {
    final item = orderItems[index];
    item.quantityReceived = (item.quantityReceived ?? 0) + 1;
    orderItems.refresh();
  }

  void updateLotNumber(int index, String value) {
    orderItems[index].lotNumber = value;
    orderItems.refresh();
  }
  void updateExpirationDate(int index, DateTime? value) {
    orderItems[index].expirationDate = value;
    orderItems.refresh();
  }
  void updateItemComment(int index, String value) {
    orderItems[index].comment = value;
    orderItems.refresh();
  }
  void updateReceptionComment(String value) {
    receptionComment.value = value;
  }

  String getStatus(SupplierOrderItem item) {
    final ordered = item.quantityOrdered ?? 0;
    final received = item.quantityReceived ?? 0;
    if (received == 0) return 'missing';
    if (received < ordered) return 'partial';
    return 'complete';
  }

  Future<bool> canValidateReception() async {
    // Validation stricte : aucune quantité reçue ne doit dépasser la quantité commandée
    for (final item in orderItems) {
      if ((item.quantityReceived ?? 0) > (item.quantityOrdered ?? 0)) {
        return false;
      }
    }
    return true;
  }

  Future<void> validateReception({bool force = false}) async {
    isLoading.value = true;
    try {
      bool canValidate = await canValidateReception();
      if (!canValidate && !force) {
        Get.snackbar('Erreur', 'Une quantité reçue dépasse la quantité commandée. Corrigez ou validez en forçant.');
        isLoading.value = false;
        return;
      }
      for (final item in orderItems) {
        await supplierOrderService.receiveSupplierOrderItems(
          supplierOrderItemId: item.id!,
          quantityReceived: item.quantityReceived ?? 0,
        );
        // Enregistre les infos de lot/commentaire dans la base si besoin (à faire dans le service si tu veux persister)
        await isar.writeTxn(() async {
          await isar.supplierOrderItems.put(item);
        });
      }
      // Enregistre le commentaire global
      if (supplierOrder.value != null) {
        supplierOrder.value!.receptionComment = receptionComment.value;
        await isar.writeTxn(() async {
          await isar.supplierOrders.put(supplierOrder.value!);
        });
      }
      // Historique local (à persister si besoin)
      validationHistory.add({
        'date': DateTime.now(),
        'user': 'Utilisateur', // Remplace par l'utilisateur réel si besoin
        'details': 'Réception validée',
      });
      _loadOrder();
      Get.snackbar('Succès', 'Réception enregistrée et stock mis à jour', backgroundColor: Get.theme.colorScheme.secondary, colorText: Get.theme.colorScheme.onSecondary);
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la validation', backgroundColor: Get.theme.colorScheme.error, colorText: Get.theme.colorScheme.onError);
    }
    isLoading.value = false;
  }
}
