import 'package:isar/isar.dart';
import '../storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Added for SnackBar

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Utilisateurs (UserService)
//----------------------------------------------------------------------------//
class UserService {
  final Isar isar;

  UserService(this.isar);

  /// Créer ou mettre à jour un utilisateur.
  /// Le hachage du mot de passe doit être effectué avant d'appeler cette méthode.
  Future<User> saveUser(User user) async {
    await isar.writeTxn(() async {
      user.updatedAt = DateTime.now();
      await isar.users.put(user);
    });
    return user;
  }

  /// Obtenir un utilisateur par son email (pour la connexion).
  Future<User?> getUserByEmail(String email) async {
    return await isar.users.where().emailEqualTo(email).findFirst();
  }

  /// Obtenir un utilisateur par son ID.
  Future<User?> getUserById(Id id) async {
    return await isar.users.get(id);
  }

  /// Obtenir tous les utilisateurs.
  Future<List<User>> getAllUsers() async {
    return await isar.users.where().findAll();
  }

  /// Supprimer un utilisateur.
  Future<bool> deleteUser(Id id) async {
    // Attention: Pensez aux implications si l'utilisateur est lié à d'autres données.
    return await isar.writeTxn(() async {
      return await isar.users.delete(id);
    });
  }

  // --- Gestion de la Session ---

  /// Sauvegarder la session de l'utilisateur connecté
  Future<void> saveUserSession(User user) async {
    print('=== SAUVEGARDE SESSION ===');
    print('Sauvegarde session pour: ${user.name} (${user.email})');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setInt('user_id', user.id!);
    await prefs.setString('user_email', user.email!);
    await prefs.setString('user_name', user.name!);
    await prefs.setString('user_role', user.role!.name);
    await prefs.setString('login_date', DateTime.now().toIso8601String());
    
    print('Session sauvegardée avec succès');
  }

  /// Récupérer l'utilisateur connecté depuis la session
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    print('=== RÉCUPÉRATION UTILISATEUR ===');
    print('user_id dans SharedPreferences: $userId');
    
    if (userId != null) {
      final user = await getUserById(userId);
      print('Utilisateur récupéré: ${user != null}');
      return user;
    }
    return null;
  }

  /// Vérifier si un utilisateur est connecté
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    print('=== VÉRIFICATION SESSION ===');
    print('is_logged_in dans SharedPreferences: $isLoggedIn');
    
    if (isLoggedIn) {
      // Vérifier que l'utilisateur existe toujours dans la base
      final user = await getCurrentUser();
      print('Utilisateur trouvé dans la base: ${user != null}');
      if (user != null) {
        print('Détails utilisateur: ${user.name} (${user.email})');
      }
      return user != null;
    }
    return false;
  }

  /// Effacer la session utilisateur (déconnexion)
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_role');
    await prefs.remove('login_date');
  }

  /// Obtenir les informations de session (pour affichage)
  Future<Map<String, dynamic>?> getSessionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (!isLoggedIn) return null;

    return {
      'user_id': prefs.getInt('user_id'),
      'user_email': prefs.getString('user_email'),
      'user_name': prefs.getString('user_name'),
      'user_role': prefs.getString('user_role'),
      'login_date': prefs.getString('login_date'),
    };
  }
}

//----------------------------------------------------------------------------//
// SERVICE DE NOTIFICATION DE SESSION (SessionNotificationService)
//----------------------------------------------------------------------------//
class SessionNotificationService {
  /// Notifier l'utilisateur de la connexion automatique
  static void notifyAutoLogin(String userName) {
    Get.snackbar(
      'Connexion automatique',
      'Bon retour, $userName ! Vous êtes automatiquement connecté.',
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    );
  }

  /// Notifier l'utilisateur de la déconnexion
  static void notifyLogout() {
    Get.snackbar(
      'Déconnexion',
      'Vous avez été déconnecté avec succès.',
      backgroundColor: Colors.orange[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(
        Icons.logout,
        color: Colors.white,
      ),
    );
  }

  /// Notifier l'utilisateur d'une session expirée
  static void notifySessionExpired() {
    Get.snackbar(
      'Session expirée',
      'Votre session a expiré. Veuillez vous reconnecter.',
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(
        Icons.warning,
        color: Colors.white,
      ),
    );
  }

  /// Notifier l'utilisateur d'une connexion réussie
  static void notifyLoginSuccess(String userName) {
    Get.snackbar(
      'Connexion réussie',
      'Bienvenue, $userName !',
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    );
  }

  /// Notifier l'utilisateur d'une erreur de connexion
  static void notifyLoginError(String message) {
    Get.snackbar(
      'Erreur de connexion',
      message,
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
    );
  }
}

//----------------------------------------------------------------------------//
// GESTIONNAIRE DE SESSION GLOBAL (SessionManager) - AMÉLIORÉ
//----------------------------------------------------------------------------//
class SessionManager {
  static UserService? _userService;
  static bool _isInitialized = false;
  
