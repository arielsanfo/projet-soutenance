import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'add_supplier_controller.dart';

class AddSupplierView extends GetView<AddSupplierController> {
  AddSupplierView({super.key}) {
    Get.lazyPut(() => AddSupplierController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header avec design moderne
          Container(
            padding: EdgeInsets.fromLTRB(
                AppSpacings.l, 60, AppSpacings.l, AppSpacings.xxl),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacings.m),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryDarker,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        AppIcons.suppliers,
                        color: AppColors.textOnPrimary,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: AppSpacings.l),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                controller.isEditMode.value
                                    ? 'Modifier Fournisseur'
                                    : 'Ajouter Fournisseur',
                                style: AppTypography.titleLarge,
                              )),
                          SizedBox(height: AppSpacings.xs),
                          Text(
                            'Gérez vos fournisseurs en toute simplicité',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        AppIcons.close,
                        color: AppColors.textLight,
                        size: 24,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Formulaire
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.xl),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: controller.companyController,
                        label: 'Nom de l\'entreprise *',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le nom de l\'entreprise est obligatoire';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.contactController,
                        label: 'Nom du contact principal',
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.emailController,
                        label: 'Email de contact',
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.phoneController,
                        label: 'Téléphone',
                        keyboardType: TextInputType.phone,
                        validator: controller.validatePhone,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.addressController,
                        label: 'Adresse complète',
                        maxLines: 2,
                      ),
                      SizedBox(height: AppSpacings.m),
                      _buildProductSelector(),
                      SizedBox(height: AppSpacings.m),
                      _buildTextField(
                        controller: controller.paymentController,
                        label: 'Conditions de paiement (ex: Net 30)',
                      ),
                      SizedBox(height: AppSpacings.xxl),
                      Obx(() => _buildSaveButton()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelector() {
    return GetBuilder<AddSupplierController>(
      builder: (controller) => Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyLight.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: AppSpacings.l, top: AppSpacings.m),
              child: Text(
                'Produits livrés *',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppSpacings.l),
              child: _MultiSelectDropdown(
                items: controller.availableProducts,
                selectedItems: controller.selectedProducts,
                onChanged: (selected) {
                  controller.selectedProducts.assignAll(selected);
                  controller.update();
                },
              ),
            ),
            if (controller.selectedProducts.isEmpty)
              Padding(
                padding: EdgeInsets.only(left: AppSpacings.l, bottom: AppSpacings.m),
                child: Text(
                  'Veuillez sélectionner au moins un produit',
                  style: TextStyle(
                    color: AppColors.errorColor,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.backgroundWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacings.l,
            vertical: AppSpacings.m,
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.saveSupplier,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(
            vertical: AppSpacings.xl,
            horizontal: AppSpacings.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacings.s),
                  Text(
                    'Enregistrement...',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcons.save,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                  SizedBox(width: AppSpacings.s),
                  Text(
                    controller.isEditMode.value
                        ? 'Modifier Fournisseur'
                        : 'Enregistrer Fournisseur',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Ajout du widget MultiSelectDropdown
class _MultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;

  const _MultiSelectDropdown({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<_MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<_MultiSelectDropdown> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<String>.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(covariant _MultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItems != widget.selectedItems) {
      _selected = List<String>.from(widget.selectedItems);
    }
  }

  void _onItemTapped(String item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
      widget.onChanged(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: null,
      hint: Text(_selected.isEmpty
          ? 'Sélectionner les produits'
          : _selected.join(', ')),
      items: widget.items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: StatefulBuilder(
            builder: (context, setState) => CheckboxListTile(
              value: _selected.contains(item),
              onChanged: (_) => _onItemTapped(item),
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        );
      }).toList(),
      onChanged: (_) {}, // Ne rien faire ici, la sélection se fait dans CheckboxListTile
      selectedItemBuilder: (context) => widget.items.map((item) => Text('')).toList(),
      icon: Icon(Icons.arrow_drop_down),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.backgroundWhite,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacings.l,
          vertical: AppSpacings.m,
        ),
      ),
      dropdownColor: AppColors.backgroundWhite,
    );
  }
}
