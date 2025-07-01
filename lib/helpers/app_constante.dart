import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore_for_file: constant_identifier_names

// Ce fichier contient les constantes de l'application CommercePro.
// Il est conçu pour centraliser les valeurs de design (couleurs, typographie, espacements)
// et les clés de stockage afin d'assurer la cohérence et la maintenabilité de l'application.

//----------------------------------------------------------------------------//
// COULEURS (Colors)
//----------------------------------------------------------------------------//
// Basé sur la palette de app_design_mockups_v1

class AppColors {
  static const Color primaryColor = Color(
    0xFF6C63FF,
  ); // Violet principal (Dribbble-like)
  static const Color primaryDarker = Color(
    0xFF574FD8,
  ); // Variante plus foncée pour :hover
  static const Color primaryLight = Color(
    0xFFE8EAF3,
  ); // Variante claire pour fonds secondaires ou boutons

  static const Color secondaryColor = Color(
    0xFF4A55A2,
  ); // Bleu-violet pour titres principaux

  static const Color accentColor = Color(
    0xFF00C48C,
  ); // Un vert pour les succès ou accents positifs (non utilisé dans les maquettes mais utile)
  static const Color errorColor = Color(
    0xFFDE350B,
  ); // Rouge pour erreurs et alertes
  static const Color warningColor = Color(
    0xFFFF8B00,
  ); // Orange pour avertissements

  // Couleurs de Texte
  static const Color textPrimary = Color(0xFF1A202C); // Texte principal foncé
  static const Color textSecondary = Color(
    0xFF4A5568,
  ); // Texte secondaire, sous-titres
  static const Color textLight = Color(
    0xFF718096,
  ); // Texte plus clair, placeholders
  static const Color textOnPrimary =
      Colors.white; // Texte sur fond primaire (boutons)
  static const Color textLink = Color(
    0xFF6C63FF,
  ); // Couleur pour les liens texte

  // Couleurs de Fond
  static const Color backgroundLight = Color(
    0xFFF7F8FC,
  ); // Fond général de l'application
  static const Color backgroundWhite =
      Colors.white; // Fond pour cartes, modales, etc.
  static const Color backgroundInput = Color(
    0xFFF7F8FC,
  ); // Fond pour les champs de saisie

  // Couleurs de Bordure
  static const Color borderLight = Color(0xFFE8EAF3); // Bordure légère
  static const Color borderMedium = Color(0xFFD1D5DB); // Bordure moyenne

  // Couleurs pour les Tags/Badges (basé sur les maquettes)
  static const Color tagGreenBackground = Color(0xFFE6F7F0);
  static const Color tagGreenText = Color(0xFF00875A);
  static const Color tagOrangeBackground = Color(0xFFFFF4E6);
  static const Color tagOrangeText = Color(0xFFFF8B00);
  static const Color tagBlueBackground = Color(0xFFE7F3FF);
  static const Color tagBlueText = Color(0xFF0052CC);
  static const Color tagRedBackground = Color(0xFFFFEBE6);
  static const Color tagRedText = Color(0xFFDE350B);

  // Couleurs neutres (gris)
  static const Color greyLight = Color(0xFFF0F2F5);
  static const Color greyMedium = Color(0xFFA0AEC0);
  static const Color greyDark = Color(0xFF2D3748);

  static const Color successColor = Colors.green;
}

//----------------------------------------------------------------------------//
// TYPOGRAPHIE (Typography)
//----------------------------------------------------------------------------//
// Police principale: Inter (doit être ajoutée dans pubspec.yaml et assets)

class AppTypography {
  static const String fontFamily = 'Inter';

  // Tailles de police
  static const double fontSizeXXSmall =
      10.0; // Très petite taille (ex: légendes discrètes)
  static const double fontSizeXSmall =
      12.0; // Petite taille (ex: sous-titres, métadonnées)
  static const double fontSizeSmall =
      14.0; // Taille standard pour le corps du texte
  static const double fontSizeMedium =
      16.0; // Taille pour titres de section, emphase
  static const double fontSizeLarge = 18.0; // Grands titres
  static const double fontSizeXLarge = 20.0; // Titres principaux d'écran
  static const double fontSizeXXLarge = 24.0; // Titres très importants, H1
  static const double fontSizeXXXLarge =
      28.0; // Titres d'application ou de page d'accueil

