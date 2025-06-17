import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'supplier_list_controller.dart';

class SupplierListView extends GetView<SupplierListController> {
  const SupplierListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fournisseurs', style: AppTypography.titleLarge),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacings.l),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.searchSuppliers,
              decoration: InputDecoration(
                hintText: 'Rechercher un fournisseur...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.l),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              itemCount: controller.filteredSuppliers.length,
              itemBuilder: (context, index) {
                final supplier = controller.filteredSuppliers[index];
                return Card(
                  color: AppColors.backgroundLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.l),
                  ),
                  margin: EdgeInsets.only(bottom: AppSpacings.l),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(AppSpacings.l),
                    leading: Icon(
                      supplier.type == 'distribution'
                          ? Icons.local_shipping
                          : Icons.business,
                      color: AppColors.primaryColor,
                      size: AppSpacings.xxl,
                    ),
                    title: Text(
                      supplier.name,
                      style: AppTypography.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Produits: ${supplier.products}',
                          style: TextStyle(
                            color: AppColors.greyDark,
                            fontSize: AppSpacings.m * 1.5,
                          ),
                        ),
                        SizedBox(height: AppSpacings.s),
                        Text(
                          supplier.contact,
                          style: AppTypography.bodyMedium.apply(
                            color: AppColors.greyMedium,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add, color: AppColors.textOnPrimary),
              label: Text(
                'Ajouter Fournisseur',
                style: AppTypography.bodyLarge.apply(
                  color: AppColors.textOnPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.l),
                ),
              ),
              onPressed: () {
                Get.toNamed(Routes.ADD_SUPPLIER);
              },
            ),
          ),
        ],
      ),
    );
  }
}
