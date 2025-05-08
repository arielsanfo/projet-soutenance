import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante%5B1%5D.dart';
// import 'package:flutter_application_1/views/login_view.dart';
import 'package:flutter_application_1/views/profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'CommercePro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryColor,
          secondary: AppColors.greyMedium,
          surface: AppColors.backgroundWhite,
        ),
        inputDecorationTheme: InputDecorationTheme(
          // filled: true,
          fillColor: AppColors.backgroundInput,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 20),
        ),
      ),
      home: ProfileView(),
    );
  }
}