  // Poids de la police
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // Styles de texte prédéfinis (à utiliser avec TextStyle)
  // Exemple: Text('Mon Titre', style: AppTypography.headline1)

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXXXLarge,
    fontWeight: fontWeightBold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXXLarge,
    fontWeight: fontWeightBold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXLarge,
    fontWeight: fontWeightBold,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    // Équivalent à .screen-main-title ou .sketch-header
    fontFamily: fontFamily,
    fontSize: fontSizeXLarge, // ou fontSizeLarge selon l'importance
    fontWeight: fontWeightBold,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    // Pour les titres de section
    fontFamily: fontFamily,
    fontSize: fontSizeMedium,
    fontWeight: fontWeightSemiBold,
    color: AppColors.textSecondary,
  );

  static const TextStyle titleSmall = TextStyle(
    // Pour les titres de list-item
    fontFamily: fontFamily,
    fontSize: fontSizeSmall, // ou 0.95rem -> ~15px
    fontWeight: fontWeightSemiBold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMedium,
    fontWeight: fontWeightRegular,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    // Corps de texte standard
    fontFamily: fontFamily,
    fontSize: fontSizeSmall, // 0.9rem -> ~14px
    fontWeight: fontWeightRegular,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    // Pour sous-titres de list-item, métadonnées
    fontFamily: fontFamily,
    fontSize: fontSizeXSmall, // 0.8rem -> ~13px
    fontWeight: fontWeightRegular,
    color: AppColors.textLight,
  );

  static const TextStyle labelLarge = TextStyle(
    // Pour les boutons
    fontFamily: fontFamily,
    fontSize: fontSizeSmall, // 0.95rem -> ~15px
    fontWeight: fontWeightSemiBold,
    color: AppColors.textOnPrimary, // Par défaut, peut être surchargé
  );

  static const TextStyle labelMedium = TextStyle(
    // Pour les labels de champs, tags
    fontFamily: fontFamily,
    fontSize: fontSizeXSmall, // 0.75rem pour tags -> 12px
    fontWeight: fontWeightMedium,
    color: AppColors.textSecondary,
  );
}

//----------------------------------------------------------------------------//
// ESPACEMENTS (Spacings) & TAILLES (Sizes)
//----------------------------------------------------------------------------//
// Utilisés pour les marges (margin), espacements internes (padding), et tailles fixes.

class AppSpacings {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m =
      12.0; // Gap standard dans les maquettes (16px) est un peu grand, ajustons
  static const double l = 16.0; // Padding standard dans sketch-content (20px)
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double xxxxl =
      40.0; // Gap entre maquettes (50px), padding global (50px)

  // Padding standard pour les écrans
  static const EdgeInsets screenPadding = EdgeInsets.all(l); // 16.0
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: l,
  );
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(
    vertical: xl,
  ); // 20.0

  // Padding pour les cartes et conteneurs
  static const EdgeInsets cardPadding = EdgeInsets.all(m); // 12.0 ou l (16.0)

  // Padding pour les boutons
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: l,
    vertical: m,
  ); // 14px vertical, 20px horizontal
}

//----------------------------------------------------------------------------//
// RAYONS DE BORDURE (Border Radius)
//----------------------------------------------------------------------------//

class AppRadius {
  static const double rSmall = 4.0;
  static const double rMedium = 8.0;
  static const double rDefault =
      10.0; // Pour inputs, boutons (10px dans maquette)
  static const double rLarge = 12.0; // Pour les cartes (12px dans maquette)
  static const double rXLarge = 16.0;
  static const double rCircular = 50.0; // Pour avatars, éléments circulaires
  static const double rMax = 30.0; // Pour le phone-sketch (30px)

