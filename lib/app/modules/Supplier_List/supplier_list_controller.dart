import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Supplier {
  final String name;
  final String products;
  final String contact;
  final String type;

  Supplier({
    required this.name,
    required this.products,
    required this.contact,
    required this.type,
  });
}

class SupplierListController extends GetxController {

  final List<Supplier> suppliers = [
    Supplier(
      name: 'BioFrais Distribution',
      products: 'Fruits & Légumes Bio',
      contact: 'contact@biofrais.com | 04 00 00 00 00',
      type: 'distribution',
    ),
    Supplier(
      name: 'Artisanat Local SARL',
      products: 'Produits artisanaux',
      contact: 'contact@artisanat.com | 05 00 00 00 00',
      type: 'entreprise',
    ),
  ];

  final TextEditingController searchController = TextEditingController();
  List<Supplier> filteredSuppliers = [];

  // @override
  // void initState() {
  //   filteredSuppliers = suppliers;
  //   // super.initState();
  // }

  void searchSuppliers(String query) {
    // setState(() {
    //   filteredSuppliers = suppliers
    //       .where(
    //         (supplier) =>
    //             supplier.name.toLowerCase().contains(query.toLowerCase()),
    //       )
    //       .toList();
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
