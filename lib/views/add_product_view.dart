import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau Produit'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.xxxl),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _imageSelection(),
              SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du produit',
                  // hintText: 'Ex: T-shirt en coton',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Décrivez le produit en détail...',
                ),
              ),
              SizedBox(height: AppSpacings.xxxl),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Prix ',
                        hintText: '0.00',
                        prefixText: 'fcfa ',
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacings.xxxl),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stock initial',
                        hintText: '0',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  hintText: 'Ex: Vêtements, Électronique',
                ),
              ),
              const SizedBox(height: AppSpacings.xxxl),

              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(labelText: 'SKU (Optionnel)'),
              ),
              SizedBox(height: AppSpacings.xxxl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: AppSpacings.xxxl),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.defaultRadius,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produit enregistré !')),
                      );
                    }
                  },
                  child: Text(
                    'Enregistrer le Produit',
                    style: AppTypography.titleMedium.apply(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour la section d'upload d'image
  Widget _imageSelection() {
    return GestureDetector(
      onTap: () {
        // Log
      },
      child: Container(
        height: AppSpacings.xxxxl * 5,
        width: AppSpacings.xxxxl * 9,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.greyDark,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: AppRadius.defaultRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.camera,
              size: AppSpacings.xxxxl * 3,
              color: AppColors.greyDark,
            ),
            const SizedBox(height: AppSpacings.xxxl),
            Text('Ajouter une image', style: AppTypography.titleMedium),
          ],
        ),
      ),
    );
  }
}
