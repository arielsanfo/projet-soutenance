import 'package:get/get.dart';

class SettingsController extends GetxController {
   String shopName = "Mon Magasin V1";
  String currency = "Euro (€)";
  bool darkMode = false;
  bool salesNotifications = true;
  bool lowStockAlerts = true;

  final count = 0.obs;

  void toggleDarkMode(bool value) {
    darkMode = value;
    update();
  }   



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

  void toggleSalesNotifications(bool value) {
    salesNotifications = value;
    update();
  }

  void toggleLowStockAlerts(bool value) {
    lowStockAlerts = value;
    update();
  }
}
