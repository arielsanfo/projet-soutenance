import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sale {
  final String id;
  final String client;
  final String date;
  final double amount;
  final bool isPaid;

  Sale({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.isPaid,
  });
}

class HistoryController extends GetxController {
    late TabController tabController;
  final TextEditingController searchController = TextEditingController();
  List<Sale> sales = [];
  List<Sale> filteredSales = [];

  // @override
  // void initState() {
  //   tabController = TabController(length: 3, vsync: this);
  //   loadSales(); // Simule le chargement des données
  //       // super.initState();

  // }

  void loadSales() {
    // Données simulées
    sales = [
      Sale(id: '202400125', client: 'A. Dupont', date: '05 Mai 2024, 14:30', amount: 35.50, isPaid: true),
      Sale(id: '202400124', client: 'B. Martin', date: '04 Mai 2024, 10:15', amount: 42.80, isPaid: false),
      Sale(id: '202400123', client: 'C. Leroy', date: '03 Mai 2024, 16:45', amount: 19.99, isPaid: true),
    ];
    filteredSales = sales;
  }

  void filterSales(String query) {
    // setState(() {
      filteredSales = sales.where((sale) =>
          sale.id.contains(query) || sale.client.toLowerCase().contains(query.toLowerCase())).toList();
    // });
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
