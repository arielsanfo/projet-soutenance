import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';
import 'package:flutter_application_1/views/new_salescreen_view.dart';

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
      price: "4.50/U",
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
      price: "3.50f/kg",
      initial: "P",
    ),
    Product(
      name: "Eau Minérale 1L",
      category: "Boissons",
      stock: 24,
      price: "0.80f/U",
      initial: "E",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Liste des Produits'),
        actions: [
          IconButton(
            icon:  Icon(AppIcons.list),
            onPressed: () {
              //
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacings.l),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un produit, SKU...",
                hintStyle: TextStyle(color: AppColors.greyMedium),
                prefixIcon: Icon(AppIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: AppSpacings.s),
              ),
            ),
          ),
          SizedBox(
            height: AppSpacings.xxxl * 1.5,

            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(child: _buildTabButton(0, "Tous", _products.length)),
                Flexible(
                  child: _buildTabButton(
                    1,
                    "Stock Bas",
                    _products.where((p) => p.stock > 0 && p.stock < 10).length,
                  ),
                ),
                Flexible(
                  child: _buildTabButton(
                    2,
                    "HorsStock",
                    _products.where((p) => p.stock == 0).length,
                  ),
                ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewSaleScreen()),
          );
        },
        icon: Icon(AppIcons.add),
        label: Text('Ajouter un Produit'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.backgroundWhite,
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
                fontWeight:
                    _selectedTab == index ? FontWeight.bold : FontWeight.normal,
                fontSize: AppTypography.fontSizeSmall,
                color:
                    _selectedTab == index
                        ? AppColors.primaryColor
                        : Colors.grey,
              ),
            ),
            SizedBox(height: AppSpacings.xxs),
            if (_selectedTab == index)
              Container(height: AppSpacings.m, color: AppColors.secondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacings.m,
        vertical: AppSpacings.s,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForInitial(product.initial),
          child: Text(
            product.initial,
            style: AppTypography.titleMedium.apply(
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
        title: Text(product.name, style: AppTypography.titleSmall),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.category),

            Row(
              children: [
                Text("Stock : ", style: TextStyle(color: AppColors.greyDark)),
                Text(
                  product.stock.toString(),
                  style: TextStyle(
                    color:
                        product.stock == 0
                            ? AppColors.errorColor
                            : product.stock < 10
                            ? AppColors.tagOrangeText
                            : AppColors.tagGreenText,
                  ),
                ),
                Spacer(),
                Text(
                  "Prix : ${product.price}",
                  style: AppTypography.titleSmall,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(AppIcons.arrow_forward, size: AppSpacings.xxl),
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
