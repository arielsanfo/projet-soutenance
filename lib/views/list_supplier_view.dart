import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';
// import 'package:flutter_application_1/views/add_product_view.dart';
import 'package:flutter_application_1/views/add_supplier_view.dart';
// import 'package:flutter_application_1/views/details_order_view.dart';

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

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final List<Supplier> _suppliers = [
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

  final TextEditingController _searchController = TextEditingController();
  List<Supplier> _filteredSuppliers = [];

  @override
  void initState() {
    _filteredSuppliers = _suppliers;
    super.initState();
  }

  void _searchSuppliers(String query) {
    setState(() {
      _filteredSuppliers =
          _suppliers
              .where(
                (supplier) =>
                    supplier.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

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
              controller: _searchController,
              onChanged: _searchSuppliers,
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
              itemCount: _filteredSuppliers.length,
              itemBuilder: (context, index) {
                final supplier = _filteredSuppliers[index];
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSupplierScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
