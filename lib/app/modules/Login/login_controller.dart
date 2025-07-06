import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/controller/customerService.dart';
import 'package:flutter_application_1/app/data/controller/userServices.dart';
import 'package:flutter_application_1/app/data/storage.dart';
import 'package:flutter_application_1/helpers/globalFuction.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_application_1/app/routes/app_pages.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  Customer currentCustomer =
      Customer(name: '', email: '', phone: '', address: '');

  late final UserService userService;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    userService = UserService(isar);
    CustomerService customerServices = CustomerService(isar);
    customerServices.getCustomerById(100).then((customers) {
      if (customers != null) {
        currentCustomer = customers;
        emailController.text = customers.email ?? "";
        passwordController.text = 'defaultPassword'; // Set a default password
      }
    });
    
    // Vérifier si l'utilisateur est déjà connecté au démarrage
    _checkExistingSession();
  }

  /// Vérifier s'il y a une session existante et informer l'utilisateur
  Future<void> _checkExistingSession() async {
    final isLoggedIn = await SessionManager.isLoggedIn();
    if (isLoggedIn) {
      final userName = await SessionManager.getUserName();
      if (userName != null) {
        // Attendre un peu pour que la page se charge
        await Future.delayed(Duration(milliseconds: 500));
        SessionNotificationService.notifyAutoLogin(userName);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }

  Future<void> signInWithGoogle() async {
    try {
      // TODO: Implémenter la connexion Google
      _showSnackbar('Connexion Google', 'Fonctionnalité en cours de développement', SNACKBAR_TYPE.WARNING);
    } catch (e) {
      _showSnackbar('Erreur', 'Erreur lors de la connexion avec Google', SNACKBAR_TYPE.ERROR);
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      // TODO: Implémenter la connexion Facebook
      _showSnackbar('Connexion Facebook', 'Fonctionnalité en cours de développement', SNACKBAR_TYPE.WARNING);
    } catch (e) {
      _showSnackbar('Erreur', 'Erreur lors de la connexion avec Facebook', SNACKBAR_TYPE.ERROR);
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    
    if (email.isEmpty || password.isEmpty) {
      SessionNotificationService.notifyLoginError('Veuillez remplir tous les champs');
      return;
    }
    
    final user = await userService.getUserByEmail(email);
    if (user == null) {
      SessionNotificationService.notifyLoginError('Aucun utilisateur trouvé avec cet email');
      return;
    }
    
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    if (user.passwordHash != passwordHash) {
      SessionNotificationService.notifyLoginError('Mot de passe incorrect');
      return;
    }
    
    // Succès : sauvegarder la session et naviguer vers le dashboard
    print('=== CONNEXION RÉUSSIE ===');
    print('Sauvegarde de la session pour: ${user.name}');
    
    await SessionManager.saveSession(user);
    
    // Vérifier que la session a été sauvegardée
    final sessionSaved = await SessionManager.isLoggedIn();
    print('Session sauvegardée avec succès: $sessionSaved');
    
    SessionNotificationService.notifyLoginSuccess(user.name ?? 'Utilisateur');
    
    // Attendre un peu pour que l'utilisateur voie le message de succès
    await Future.delayed(Duration(seconds: 1));
    
    Get.offAllNamed(Routes.DASHBOARD);
  }

  Future<void> logout() async {
    print('=== DÉCONNEXION ===');
    await SessionManager.clearSession();
    
    // Vérifier que la session a été effacée
    final sessionCleared = !(await SessionManager.isLoggedIn());
    print('Session effacée avec succès: $sessionCleared');
    
    SessionNotificationService.notifyLogout();
    Get.offAllNamed(Routes.LOGIN);
  }

  /// Méthode de test pour vérifier la persistance de session
  Future<void> testSessionPersistence() async {
    print('=== TEST PERSISTANCE SESSION ===');
    final isLoggedIn = await SessionManager.isLoggedIn();
    print('Session active: $isLoggedIn');
    
    if (isLoggedIn) {
      final user = await SessionManager.getCurrentUser();
      print('Utilisateur connecté: ${user?.name} (${user?.email})');
      
      // Afficher les informations de session
      final sessionInfo = await SessionManager.getSessionInfo();
      print('Informations de session: $sessionInfo');
    }
  }

  /// Vérifier si l'utilisateur est déjà connecté (pour auto-login)
  Future<bool> checkUserSession() async {
    return await SessionManager.isLoggedIn();
  }

  /// Récupérer l'utilisateur connecté actuellement
  Future<User?> getCurrentUser() async {
    return await SessionManager.getCurrentUser();
  }

  /// Valider la session actuelle
  Future<bool> validateCurrentSession() async {
    return await SessionManager.validateSession();
  }

  /// Rafraîchir la session
  Future<void> refreshSession() async {
    await SessionManager.refreshSession();
  }

  // Méthode pour afficher les snackbars avec le style personnalisé
  void _showSnackbar(String title, String message, SNACKBAR_TYPE type) {
    Get.snackbar(
      title,
      message,
      backgroundColor: getSnackbarColor(type),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(
        type == SNACKBAR_TYPE.SUCCESS ? Icons.check_circle : 
        type == SNACKBAR_TYPE.ERROR ? Icons.error : 
        type == SNACKBAR_TYPE.WARNING ? Icons.warning : Icons.info,
        color: Colors.white,
      ),
    );
  }
}
