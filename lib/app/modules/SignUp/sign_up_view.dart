import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  SignUpView({super.key}) {
    Get.lazyPut(() => SignUpView());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Header avec logo et titre
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSpacings.l, vertical: AppSpacings.l),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppSpacings.xxxl),
                    Container(
                      padding: EdgeInsets.all(AppSpacings.l),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        AppIcons.store,
                        size: 50,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppSpacings.l),
                    Text(
                      'Créer votre compte',
                      style: AppTypography.displayLarge.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.s),
                    Text(
                      'Rejoignez notre communauté',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.xxxl),
                  ],
                ),
              ),

              // Formulaire
              Container(
                padding: EdgeInsets.all(AppSpacings.xl),
                child: Form(
                  key: GlobalKey<FormState>(),
                  child: Column(
                    children: [
                      _buildFormField(
                        controller: controller.nameController,
                        label: 'Nom complet',
                        hint: 'Entrez votre nom complet',
                        icon: AppIcons.person,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacings.l),

                      _buildFormField(
                        controller: controller.emailController,
                        label: 'Adresse email',
                        hint: 'exemple@email.com',
                        icon: AppIcons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          if (!value.contains('@')) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacings.l),

                      _buildFormField(
                        controller: controller.passwordController,
                        label: 'Mot de passe',
                        hint: 'Minimum 8 caractères',
                        icon: AppIcons.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          }
                          if (value.length < 8) {
                            return 'Le mot de passe doit contenir au moins 8 caractères';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacings.l),

                      _buildFormField(
                        controller: controller.confirmPasswordController,
                        label: 'Confirmer le mot de passe',
                        hint: 'Répétez votre mot de passe',
                        icon: AppIcons.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez confirmer votre mot de passe';
                          }
                          if (value != controller.passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacings.xxxl),

                      // Checkbox des termes
                      Container(
                        padding: EdgeInsets.all(AppSpacings.l),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greyLight.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: GetBuilder<SignUpController>(
                        builder: (_) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: controller.termsAccepted
                                      ? AppColors.primaryColor
                                      : AppColors.greyLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Checkbox(
                              value: controller.termsAccepted,
                              onChanged: (bool? value) {
                                controller.termsAccepted = value ?? false;
                                controller.update();
                              },
                                  activeColor: AppColors.primaryColor,
                                  checkColor: AppColors.textOnPrimary,
                                ),
                              ),
                              SizedBox(width: AppSpacings.s),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    children: [
                                      TextSpan(text: 'J\'accepte les '),
                                      TextSpan(
                                        text: 'Termes et Conditions',
                                        style: TextStyle(
                                color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacings.xxxl),

                      // Bouton d'inscription
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.signUp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacings.l,
                              horizontal: AppSpacings.l,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                AppIcons.person,
                                color: AppColors.textOnPrimary,
                                size: 24,
                              ),
                              SizedBox(width: AppSpacings.s),
                              Text(
                                'Créer un compte',
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.textOnPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacings.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.backgroundWhite,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacings.l,
            vertical: AppSpacings.m,
          ),
          labelStyle: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: AppColors.greyMedium,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
