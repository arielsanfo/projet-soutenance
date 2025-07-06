import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  SettingsView({super.key}) {
    Get.lazyPut(() => SettingsController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(AppIcons.settings, color: AppColors.primaryColor, size: 24),
            ),
            SizedBox(width: AppSpacings.m),
            Text('Paramètres', style: AppTypography.titleLarge.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(AppIcons.backArrow, color: AppColors.primaryColor, size: 20),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Général
            _buildSectionCard(
              icon: Icons.store,
              title: 'Général',
              subtitle: 'Configuration de base',
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.store,
                  label: 'Nom du commerce',
                  value: controller.shopName.value,
                  onTap: () => _editShopName(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  context,
                  icon: Icons.language,
                  label: 'Langue',
                  value: controller.language.value,
                  onTap: () => _selectLanguage(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  context,
                  icon: Icons.attach_money,
                  label: 'Devise',
                  value: controller.currency.value,
                  onTap: () => _selectCurrency(context),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),

            // Section Apparence
            _buildSectionCard(
              icon: Icons.palette,
              title: 'Apparence',
              subtitle: 'Personnalisation de l\'interface',
              children: [
                _buildSwitchSetting(
                  context,
                  icon: Icons.dark_mode,
                  label: 'Mode sombre',
                  subtitle: 'Activer le thème sombre',
                  value: controller.darkMode.value,
                  onChanged: controller.toggleDarkMode,
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),

            // Section Notifications
            _buildSectionCard(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Gérer les alertes et notifications',
              children: [
                _buildSwitchSetting(
                  context,
                  icon: Icons.shopping_cart,
                  label: 'Notifications des ventes',
                  subtitle: 'Recevoir des alertes pour chaque vente',
                  value: controller.salesNotifications.value,
                  onChanged: controller.toggleSalesNotifications,
                ),
                _buildDivider(),
                _buildSwitchSetting(
                  context,
                  icon: Icons.inventory,
                  label: 'Alertes de stock faible',
                  subtitle: 'Être notifié quand le stock est bas',
                  value: controller.lowStockAlerts.value,
                  onChanged: controller.toggleLowStockAlerts,
                ),
                _buildDivider(),
                _buildSwitchSetting(
                  context,
                  icon: Icons.email,
                  label: 'Notifications par email',
                  subtitle: 'Recevoir des rapports par email',
                  value: controller.emailNotifications.value,
                  onChanged: controller.toggleEmailNotifications,
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),

            // Section Données
            _buildSectionCard(
              icon: Icons.storage,
              title: 'Données',
              subtitle: 'Gestion des données et sauvegardes',
              children: [
                _buildSwitchSetting(
                  context,
                  icon: Icons.backup,
                  label: 'Sauvegarde automatique',
                  subtitle: 'Sauvegarder automatiquement les données',
                  value: controller.autoBackup.value,
                  onChanged: controller.toggleAutoBackup,
                ),
                _buildDivider(),
                _buildSettingItem(
                  context,
                  icon: Icons.download,
                  label: 'Exporter les paramètres',
                  onTap: controller.exportSettings,
                ),
                _buildDivider(),
                _buildSettingItem(
                  context,
                  icon: Icons.refresh,
                  label: 'Réinitialiser les paramètres',
                  onTap: () => _showResetConfirmation(context),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),

            // Section Informations
            _buildSectionCard(
              icon: Icons.info,
              title: 'Informations',
              subtitle: 'À propos de l\'application',
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.info,
                  label: 'Version de l\'application',
                  value: controller.appVersion,
                ),
                _buildDivider(),
                _buildInfoItem(
                  context,
                  icon: Icons.calendar_today,
                  label: 'Date de compilation',
                  value: controller.buildDate,
                ),
                _buildDivider(),
                _buildInfoItem(
                  context,
                  icon: Icons.storage,
                  label: 'Taille de l\'application',
                  value: controller.appSize,
                ),
                _buildDivider(),
                _buildSettingItem(
                  context,
                  icon: Icons.privacy_tip,
                  label: 'Politique de confidentialité',
                  onTap: () => _showPrivacyPolicy(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  context,
                  icon: Icons.description,
                  label: 'Conditions d\'utilisation',
                  onTap: () => _showTerms(context),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.xxxl),
          ],
        ),
      )),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                SizedBox(width: AppSpacings.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onTap != null ? AppColors.primaryColor.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.s),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20),
        ),
        title: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: value != null
            ? Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.greyMedium,
                ),
              )
            : null,
        trailing: onTap != null
            ? Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchSetting(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.s),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20),
        ),
        title: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.greyMedium,
                ),
              )
            : null,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          activeTrackColor: AppColors.primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.s),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.greyMedium.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.greyMedium, size: 20),
        ),
        title: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        subtitle: Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.greyMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacings.s),
      child: Divider(
        color: AppColors.greyLight,
        height: 1,
      ),
    );
  }

  // Méthodes pour les actions
  Future<void> _editShopName(BuildContext context) async {
    final textController = TextEditingController(text: controller.shopName.value);
    
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.store, color: AppColors.primaryColor),
            SizedBox(width: AppSpacings.s),
            Text('Modifier le nom du commerce'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Entrez le nouveau nom de votre commerce',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacings.m),
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nom du commerce',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.greyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                Navigator.pop(context, textController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Sauvegarder'),
          ),
        ],
      ),
    );
    
    if (newName != null) {
      await controller.updateShopName(newName);
    }
  }

  Future<void> _selectCurrency(BuildContext context) async {
    final currencies = [
      'Euro (€)',
      'Dollar (\$)',
      'Livre (£)',
      'Yen (¥)',
      'Franc CFA (CFA)',
    ];
    
    final selectedCurrency = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.attach_money, color: AppColors.primaryColor),
            SizedBox(width: AppSpacings.s),
            Text('Sélectionner la devise'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) => _buildCurrencyOption(context, currency)).toList(),
        ),
      ),
    );
    
    if (selectedCurrency != null) {
      await controller.updateCurrency(selectedCurrency);
    }
  }

  Widget _buildCurrencyOption(BuildContext context, String currency) {
    final isSelected = controller.currency.value == currency;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: AppColors.primaryColor, width: 2)
            : Border.all(color: AppColors.greyLight),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.s),
        title: Text(
          currency,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.primaryColor : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: AppColors.primaryColor)
            : null,
        onTap: () => Navigator.pop(context, currency),
      ),
    );
  }

  Future<void> _selectLanguage(BuildContext context) async {
    final languages = [
      'Français',
      'English',
      'Español',
      'Deutsch',
    ];
    
    final selectedLanguage = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.language, color: AppColors.primaryColor),
            SizedBox(width: AppSpacings.s),
            Text('Sélectionner la langue'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) => _buildLanguageOption(context, language)).toList(),
        ),
      ),
    );
    
    if (selectedLanguage != null) {
      await controller.updateLanguage(selectedLanguage);
    }
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    final isSelected = controller.language.value == language;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: AppColors.primaryColor, width: 2)
            : Border.all(color: AppColors.greyLight),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.s),
        title: Text(
          language,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.primaryColor : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: AppColors.primaryColor)
            : null,
        onTap: () => Navigator.pop(context, language),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: AppSpacings.s),
            Text('Réinitialiser les paramètres'),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir réinitialiser tous les paramètres ? Cette action ne peut pas être annulée.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.resetSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.privacy_tip, color: AppColors.primaryColor),
            SizedBox(width: AppSpacings.s),
            Text('Politique de confidentialité'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dernière mise à jour : 15 Janvier 2024',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.greyMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSpacings.m),
              Text(
                'Votre vie privée est importante pour nous. Cette politique décrit comment nous collectons, utilisons et protégeons vos informations personnelles.',
                style: AppTypography.bodyMedium,
              ),
              SizedBox(height: AppSpacings.m),
              Text(
                '• Nous ne collectons que les données nécessaires au fonctionnement de l\'application\n'
                '• Vos données sont stockées localement sur votre appareil\n'
                '• Nous ne partageons pas vos informations avec des tiers\n'
                '• Vous pouvez supprimer vos données à tout moment',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Compris'),
          ),
        ],
      ),
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.description, color: AppColors.primaryColor),
            SizedBox(width: AppSpacings.s),
            Text('Conditions d\'utilisation'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dernière mise à jour : 15 Janvier 2024',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.greyMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSpacings.m),
              Text(
                'En utilisant cette application, vous acceptez les conditions suivantes :',
                style: AppTypography.bodyMedium,
              ),
              SizedBox(height: AppSpacings.m),
              Text(
                '• L\'application est fournie "en l\'état" sans garantie\n'
                '• Vous êtes responsable de la sauvegarde de vos données\n'
                '• L\'utilisation commerciale est autorisée\n'
                '• Nous nous réservons le droit de modifier ces conditions',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Accepter'),
          ),
        ],
      ),
    );
  }
}