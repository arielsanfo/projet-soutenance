import 'package:flutter/material.dart';
import '../../lib/helpers/app_constante.dart';
// import 'package:flutter_application_1/views/login_view.dart';
import 'profile_view.dart';

class SignView extends StatefulWidget {
  const SignView({super.key});

  @override
  State<SignView> createState() => _SignViewState();
}

class _SignViewState extends State<SignView> {
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: AppSpacings.xxxl),
              Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                  child: Text(
                    textAlign: TextAlign.left,
                    'Creer votre compte',
                    style: AppTypography.displayLarge,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(AppSpacings.xl),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'nom complet',

                          prefixIcon: Icon(
                            AppIcons.person,
                            color: AppColors.greyDark,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: AppSpacings.xl),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'entrer email',
                          prefixIcon: Icon(AppIcons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: AppSpacings.xl),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'mot de passe',
                          prefixIcon: Icon(AppIcons.password),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: AppSpacings.xl),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'confirmer votre mot de passe',
                          prefixIcon: Icon(AppIcons.password),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: AppSpacings.xxxl),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _termsAccepted = value ?? false;
                              });
                            },
                          ),
                          Text('j\' accepte les '),
                          Text(
                            'Termes et Contidions',
                            style: AppTypography.bodySmall.apply(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacings.xxxxl),

                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) => ProfileScreen(),
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
                              borderRadius: AppRadius.defaultRadius,
                            ),
                          ),
                          child: Text(
                            ' Creer un compte ',
                            style: AppTypography.titleLarge.apply(
                              color: AppColors.backgroundLight,
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
