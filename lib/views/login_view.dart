import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';
import 'package:flutter_application_1/views/Dashboard_view.dart';
import 'package:flutter_application_1/views/sign_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
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
                            controller: _passwordController,
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
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            obscureText: _obscurePassword,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(),
                                  ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (BuildContext context) => SignView(),
                                  ),
                                );
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
