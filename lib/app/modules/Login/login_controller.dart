import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/controller/customerService.dart';
import 'package:flutter_application_1/app/data/controller/userServices.dart';
import 'package:flutter_application_1/app/data/storage.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_application_1/app/routes/app_pages.dart';

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
      Get.snackbar(
        'Connexion Google',
        'Fonctionnalité en cours de développement',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.textOnPrimary,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la connexion avec Google',
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.textOnPrimary,
      );
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      // TODO: Implémenter la connexion Facebook
      Get.snackbar(
        'Connexion Facebook',
        'Fonctionnalité en cours de développement',
        backgroundColor: Color(0xFF1877F2),
        colorText: AppColors.textOnPrimary,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la connexion avec Facebook',
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.textOnPrimary,
      );
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs',
          backgroundColor: AppColors.errorColor);
      return;
    }
    final user = await userService.getUserByEmail(email);
    if (user == null) {
      Get.snackbar('Erreur', 'Aucun utilisateur trouvé avec cet email');
      return;
    }
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    if (user.passwordHash != passwordHash) {
      Get.snackbar('Erreur', 'Mot de passe incorrect');
      return;
    }
    // Succès : naviguer vers le dashboard
    Get.snackbar('Succès', 'Connexion réussie',
        backgroundColor: AppColors.accentColor);
    Get.offAllNamed(Routes.DASHBOARD);
  }
}
