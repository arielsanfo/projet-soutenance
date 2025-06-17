import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Produits'),
        actions: [
          IconButton(
            icon: Icon(AppIcons.list),
            onPressed: () {
              Get.toNamed(Routes.DETAILS_PRODUCTS);
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
                Flexible(
                    child:
                        _buildTabButton(0, "Tous", controller.products.length)),
                Flexible(
                  child: _buildTabButton(
                    1,
                    "Stock Bas",
                    controller.products
                        .where((p) => p.stock > 0 && p.stock < 10)
                        .length,
                  ),
                ),
                Flexible(
                  child: _buildTabButton(
                    2,
                    "HorsStock",
                    controller.products.where((p) => p.stock == 0).length,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.ADD_PRODUCT);
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
          // setState(() {
          //   _selectedTab = index;
          // });
        },
        child: Column(
          children: [
            Text(
              "$label ($count)",
              style: TextStyle(
                fontWeight: controller.selectedTab == index
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: AppTypography.fontSizeSmall,
                color: controller.selectedTab == index
                    ? AppColors.primaryColor
                    : Colors.grey,
              ),
            ),
            SizedBox(height: AppSpacings.xxs),
            if (controller.selectedTab == index)
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
                    color: product.stock == 0
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


