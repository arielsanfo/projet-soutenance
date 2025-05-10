import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';

class ProductManagementApp extends StatelessWidget {
  const ProductManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Produits',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.backgroundWhite,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: AppTypography.titleLarge
          
        ),
      ),
      home: const ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _selectedTab = 0;
  final List<Product> _products = [
    Product(
      name: "Pommes Gala Bio",
      category: "Fruits",
      stock: 56,
      price: "2.99f/kg",
      initial: "P",
    ),
    Product(
      name: "Savon Artisanal Lavande",
      category: "Hygiène",
      stock: 12,
      price: "4.50/unité",
      initial: "S",
    ),
    Product(
      name: "Lait Demi-écrémé",
      category: "Produits laitiers",
      stock: 8,
      price: "1.20/L",
      initial: "L",
    ),
    Product(
      name: "Pain Complet",
      category: "Boulangerie",
      stock: 0,
      price: "3.50€/kg",
      initial: "P",
    ),
    Product(
      name: "Eau Minérale 1L",
      category: "Boissons",
      stock: 24,
      price: "0.80€/unité",
      initial: "E",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits'),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un produit, SKU...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                _buildTabButton(0, "Tous", _products.length),
                _buildTabButton(1, "Stock Bas", _products.where((p) => p.stock > 0 && p.stock < 10).length),
                _buildTabButton(2, "Hors Stock", _products.where((p) => p.stock == 0).length),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un Produit'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTabButton(int index, String label, int count) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Column(
          children: [
            Text(
              "$label ($count)",
              style: TextStyle(
                fontWeight: _selectedTab == index ? FontWeight.bold : FontWeight.normal,
                color: _selectedTab == index ? Colors.purple : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedTab == index)
              Container(
                height: 3,
                color: Colors.purple,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForInitial(product.initial),
          child: Text(
            product.initial,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.category),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "Stock : ",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  product.stock.toString(),
                  style: TextStyle(
                    color: product.stock == 0
                        ? Colors.red
                        : product.stock < 10
                            ? Colors.orange
                            : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "Prix : ${product.price}",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Color _getColorForInitial(String initial) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[initial.codeUnitAt(0) % colors.length];
  }
}

class Product {
  final String name;
  final String category;
  final int stock;
  final String price;
  final String initial;

  Product({
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.initial,
  });
}