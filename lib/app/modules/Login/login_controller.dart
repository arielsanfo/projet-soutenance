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
import 'package:shared_preferences/shared_preferences.dart';

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
      _showSnackbar('Erreur', 'Veuillez remplir tous les champs', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    final user = await userService.getUserByEmail(email);
    if (user == null) {
      _showSnackbar('Erreur', 'Aucun utilisateur trouvé avec cet email', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    if (user.passwordHash != passwordHash) {
      _showSnackbar('Erreur', 'Mot de passe incorrect', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    // Succès : naviguer vers le dashboard
    _showSnackbar('Succès', 'Connexion réussie ! Bienvenue ${user.name}', SNACKBAR_TYPE.SUCCESS);
    
    // Sauvegarder la session utilisateur
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    
    // Attendre un peu pour que l'utilisateur voie le message de succès
    await Future.delayed(Duration(seconds: 1));
    
    Get.offAllNamed(Routes.DASHBOARD);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    Get.offAllNamed(Routes.LOGIN);
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
