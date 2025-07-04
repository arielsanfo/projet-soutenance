import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../data/controller/userServices.dart';
import '../../data/storage.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import '../../../helpers/globalFuction.dart';

class SignUpController extends GetxController {
  // Champs du formulaire
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool termsAccepted = false;
  
  // Sélection du rôle
  UserRoleIsar selectedRole = UserRoleIsar.employee;

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

  // Méthode pour changer le rôle sélectionné
  void setSelectedRole(UserRoleIsar role) {
    selectedRole = role;
    update();
  }

  // Méthode pour obtenir le nom du rôle
  String getRoleName(UserRoleIsar role) {
    switch (role) {
      case UserRoleIsar.admin:
        return 'Administrateur';
      case UserRoleIsar.manager:
        return 'Gestionnaire';
      case UserRoleIsar.employee:
        return 'Employé';
    }
  }

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar('Erreur', 'Tous les champs sont obligatoires', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    if (!email.contains('@')) {
      _showSnackbar('Erreur', 'Email invalide', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    if (password != confirmPassword) {
      _showSnackbar('Erreur', 'Les mots de passe ne correspondent pas', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    if (!termsAccepted) {
      _showSnackbar('Erreur', 'Vous devez accepter les termes et conditions', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    // Vérifier unicité de l'email
    final existingUser = await userService.getUserByEmail(email);
    if (existingUser != null) {
      _showSnackbar('Erreur', 'Cet email est déjà utilisé', SNACKBAR_TYPE.ERROR);
      return;
    }
    
    // Hash du mot de passe (SHA256 simple, à remplacer par bcrypt pour production)
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    final user = User(
      email: email,
      name: name,
      passwordHash: passwordHash,
      role: selectedRole, // Utiliser le rôle sélectionné
    );
    
    try {
      await userService.saveUser(user);
      _showSnackbar('Succès', 'Compte créé avec succès ! Vous pouvez maintenant vous connecter.', SNACKBAR_TYPE.SUCCESS);
      
      // Attendre un peu pour que l'utilisateur voie le message de succès
      await Future.delayed(Duration(seconds: 2));
      
      // Rediriger vers la page de login
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      _showSnackbar('Erreur', 'Erreur lors de la création du compte: ${e.toString()}', SNACKBAR_TYPE.ERROR);
    }
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
