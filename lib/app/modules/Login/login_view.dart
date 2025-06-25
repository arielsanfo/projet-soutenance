import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../../../helpers/app_constante.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key}) {
    Get.lazyPut(() => LoginController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
              // Header avec logo et titre
                  Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSpacings.xl, vertical: AppSpacings.xxxxl),
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
                      padding: EdgeInsets.all(AppSpacings.xl),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(40),
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
                        size: 40,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  SizedBox(height: AppSpacings.xxl),
                  Text(
                      'CommercePro',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacings.xs),
                    Text(
                      'Votre gestion commerciale simplifiée',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacings.xxl),
                  ],
                ),
              ),

              // Formulaire de connexion
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(AppSpacings.xl),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                return 'Email invalide';
                              }
                              return null;
                            },
                          ),
                        SizedBox(height: AppSpacings.xxl),

                        _buildPasswordField(
                            controller: controller.passwordController,
                          label: 'Mot de passe',
                          hint: 'Entrez votre mot de passe',
                          icon: AppIcons.lock,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                              }
                              return null;
                            },
                        ),
                        SizedBox(height: AppSpacings.xxxl),

                        // Bouton de connexion
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                            child: ElevatedButton(
                            onPressed: () {
                              controller.login();
                            },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                vertical: AppSpacings.m,
                                horizontal: AppSpacings.l,
                                ),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.login,
                                  color: AppColors.textOnPrimary,
                                  size: 22,
                                ),
                                SizedBox(width: AppSpacings.s),
                                Text(
                                  'Se connecter',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.textOnPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacings.m),

                        // Bouton d'inscription
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                            child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.SIGN_UP);
                            },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundWhite,
                                padding: EdgeInsets.symmetric(
                                vertical: AppSpacings.m,
                                horizontal: AppSpacings.l,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  AppIcons.person,
                                  color: AppColors.primaryColor,
                                  size: 22,
                                ),
                                SizedBox(width: AppSpacings.s),
                                Text(
                                  'S\'inscrire',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacings.l),
                           TextButton(
                          onPressed: () {
                            // TODO: Implémenter la récupération de mot de passe
                          },
                          child: Text(
                            'Mot de passe oublié ?',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Séparateur
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.greyLight,
                              ),
                            ),
                       
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.greyLight,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacings.xxxl),

                        // Boutons de connexion sociale
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    controller.signInWithGoogle();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.backgroundWhite,
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacings.s,
                                      horizontal: AppSpacings.s,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  icon: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                              child: Text(
                                        'G',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: Text(
                                    'Google',
                                    style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacings.m),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                              onPressed: () {
                                    controller.signInWithFacebook();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(0xFF1877F2), // Couleur Facebook
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacings.s,
                                      horizontal: AppSpacings.s,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  icon: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Center(
                              child: Text(
                                        'f',
                                        style: TextStyle(
                                          color: Color(0xFF1877F2),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: Text(
                                    'Facebook',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textOnPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacings.xxxl),

                        // Lien mot de passe oublié
                     
                      ],
                                ),
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
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
            borderRadius: BorderRadius.circular(10),
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
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: AppColors.greyMedium,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
      child: GetBuilder<LoginController>(
        builder: (controller) => TextFormField(
          controller: controller.passwordController,
          obscureText: controller.obscurePassword,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                controller.togglePasswordVisibility();
              },
              icon: Icon(
                controller.obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.textSecondary,
              ),
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
      ),
    );
  }
}