  static BorderRadiusGeometry get small => BorderRadius.circular(rSmall);
  static BorderRadiusGeometry get medium => BorderRadius.circular(rMedium);
  static BorderRadiusGeometry get defaultRadius =>
      BorderRadius.circular(rDefault);
  static BorderRadiusGeometry get large => BorderRadius.circular(rLarge);
  static BorderRadiusGeometry get circular => BorderRadius.circular(rCircular);
  static BorderRadiusGeometry get max => BorderRadius.circular(rMax);
}

//----------------------------------------------------------------------------//
// ICÔNES (Icons)
//----------------------------------------------------------------------------//
// Utiliser les icônes Material ou Cupertino, ou des SVGs personnalisés.
// Ceci est une liste indicative basée sur les maquettes.

class AppIcons {
  // Navigation & Actions générales
  static const IconData backArrow = Icons.arrow_back_ios_new;
  static const IconData close = Icons.close;
  static const IconData add = Icons.add_circle_outline; // ou Icons.add
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData settings = Icons.settings_outlined;
  static const IconData moreVert = Icons.more_vert;
  static const IconData angleRight =
      Icons.arrow_forward_ios; // Utilisé pour list-item-action

  // Authentification
  static const IconData email = Icons.email_outlined;
  static const IconData password =
      Icons.lock_outlined; // ou Icons.visibility_off_outlined
  static const IconData person = Icons.person_outline;
  static const IconData store =
      Icons.store_mall_directory_outlined; // Pour le logo CommercePro

  // Menu principal / Accueil
  static const IconData home = Icons.home_outlined;
  static const IconData newSale =
      Icons.point_of_sale_outlined; // ou Icons.add_shopping_cart
  static const IconData products =
      Icons.inventory_2_outlined; // ou Icons.widgets_outlined
  static const IconData orders = Icons.receipt_long_outlined;
  static const IconData customers = Icons.people_alt_outlined;
  static const IconData reports = Icons.bar_chart_outlined;
  static const IconData inventory =
      Icons.inventory_outlined; // Pour gestion inventaire
  static const IconData suppliers =
      Icons.local_shipping_outlined; // ou Icons.groups_2_outlined

  // Produits & Inventaire
  static const IconData category =
      Icons.category_outlined; // ou Icons.label_outlined
  static const IconData lowStock =
      Icons.warning_amber_rounded; // ou Icons.notification_important_outlined
  static const IconData barcode = Icons.qr_code_scanner_outlined;
  static const IconData image = Icons.image_outlined;
  static const IconData stockMovementIn = Icons.arrow_downward_outlined;
  static const IconData stockMovementOut = Icons.arrow_upward_outlined;
  static const IconData stockAdjustment =
      Icons.build_outlined; // ou Icons.tune_outlined
  static const IconData stockTake = Icons.checklist_rtl_outlined;
  static const IconData lock = Icons.lock_clock;

  // Ventes & Commandes
  static const IconData cart = Icons.shopping_cart_outlined;
  static const IconData receipt = Icons.receipt_outlined;
  static const IconData payment = Icons.credit_card_outlined;
  static const IconData invoice =
      Icons.article_outlined; // ou Icons.description_outlined
  static const IconData truck =
      Icons.local_shipping_outlined; // Pour fournisseurs ou expédition
  static const IconData packageIcon =
      Icons.inventory_2_outlined; // ou Icons.all_inbox

  // Clients & Utilisateurs
  static const IconData userShield = Icons.shield_outlined; // Pour rôle admin
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData debt =Icons.money_off_csred_outlined; // ou Icons.request_quote_outlined
  static const IconData refresh =Icons.refresh; // ou Icons.request_quote_outlined

