import 'package:get/get.dart';

class SettingsController extends GetxController {
   String shopName = "Mon Magasin V1";
  String currency = "Euro (€)";
  bool darkMode = false;
  bool salesNotifications = true;
  bool lowStockAlerts = true;

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
