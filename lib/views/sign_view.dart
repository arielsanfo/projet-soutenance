import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante%5B1%5D.dart';
import 'package:flutter_application_1/views/login_view.dart';

class SignView extends StatefulWidget {
  const SignView({super.key});

  @override
  State<SignView> createState() => _SignViewState();
}

class _SignViewState extends State<SignView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                  child: Text(
                    textAlign: TextAlign.left,
                    'Creer votre compte',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 30,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: AppColors.primaryDarker
                ),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'nom complet',
                          prefixIcon: Icon(Icons.admin_panel_settings),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'entrer email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'mot de passe',
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'confirmer votre mot de passe',
                          prefixIcon: Icon(Icons.confirmation_number),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('j accepte les '),
                          Text(
                            'Termes et Contidions',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 70),

                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) =>  LoginView(),
                              ),
                            );
                            //
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 60,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            ' Creer un compte ',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 20,
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
    );
  }
}
