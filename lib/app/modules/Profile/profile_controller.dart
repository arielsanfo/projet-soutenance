import 'package:get/get.dart';
import '../../data/storage.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../data/controller/userServices.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// import '../Product_List/product_list_view.dart';

class ProfileController extends GetxController {
  User? currentUser;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late final UserService userService;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    currentUser = Get.arguments as User?;
    if (currentUser != null) {
      nameController.text = currentUser!.name ?? '';
      emailController.text = currentUser!.email ?? '';
    }
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

  Future<void> logout() async {
    // Efface l'utilisateur courant et redirige vers la page de login
    currentUser = null;
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty) {
      Get.snackbar('Erreur', 'Nom et email sont obligatoires');
      return;
    }
    if (password.isNotEmpty && password != confirmPassword) {
      Get.snackbar('Erreur', 'Les mots de passe ne correspondent pas');
      return;
    }
    // Vérifier unicité de l'email si modifié
    if (email != currentUser?.email) {
      final existingUser = await userService.getUserByEmail(email);
      if (existingUser != null) {
        Get.snackbar('Erreur', 'Cet email est déjà utilisé');
        return;
      }
    }
    // Mettre à jour l'utilisateur
    currentUser?.name = name;
    currentUser?.email = email;
    if (password.isNotEmpty) {
      currentUser?.passwordHash =
          sha256.convert(utf8.encode(password)).toString();
    }
    try {
      await userService.saveUser(currentUser!);
      Get.snackbar('Succès', 'Profil mis à jour');
      // Mettre à jour les champs affichés
      update();
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la mise à jour');
    }
  }
}
