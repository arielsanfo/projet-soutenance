import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/Supplier_List/supplier_list_controller.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../../app/data/storage.dart';
import '../../../app/data/controller/supplierService.dart';
import '../../../helpers/app_constante.dart';

class AddSupplierController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController productsController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  final isLoading = false.obs;
  final isEditMode = false.obs;
  Supplier? supplierToEdit;
  late final SupplierService supplierService;

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    supplierService = SupplierService(isar);

    // Vérifier si on est en mode édition
    final args = Get.arguments;
    if (args != null && args is Supplier) {
      supplierToEdit = args;
      isEditMode.value = true;
      _loadSupplierData();
    }
  }

  @override
  void onClose() {
    companyController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    contactController.dispose();
    productsController.dispose();
    paymentController.dispose();
    super.onClose();
  }

  /// Charger les données du fournisseur à modifier
  void _loadSupplierData() {
    if (supplierToEdit == null) return;

    companyController.text = supplierToEdit!.name ?? '';
    contactController.text = supplierToEdit!.contactPerson ?? '';
    emailController.text = supplierToEdit!.email ?? '';
    phoneController.text = supplierToEdit!.phone ?? '';
    addressController.text = supplierToEdit!.address ?? '';

    // Extraire les informations des notes
    final notes = supplierToEdit!.notes ?? '';
    final lines = notes.split('\n');

    for (final line in lines) {
      if (line.startsWith('Produits:')) {
        productsController.text = line.replaceFirst('Produits:', '').trim();
      } else if (line.startsWith('Conditions de paiement:')) {
        paymentController.text =
            line.replaceFirst('Conditions de paiement:', '').trim();
      }
    }
  }

  /// Sauvegarder le fournisseur (ajout ou modification)
  Future<void> saveSupplier() async {
    if (!formKey.currentState!.validate()) {
      AppSnackbars.showWarning(
        'Validation',
        'Veuillez corriger les erreurs dans le formulaire',
      );
      return;
    }

    try {
      isLoading.value = true;

      if (isEditMode.value && supplierToEdit != null) {
        // Mode modification
        supplierToEdit!.name = companyController.text.trim();
        supplierToEdit!.contactPerson = contactController.text.trim().isEmpty
            ? null
            : contactController.text.trim();
        supplierToEdit!.email = emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim();
        supplierToEdit!.phone = phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim();
        supplierToEdit!.address = addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim();
        supplierToEdit!.notes = _buildNotes();

        await supplierService.updateSupplier(supplierToEdit!);

        AppSnackbars.showSuccess(
          'Succès',
          'Fournisseur "${supplierToEdit!.name}" modifié avec succès',
        );
      } else {
        // Mode ajout
        final newSupplier = await supplierService.createSupplier(
          name: companyController.text.trim(),
          contactPerson: contactController.text.trim().isEmpty
              ? null
              : contactController.text.trim(),
          email: emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          address: addressController.text.trim().isEmpty
              ? null
              : addressController.text.trim(),
          notes: _buildNotes(),
        );

        AppSnackbars.showSuccess(
          'Succès',
          'Fournisseur "${newSupplier.name}" ajouté avec succès',
        );
      }

      // Rafraîchir la liste des fournisseurs
      _refreshSupplierList();

      // Retourner à la liste des fournisseurs
      Get.back();
    } catch (e) {
      AppSnackbars.showError(
        'Erreur',
        'Impossible de ${isEditMode.value ? 'modifier' : 'ajouter'} le fournisseur: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Rafraîchir la liste des fournisseurs
  void _refreshSupplierList() {
    // Déclencher le rafraîchissement via le gestionnaire
    AppRefreshManager.refreshPage(AppPageKeys.supplierList);
    
    // Essayer aussi de rafraîchir directement si le contrôleur existe
    try {
      final supplierListController = Get.find<SupplierListController>();
      supplierListController.loadSuppliers();
    } catch (e) {
      // Le contrôleur n'existe pas encore, c'est normal
    }
  }

  /// Construire les notes combinées
  String _buildNotes() {
    final notes = <String>[];

    if (productsController.text.trim().isNotEmpty) {
      notes.add('Produits: ${productsController.text.trim()}');
    }

    if (paymentController.text.trim().isNotEmpty) {
      notes.add('Conditions de paiement: ${paymentController.text.trim()}');
    }

    return notes.join('\n');
  }

  /// Valider l'email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email optionnel
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format d\'email invalide';
    }

    return null;
  }

  /// Valider le téléphone
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Téléphone optionnel
    }

    // Validation basique du téléphone
    if (!RegExp(r'^[\d\s\-\+\(\)]+$').hasMatch(value)) {
      return 'Format de téléphone invalide';
    }

    return null;
  }
} 