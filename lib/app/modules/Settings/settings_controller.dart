import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  // Variables observables pour les paramètres
  final shopName = "Mon Magasin V1".obs;
  final currency = "Euro (€)".obs;
  final darkMode = false.obs;
  final salesNotifications = true.obs;
  final lowStockAlerts = true.obs;
  final emailNotifications = false.obs;
  final autoBackup = true.obs;
  final language = "Français".obs;

  // Clés pour SharedPreferences
  static const String _shopNameKey = 'shop_name';
  static const String _currencyKey = 'currency';
  static const String _darkModeKey = 'dark_mode';
  static const String _salesNotificationsKey = 'sales_notifications';
  static const String _lowStockAlertsKey = 'low_stock_alerts';
  static const String _emailNotificationsKey = 'email_notifications';
  static const String _autoBackupKey = 'auto_backup';
  static const String _languageKey = 'language';

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// Charger les paramètres depuis SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      shopName.value = prefs.getString(_shopNameKey) ?? "Mon Magasin V1";
      currency.value = prefs.getString(_currencyKey) ?? "Euro (€)";
      darkMode.value = prefs.getBool(_darkModeKey) ?? false;
      salesNotifications.value = prefs.getBool(_salesNotificationsKey) ?? true;
      lowStockAlerts.value = prefs.getBool(_lowStockAlertsKey) ?? true;
      emailNotifications.value = prefs.getBool(_emailNotificationsKey) ?? false;
      autoBackup.value = prefs.getBool(_autoBackupKey) ?? true;
      language.value = prefs.getString(_languageKey) ?? "Français";
      
      update();
    } catch (e) {
      print('Erreur lors du chargement des paramètres: $e');
    }
  }

  /// Sauvegarder les paramètres dans SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_shopNameKey, shopName.value);
      await prefs.setString(_currencyKey, currency.value);
      await prefs.setBool(_darkModeKey, darkMode.value);
      await prefs.setBool(_salesNotificationsKey, salesNotifications.value);
      await prefs.setBool(_lowStockAlertsKey, lowStockAlerts.value);
      await prefs.setBool(_emailNotificationsKey, emailNotifications.value);
      await prefs.setBool(_autoBackupKey, autoBackup.value);
      await prefs.setString(_languageKey, language.value);
      
      print('Paramètres sauvegardés avec succès');
    } catch (e) {
      print('Erreur lors de la sauvegarde des paramètres: $e');
    }
  }

  /// Mettre à jour le nom du commerce
  Future<void> updateShopName(String newName) async {
    if (newName.isNotEmpty && newName != shopName.value) {
      shopName.value = newName;
      await _saveSettings();
      update();
      _showSuccessMessage('Nom du commerce mis à jour');
    }
  }

  /// Mettre à jour la devise
  Future<void> updateCurrency(String newCurrency) async {
    if (newCurrency != currency.value) {
      currency.value = newCurrency;
      await _saveSettings();
      update();
      _showSuccessMessage('Devise mise à jour');
    }
  }

  /// Basculer le mode sombre
  Future<void> toggleDarkMode(bool value) async {
    darkMode.value = value;
    await _saveSettings();
    update();
    _showSuccessMessage(value ? 'Mode sombre activé' : 'Mode sombre désactivé');
  }

  /// Basculer les notifications de ventes
  Future<void> toggleSalesNotifications(bool value) async {
    salesNotifications.value = value;
    await _saveSettings();
    update();
    _showSuccessMessage(value ? 'Notifications de ventes activées' : 'Notifications de ventes désactivées');
  }

  /// Basculer les alertes de stock faible
  Future<void> toggleLowStockAlerts(bool value) async {
    lowStockAlerts.value = value;
    await _saveSettings();
    update();
    _showSuccessMessage(value ? 'Alertes de stock activées' : 'Alertes de stock désactivées');
  }

  /// Basculer les notifications par email
  Future<void> toggleEmailNotifications(bool value) async {
    emailNotifications.value = value;
    await _saveSettings();
    update();
    _showSuccessMessage(value ? 'Notifications email activées' : 'Notifications email désactivées');
  }

  /// Basculer la sauvegarde automatique
  Future<void> toggleAutoBackup(bool value) async {
    autoBackup.value = value;
    await _saveSettings();
    update();
    _showSuccessMessage(value ? 'Sauvegarde automatique activée' : 'Sauvegarde automatique désactivée');
  }

  /// Mettre à jour la langue
  Future<void> updateLanguage(String newLanguage) async {
    if (newLanguage != language.value) {
      language.value = newLanguage;
      await _saveSettings();
      update();
      _showSuccessMessage('Langue mise à jour');
    }
  }

  /// Réinitialiser tous les paramètres
  Future<void> resetSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Recharger les valeurs par défaut
      await _loadSettings();
      
      _showSuccessMessage('Paramètres réinitialisés');
    } catch (e) {
      print('Erreur lors de la réinitialisation: $e');
      _showErrorMessage('Erreur lors de la réinitialisation');
    }
  }

  /// Exporter les paramètres
  Future<void> exportSettings() async {
    try {
      final settings = {
        'shopName': shopName.value,
        'currency': currency.value,
        'darkMode': darkMode.value,
        'salesNotifications': salesNotifications.value,
        'lowStockAlerts': lowStockAlerts.value,
        'emailNotifications': emailNotifications.value,
        'autoBackup': autoBackup.value,
        'language': language.value,
        'exportDate': DateTime.now().toIso8601String(),
      };
      
      // Ici vous pourriez implémenter l'export vers un fichier
      print('Paramètres exportés: $settings');
      _showSuccessMessage('Paramètres exportés avec succès');
    } catch (e) {
      _showErrorMessage('Erreur lors de l\'export');
    }
  }

  /// Afficher un message de succès
  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Succès',
      message,
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  /// Afficher un message d'erreur
  void _showErrorMessage(String message) {
    Get.snackbar(
      'Erreur',
      message,
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.error, color: Colors.white),
    );
  }

  /// Obtenir la version de l'application
  String get appVersion => '1.0.0';

  /// Obtenir la date de compilation
  String get buildDate => '2024-01-15';

  /// Obtenir la taille de l'application
  String get appSize => '15.2 MB';
}
