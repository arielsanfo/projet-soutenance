import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante%5B1%5D.dart';
import 'package:flutter_application_1/views/sign_view.dart';

import '../customs/app_constante[1].dart';

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
      
      // backgroundColor: Color.lerp(Colors.white, Colors.white, 255),
      body:Padding(
padding: AppSpacings.screenPadding,
    child:    SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(30),
                    
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.defaultRadius
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.category
                      size: AppSpacings.xxxxl * 8,
                      color: AppColors.backgroundInput,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'CommercePro',
                    style: AppTypography.titleMedium.apply(color: AppColors.primaryColor),
                  ),
                  SizedBox(height: AppSpacings.xxxxl),
                  Text(
                    'votre gestion commerciale simplifiee',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.greyMedium,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // color: AppColors.accentColor,
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'adresse email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: AppColors.primaryLight,
                              ),
                              labelStyle: TextStyle(color: AppColors.greyLight),
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
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'mot de passe',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: AppColors.primaryLight,
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
                              labelStyle: TextStyle(color: AppColors.greyLight),
                              // color: AppColors.backgroundWhite
                            ),
                            obscureText: _obscurePassword,
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'veuillez entrer votre mot de passe';
                              }
                            },
                          ),

                          SizedBox(height: 30),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 70,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                  color: AppColors.textOnPrimary,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                //
                              },
                            ),
                          ),
                          SizedBox(height: 25),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundWhite,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 80,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                '  S inscrire  ',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) =>  SignView(),
                              ),
                            );
                              },
                            ),
                          ),
                          SizedBox(height: 25),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                //
                              },
                              child: Text('mot de passe oublie ?'),
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
      )

    );
  }
}

  