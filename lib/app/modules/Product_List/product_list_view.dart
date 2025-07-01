import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  ProductListView({super.key}) {
    Get.lazyPut(() => ProductListController());
  }
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
          Expanded(
              child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(tabs: [
                        Tab(
                          text: "Tous (${controller.products.length})",
                        ),
                        Tab(
                          text:
                              "Stock (${controller.products.where((p) => p.stock > 0 && p.stock < 10).length})",
                        ),
                        Tab(
                          text:
                              "Rupture (${controller.products.where((p) => p.stock == 0).length})",
                        )
                      ]),
                      Expanded(
                        child: TabBarView(children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.products.length,
                              itemBuilder: (context, index) {
                                final product = controller.products[index];
                                return _buildProductCard(product);
                              },
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
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.products.length,
                              itemBuilder: (context, index) {
                                final product = controller.products[index];
                                return _buildProductCard(product);
                              },
                            ),
                          ),
                        ]),
                      )
                    ],
                  ))),
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
