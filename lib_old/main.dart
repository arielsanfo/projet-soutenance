import 'package:flutter/material.dart';
import 'views/detail_product_view.dart';
import 'views/login_view.dart';
import 'views/stock_view.dart';
// import 'package:flutter_application_1/views/details_sale_view2.dart';
// import 'package:flutter_application_1/views/inventory_view.dart';
// import 'package:flutter_application_1/views/list_client_view.dart';
// import 'package:flutter_application_1/views/login_view.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
      home: LoginView(),
    );
  }
}