  // Divers
  static const IconData notification = Icons.notifications_none_outlined;
  static const IconData notificationActive =Icons.notifications_active_outlined;
  static const IconData print = Icons.print_outlined;
  static const IconData download = Icons.download_outlined;
  static const IconData upload = Icons.upload_outlined;
  static const IconData link = Icons.link_outlined;
  static const IconData help = Icons.help_outline_outlined;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData success = Icons.check_circle_outline_rounded;
  static const IconData error = Icons.highlight_off_rounded;
  static const IconData warningTriangle =Icons.warning_amber_rounded; // fas fa-exclamation-triangle
  static const IconData returnArrow = Icons.undo_outlined; // fas fa-undo
  static const IconData tagIcon = Icons.local_offer_outlined; // fas fa-tag
  static const IconData wineBottle =Icons.wine_bar_outlined; // fas fa-wine-bottle
  static const IconData lightbulb = Icons.lightbulb_outline; // fas fa-lightbulb
  static const IconData palette = Icons.palette_outlined; // fas fa-palette
  static const IconData globe = Icons.language_outlined; // fas fa-globe
  static const IconData storeAlt = Icons.storefront_outlined; // fas fa-store-alt
  static const IconData usersCog =Icons.manage_accounts_outlined; // fas fa-users-cog
  static const IconData leaf = Icons.eco_outlined; // fas fa-leaf
  static const IconData camera = Icons.camera_alt_sharp; // fas fa-leaf
  static const IconData chart = Icons.show_chart; // fas fa-leaf
  static const IconData warning = Icons.warning; // fas fa-leaf
  static const IconData arrow = Icons.arrow_forward_ios; // fas fa-leaf
  static const IconData list = Icons.filter_list; // fas fa-leaf
  static const IconData arrow_forward = Icons.arrow_forward_ios; // fas fa-leaf
  static const IconData credit_card = Icons.credit_card; // fas fa-leaf
  static const IconData ript = Icons.receipt; // fas fa-leaf
  static const IconData chevron_right = Icons.chevron_right; // fas fa-leaf
  static const IconData swap_horiz = Icons.swap_horiz; // fas fa-leaf
  static const IconData checklist_rtl = Icons.checklist_rtl; // fachecklist_rtls fa-leaf
  static const IconData build = Icons.build; // fachecklist_rtls fa-leaf
  static const IconData arrow_update = Icons.arrow_upward;

  // Icônes manquantes ajoutées
  static const IconData location = Icons.location_on_outlined;
  static const IconData sales = Icons.point_of_sale_outlined;
  static const IconData phone = Icons.phone_outlined;
  static const IconData save = Icons.save_outlined;
  static const IconData money = Icons.attach_money;
  static const IconData contact = Icons.contact_phone_outlined;
  static const IconData business = Icons.business_outlined;
}

//----------------------------------------------------------------------------//
// CLÉS DE STOCKAGE LOCAL (Local Storage Keys)
//----------------------------------------------------------------------------//
// Utilisées pour SharedPreferences, Hive, ou autre solution de stockage local.

class LocalStorageKeys {
  // Authentification
  static const String authToken = 'auth_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userRole = 'user_role';
  static const String lastLoginTimestamp = 'last_login_timestamp';

  // Préférences Utilisateur
  static const String appTheme = 'app_theme'; // 'light', 'dark', 'system'
  static const String appLanguage = 'app_language'; // 'fr', 'en'
  static const String areNotificationsEnabled = 'are_notifications_enabled';

  // Données de l'entreprise (si stockées localement pour accès rapide)
  static const String companyName = 'company_name';
  static const String companyLogoUrl = 'company_logo_url'; // Ou chemin local

  // Cache
  static const String cachedProductsTimestamp = 'cached_products_timestamp';
  static const String cachedCategoriesTimestamp = 'cached_categories_timestamp';
  // Ajoutez d'autres clés de cache si nécessaire
}

//----------------------------------------------------------------------------//
// DURÉES (Durations)
//----------------------------------------------------------------------------//
// Pour animations, timeouts, etc.

class AppDurations {
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration splashScreenDuration = Duration(seconds: 2);
}

//----------------------------------------------------------------------------//
// AUTRES CONSTANTES (Other Constants)
//----------------------------------------------------------------------------//

class AppConstants {
  static const String appName = 'CommercePro';
  static const String appVersion =
      '1.0.0'; // Gérer via build runner si possible
  static const int itemsPerPage = 20; // Pour la pagination des listes
  static const double defaultAspectRatio = 16 / 9;
  static const int maxImageFileSizeMB = 5; // Limite pour l'upload d'images
}

