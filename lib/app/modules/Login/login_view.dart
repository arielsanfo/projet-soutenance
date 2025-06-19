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
      backgroundColor: AppColors.backgroundWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: AppSpacings.xxxl),
                  Container(
                    padding: EdgeInsets.all(AppSpacings.xxxl),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.store,
                      size: AppSpacings.xxxxl,
                      color: AppColors.backgroundLight,
                    ),
                  ),
                  SizedBox(height: AppSpacings.xxxl),
                  Text('CommercePro', style: AppTypography.titleLarge),
                  SizedBox(height: AppSpacings.xxl),
                  Text(
                    'votre gestion commerciale simplifiee',
                    style: AppTypography.titleSmall,
                  ),
                  SizedBox(height: AppSpacings.xxxl),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              labelText: 'adresse email',
                              prefixIcon: Icon(
                                AppIcons.email,
                                color: AppColors.greyDark,
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
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
                          SizedBox(height: AppSpacings.xxxl),
                          TextFormField(
                            controller: controller.passwordController,
                            decoration: InputDecoration(
                              labelText: 'mot de passe',
                              hintStyle: TextStyle(color: AppColors.textLight),
                              prefixIcon: Icon(
                                AppIcons.lock,
                                color: AppColors.greyDark,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  //    setState(() {
                                  //   _obscurePassword = !_obscurePassword;
                                  // });
                                },
                                icon: Icon(
                                  controller.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            obscureText: controller.obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'veuillez entrer votre mot de passe';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSpacings.xxxxl),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 88,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.defaultRadius,
                                ),
                              ),
                              child: Text(
                                'Se connecter',
                                style: AppTypography.titleMedium.apply(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              onPressed: () {
                                Get.toNamed(
                                  Routes.DASHBOARD,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: AppSpacings.xxxl),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundWhite,
                                padding: EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 90,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.defaultRadius,
                                ),
                              ),
                              child: Text(
                                '  S \'inscrire  ',
                                style: AppTypography.titleMedium.apply(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.SIGN_UP);
                              },
                            ),
                          ),
                          SizedBox(height: AppSpacings.xxxl),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                //
                              },
                              child: Text(
                                'mot de passe oublie ?',
                                style: AppTypography.titleSmall.apply(
                                  color: AppColors.errorColor,
                                ),
                              ),
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
        ),
      ),
    );
  }
}