  /// Initialiser le gestionnaire de session
  static void init() {
    if (_isInitialized) return;
    print('=== INITIALISATION SESSION MANAGER ===');
    try {
      final isar = Get.find<Isar>();
      _userService = UserService(isar);
      _isInitialized = true;
      print('SessionManager initialisé avec succès');
    } catch (e) {
      print('Erreur lors de l\'initialisation du SessionManager: $e');
    }
  }
  
  /// Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    if (!_isInitialized) {
      print('SessionManager non initialisé, tentative d\'initialisation...');
      init();
    }
    
    if (_userService == null) {
      print('UserService non disponible');
      return false;
    }
    
    return await _userService!.isUserLoggedIn();
  }
  
  /// Obtenir l'utilisateur connecté actuellement
  static Future<User?> getCurrentUser() async {
    if (!_isInitialized) init();
    if (_userService == null) return null;
    return await _userService!.getCurrentUser();
  }
  
  /// Sauvegarder la session d'un utilisateur
  static Future<void> saveSession(User user) async {
    if (!_isInitialized) init();
    if (_userService == null) {
      print('Erreur: UserService non disponible pour sauvegarder la session');
      return;
    }
    await _userService!.saveUserSession(user);
  }
  
  /// Effacer la session (déconnexion)
  static Future<void> clearSession() async {
    if (!_isInitialized) init();
    if (_userService == null) return;
    await _userService!.clearUserSession();
  }
  
  /// Obtenir les informations de session
  static Future<Map<String, dynamic>?> getSessionInfo() async {
    if (!_isInitialized) init();
    if (_userService == null) return null;
    return await _userService!.getSessionInfo();
  }
  
  /// Vérifier si l'utilisateur a un rôle spécifique
  static Future<bool> hasRole(UserRoleIsar role) async {
    final user = await getCurrentUser();
    return user?.role == role;
  }
  
  /// Obtenir le nom de l'utilisateur connecté
  static Future<String?> getUserName() async {
    final user = await getCurrentUser();
    return user?.name;
  }
  
  /// Obtenir l'email de l'utilisateur connecté
  static Future<String?> getUserEmail() async {
    final user = await getCurrentUser();
    return user?.email;
  }

  /// Vérifier et nettoyer la session si nécessaire
  static Future<bool> validateSession() async {
    final userLoggedIn = await isLoggedIn();
    if (!userLoggedIn) {
      await clearSession();
      return false;
    }
    return true;
  }

  /// Rafraîchir la session (utile pour prolonger la session)
  static Future<void> refreshSession() async {
    final user = await getCurrentUser();
    if (user != null) {
      await saveSession(user);
    }
  }
}

//----------------------------------------------------------------------------//
// MIDDLEWARE DE SESSION (SessionMiddleware)
//----------------------------------------------------------------------------//
class SessionMiddleware extends GetMiddleware {
  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    // Routes qui ne nécessitent pas d'authentification
    final publicRoutes = [
      '/splash',
      '/login',
      '/sign-up',
    ];
    
    // Si c'est une route publique, permettre l'accès
    if (publicRoutes.contains(route.currentPage?.name)) {
      return await super.redirectDelegate(route);
    }
    
    // Vérifier si l'utilisateur est connecté
    final isLoggedIn = await SessionManager.isLoggedIn();
    
    if (!isLoggedIn) {
      // L'utilisateur n'est pas connecté, rediriger vers la page de login
      return GetNavConfig.fromRoute('/login');
    }
    
    // L'utilisateur est connecté, permettre l'accès
    return await super.redirectDelegate(route);
  }
  
  @override
  void onPageDispose() {
    // Nettoyer les ressources si nécessaire
    super.onPageDispose();
  }
}

//----------------------------------------------------------------------------//
// GESTIONNAIRE D'AUTHENTIFICATION (AuthGuard)
//----------------------------------------------------------------------------//
class AuthGuard {
  /// Vérifier si l'utilisateur peut accéder à une route spécifique
  static Future<bool> canAccess(String route) async {
    // Routes publiques
    final publicRoutes = [
      '/splash',
      '/login',
      '/sign-up',
    ];
    
    if (publicRoutes.contains(route)) {
      return true;
    }
    
    // Pour les routes protégées, vérifier la session
    return await SessionManager.isLoggedIn();
  }
  
  /// Rediriger vers la page appropriée selon l'état de connexion
  static Future<String> getInitialRoute() async {
    final isLoggedIn = await SessionManager.isLoggedIn();
    
    if (isLoggedIn) {
      return '/dashboard';
    } else {
      return '/login';
    }
  }
  
  /// Forcer la déconnexion et rediriger vers login
  static Future<void> forceLogout() async {
    await SessionManager.clearSession();
    Get.offAllNamed('/login');
  }
}
