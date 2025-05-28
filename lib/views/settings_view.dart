import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';



class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Variables pour les paramètres modifiables
  String _shopName = "Mon Magasin V1";
  String _currency = "Euro (€)";
  bool _darkMode = false;
  bool _salesNotifications = true;
  bool _lowStockAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title:  Text(
          'Configuration',
          style: AppTypography.titleLarge,
          
        ),
        centerTitle: true,backgroundColor: AppColors.backgroundWhite,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(AppSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Général
              _buildSectionTitle('Général'),
              _buildSettingItem(
                context,
                label: 'Nom du commerce',
                value: _shopName,
                onTap: () => _editShopName(context),
              ),
              Divider(),
              _buildSettingItem(
                context,
                label: 'Devise',
                value: _currency,
                onTap: () => _selectCurrency(context),
              ),
              Divider(),
              _buildSwitchSetting(
                context,
                label: 'Mode sombre',
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
              SizedBox(height: AppSpacings.l),

              // Section Notifications
              _buildSectionTitle('Notifications'),
              _buildSwitchSetting(
                context,
                label: 'Notifications des ventes',
                value: _salesNotifications,
                onChanged: (value) {
                  setState(() {
                    _salesNotifications = value;
                  });
                },
              ),
              Divider(),
              _buildSwitchSetting(
                context,
                label: 'Alertes de stock faible',
                value: _lowStockAlerts,
                onChanged: (value) {
                  setState(() {
                    _lowStockAlerts = value;
                  });
                },
              ),
              SizedBox(height: AppSpacings.l),

              // Section Informations sur l'application
              _buildSectionTitle('Informations sur l\'application'),
              _buildSettingItem(
                context,
                label: 'Version de l\'application',
                value: 'V1.0.0',
              ),
              Divider(),
              _buildSettingItem(
                context,
                label: 'Politique de confidentialité',
                onTap: () => _showPrivacyPolicy(context),
              ),
              Divider(),
              _buildSettingItem(
                context,
                label: 'Conditions d\'utilisation',
                onTap: () => _showTerms(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding:  EdgeInsets.only(bottom: AppSpacings.s),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: AppTypography.titleMedium.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String label,
    String? value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
              style:  TextStyle(
          fontSize: AppTypography.bodyMedium.fontSize,
        ),
      ),
      subtitle: value != null
          ? Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.bodyMedium.fontSize,
                color: AppColors.greyMedium,
              ),
            )
          : null,
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              size: AppTypography.bodyMedium.fontSize,
              color: AppColors.greyMedium,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchSetting(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style:  TextStyle(
          fontSize: AppTypography.bodyMedium.fontSize,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // Méthodes pour les actions
  Future<void> _editShopName(BuildContext context) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le nom du commerce'),
        content: TextField(
          controller: TextEditingController(text: _shopName),
          autofocus: true,
          decoration:  InputDecoration(
            hintText: 'Entrez le nouveau nom',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _shopName);
            },
            child:  Text('Valider'),
          ),
        ],
      ),
    );

    if (newName != null && newName != _shopName) {
      setState(() {
        _shopName = newName;
      });
    }
  }

  Future<void> _selectCurrency(BuildContext context) async {
    final selectedCurrency = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title:  Text('Sélectionnez une devise'),
        children: [
          _buildCurrencyOption(context, 'Euro (€)'),
          _buildCurrencyOption(context, 'Dollar (\$)'),
          _buildCurrencyOption(context, 'Livre (£)'),
          _buildCurrencyOption(context, 'Yen (¥)'),
        ],
      ),
    );

    if (selectedCurrency != null) {
      setState(() {
        _currency = selectedCurrency;
      });
    }
  }

  Widget _buildCurrencyOption(BuildContext context, String currency) {
    return SimpleDialogOption(
      onPressed: () => Navigator.pop(context, currency),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: AppSpacings.s),
        child: Text(
          currency,
          style: TextStyle(
            color: _currency == currency
                ? Theme.of(context).primaryColor
                : Colors.black,
            fontWeight: _currency == currency ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Politique de confidentialité'),
        content:  SingleChildScrollView(
          child: Text(
            'Texte de la politique de confidentialité...',
            style: TextStyle(fontSize: AppTypography.bodyMedium.fontSize),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Conditions d\'utilisation'),
        content:  SingleChildScrollView(
          child: Text(
            'Texte des conditions d\'utilisation...',
            style: TextStyle(fontSize: AppTypography.bodyMedium.fontSize),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
              child:  Text('Fermer'),
          ),
        ],
      ),
    );
  }
}


// _buildSectionTitle(String title, IconData icon) {
//   return Row(
//     children: [
//       Icon(icon, size: 20),
//       const SizedBox(width: 8),
//       Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//     ],
//   );
// }
// // AnimatedSwitcher(
// //   duration: const Duration(milliseconds: 300),
// //   child: _darkMode 
// //       ? Icon(Icons.dark_mode) 
// //       : Icon(Icons.light_mode),
// // )