//----------------------------------------------------------------------------//
// UTILITAIRES POUR SNACKBARS ET NOTIFICATIONS
//----------------------------------------------------------------------------//

class AppSnackbars {
  /// Afficher un snackbar de succès
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.successColor,
      colorText: AppColors.textOnPrimary,
      duration: AppDurations.snackbarDuration,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(AppSpacings.m),
      borderRadius: AppRadius.rDefault,
      icon: Icon(
        AppIcons.success,
        color: AppColors.textOnPrimary,
        size: 24,
      ),
    );
  }

  /// Afficher un snackbar d'erreur
  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.errorColor,
      colorText: AppColors.textOnPrimary,
      duration: AppDurations.snackbarDuration,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(AppSpacings.m),
      borderRadius: AppRadius.rDefault,
      icon: Icon(
        AppIcons.error,
        color: AppColors.textOnPrimary,
        size: 24,
      ),
    );
  }

  /// Afficher un snackbar d'avertissement
  static void showWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warningColor,
      colorText: AppColors.textOnPrimary,
      duration: AppDurations.snackbarDuration,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(AppSpacings.m),
      borderRadius: AppRadius.rDefault,
      icon: Icon(
        AppIcons.warningTriangle,
        color: AppColors.textOnPrimary,
        size: 24,
      ),
    );
  }

  /// Afficher un snackbar d'information
  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.textOnPrimary,
      duration: AppDurations.snackbarDuration,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(AppSpacings.m),
      borderRadius: AppRadius.rDefault,
      icon: Icon(
        AppIcons.info,
        color: AppColors.textOnPrimary,
        size: 24,
      ),
    );
  }

  /// Afficher un snackbar de chargement
  static void showLoading(String message) {
    Get.snackbar(
      'Chargement...',
      message,
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.textOnPrimary,
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(AppSpacings.m),
      borderRadius: AppRadius.rDefault,
      icon: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------//
// UTILITAIRES POUR RAFRAÎCHISSEMENT AUTOMATIQUE
//----------------------------------------------------------------------------//

class AppRefreshManager {
  static final Map<String, Function> _refreshCallbacks = {};

  /// Enregistrer un callback de rafraîchissement pour une page
  static void registerRefreshCallback(String pageKey, Function callback) {
    _refreshCallbacks[pageKey] = callback;
  }

  /// Supprimer un callback de rafraîchissement
  static void unregisterRefreshCallback(String pageKey) {
    _refreshCallbacks.remove(pageKey);
  }

  /// Déclencher le rafraîchissement d'une page spécifique
  static void refreshPage(String pageKey) {
    final callback = _refreshCallbacks[pageKey];
    if (callback != null) {
      callback();
    }
  }

  /// Déclencher le rafraîchissement de toutes les pages
  static void refreshAllPages() {
    for (final callback in _refreshCallbacks.values) {
      callback();
    }
  }

  /// Obtenir la liste des pages enregistrées
  static List<String> getRegisteredPages() {
    return _refreshCallbacks.keys.toList();
  }
}

//----------------------------------------------------------------------------//
// CONSTANTES POUR LES CLÉS DE PAGES
//----------------------------------------------------------------------------//

class AppPageKeys {
  static const String supplierList = 'supplier_list';
  static const String clientList = 'client_list';
  static const String productList = 'product_list';
  static const String saleList = 'sale_list';
  static const String orderList = 'order_list';
  static const String inventory = 'inventory';
  static const String dashboard = 'dashboard';
}

// Exemple d'utilisation:
// Container(
//   padding: AppSpacings.screenPadding,
//   color: AppColors.primaryColor,
//   child: Text(
//     'Hello Flutter',
//     style: AppTypography.headline1.copyWith(color: AppColors.textOnPrimary),
//   ),
// );
//
// Icon(AppIcons.home, color: AppColors.accentColor);
//
// final borderRadius = AppRadius.large;
