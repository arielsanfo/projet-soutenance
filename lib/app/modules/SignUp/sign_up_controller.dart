import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../data/controller/userServices.dart';
import '../../data/storage.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';

class SignUpController extends GetxController {
  // Champs du formulaire
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool termsAccepted = false;

  late final UserService userService;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    userService = UserService(isar);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty ||password.isEmpty ||  confirmPassword.isEmpty) {
      Get.snackbar('Erreur', 'Tous les champs sont obligatoires');
      return;
    }
    if (!email.contains('@')) {
      Get.snackbar('Erreur', 'Email invalide');
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar('Erreur', 'Les mots de passe ne correspondent pas');
      return;
    }
    if (!termsAccepted) {
      Get.snackbar('Erreur', 'Vous devez accepter les termes et conditions');
      return;
    }
    // Vérifier unicité de l'email
    final existingUser = await userService.getUserByEmail(email);
    if (existingUser != null) {
      Get.snackbar('Erreur', 'Cet email est déjà utilisé');
      return;
    }
    // Hash du mot de passe (SHA256 simple, à remplacer par bcrypt pour production)
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    final user = User(
      email: email,
      name: name,
      passwordHash: passwordHash,
      role: UserRoleIsar.employee,
    );
    try {
      await userService.saveUser(user);
      Get.snackbar('Succès', 'Compte créé avec succès');
      // Naviguer vers la page de profil ou login
      Get.offAllNamed(Routes.PROFILE, arguments: user);
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la création du compte');
    }
  }
}
