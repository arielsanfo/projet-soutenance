import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/storage.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
// import '../../helpers/app_constante.dart';
import 'dettes_controller.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DettesView extends GetView<DettesController> {
  const DettesView({super.key});
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final sortOptions = [
      'Nom client',
      'Montant restant',
      'Date échéance',
      'Statut',
    ];
    var selectedSort = sortOptions[0];
    var selectedStatus = 'Tous';
    final statusOptions = ['Tous', 'Non payée', 'Partielle', 'Payée'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettes Clients', style: AppTypography.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.data_usage, color: AppColors.secondaryColor),
            tooltip: 'Créer données de test',
            onPressed: () async {
              await controller.createTestDebts();
              Get.snackbar(
                'Succès', 
                'Données de test créées',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.successColor.withOpacity(0.1),
                colorText: AppColors.successColor,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primaryColor),
            tooltip: ' manuel',
            onPressed: () async {
              final customers = await controller.getAllCustomers();
              if (customers.isEmpty) {
                Get.snackbar('Erreur', 'Aucun client disponible', snackPosition: SnackPosition.BOTTOM);
                return;
              }
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  final selectedCustomer = customers.first.obs;
                  final selectedProducts = <Product>[].obs;
                  final montantController = TextEditingController();
                  final avanceController = TextEditingController();
                  final notesController = TextEditingController();
                  final formKey = GlobalKey<FormState>();
                  final montantFocusNode = FocusNode();
                  final avanceFocusNode = FocusNode();
                  final notesFocusNode = FocusNode();
                  RxBool isSolvable = true.obs;
                  RxDouble totalRestant = 0.0.obs;
                  void updateSolvable() async {
                    final customerDebts = controller.dettes.where((d) => d.customerLink.value?.id == selectedCustomer.value!.id).toList();
                    totalRestant.value = customerDebts.fold<double>(0, (sum, d) => sum + (d.remainingAmount ?? 0));
                    final montant = double.tryParse(montantController.text) ?? 0;
                    final avance = double.tryParse(avanceController.text) ?? 0;
                    isSolvable.value = (totalRestant.value - montant + avance) <= 0;
                  }
                  void loadProducts() async {
                    final products = await controller.getProductsForCustomer(selectedCustomer.value!);
                    selectedProducts.clear();
                    selectedProducts.addAll(products);
                    updateSolvable();
                  }
                  loadProducts();
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.white, size: 24),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Ajustement manuel des dettes',
                                    style: AppTypography.titleLarge.copyWith(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                              ],
                            ),
                          ),
                          // Content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(20),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      // Sélection du client
                                      Container(
                                        padding: EdgeInsets.all(AppSpacings.m),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundLight,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Client concerné', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                            SizedBox(height: AppSpacings.s),
                                            DropdownButtonFormField<Customer>(
                                              value: selectedCustomer.value,
                                              items: customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name ?? ''))).toList(),
                                              onChanged: (v) {
                                                selectedCustomer.value = v!;
                                                loadProducts();
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Sélectionner un client',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                filled: true,
                                                fillColor: AppColors.backgroundWhite,
                                              ),
                                              validator: (v) => v == null ? 'Sélectionnez un client' : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: AppSpacings.m),
                                      
                                      // Commandes du client
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                        future: controller.getCustomerOrders(selectedCustomer.value!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                            return Container(
                                              padding: EdgeInsets.all(AppSpacings.m),
                                              decoration: BoxDecoration(
                                                color: AppColors.secondaryColor.withOpacity(0.05),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: AppColors.secondaryColor.withOpacity(0.2)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.shopping_cart, color: AppColors.secondaryColor, size: 20),
                                                      SizedBox(width: AppSpacings.xs),
                                                      Text('Commandes du client', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                                    ],
                                                  ),
                                                  SizedBox(height: AppSpacings.s),
                                                  ...snapshot.data!.map((orderData) {
                                                    final order = orderData['order'] as Order;
                                                    final items = orderData['items'] as List<Map<String, dynamic>>;
                                                    final total = orderData['total'] as double;
                                                    return Container(
                                                      margin: EdgeInsets.only(bottom: AppSpacings.s),
                                                      padding: EdgeInsets.all(AppSpacings.s),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.backgroundWhite,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text('Commande ${order.orderNumber}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                                              ),
                                                              Text('${total.toStringAsFixed(2)} €', style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryColor, fontWeight: FontWeight.bold)),
                                                            ],
                                                          ),
                                                          SizedBox(height: AppSpacings.xs),
                                                          ...items.map((item) {
                                                            final product = item['product'] as Product;
                                                            final quantity = item['quantity'] as int;
                                                            final unitPrice = item['unitPrice'] as double;
                                                            final itemTotal = item['total'] as double;
                                                            return Padding(
                                                              padding: EdgeInsets.only(left: AppSpacings.s),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text('${product.name} x$quantity', style: AppTypography.bodySmall),
                                                                  ),
                                                                  Text('${itemTotal.toStringAsFixed(2)} €', style: AppTypography.bodySmall),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                      SizedBox(height: AppSpacings.m),
                                      
                                      // Produits concernés
                                      Container(
                                        padding: EdgeInsets.all(AppSpacings.m),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundLight,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Produits concernés', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                            SizedBox(height: AppSpacings.s),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: selectedProducts.map((p) => Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                                                ),
                                                child: Text('${p.name} (${p.salePrice?.toStringAsFixed(2)} €)', style: AppTypography.bodySmall),
                                              )).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: AppSpacings.m),
                                      
                                      // Montant et avance
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              key: Key('montant_field'),
                                              controller: montantController,
                                              focusNode: montantFocusNode,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              decoration: InputDecoration(
                                                labelText: 'Montant à ajuster (€)',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                filled: true,
                                                fillColor: AppColors.backgroundLight,
                                                prefixIcon: Icon(Icons.euro, color: AppColors.primaryColor),
                                              ),
                                              validator: (v) {
                                                final val = double.tryParse(v ?? '');
                                                if (val == null || val == 0) return 'Montant invalide';
                                                return null;
                                              },
                                              onChanged: (_) => updateSolvable(),
                                            ),
                                          ),
                                          SizedBox(width: AppSpacings.s),
                                          Expanded(
                                            child: TextFormField(
                                              key: Key('avance_field'),
                                              controller: avanceController,
                                              focusNode: avanceFocusNode,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              decoration: InputDecoration(
                                                labelText: 'Avance (optionnel)',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                filled: true,
                                                fillColor: AppColors.backgroundLight,
                                                prefixIcon: Icon(Icons.payment, color: AppColors.secondaryColor),
                                              ),
                                              onChanged: (_) => updateSolvable(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppSpacings.s),
                                      
                                      // Notes
                                      TextFormField(
                                        key: Key('notes_field'),
                                        controller: notesController,
                                        focusNode: notesFocusNode,
                                        decoration: InputDecoration(
                                          labelText: 'Notes (optionnel)',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          filled: true,
                                          fillColor: AppColors.backgroundLight,
                                          prefixIcon: Icon(Icons.note, color: AppColors.primaryColor),
                                        ),
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: AppSpacings.m),
                                      
                                      // Statut et total
                                      Container(
                                        padding: EdgeInsets.all(AppSpacings.m),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: isSolvable.value 
                                                ? [AppColors.successColor.withOpacity(0.1), AppColors.successColor.withOpacity(0.05)]
                                                : [AppColors.errorColor.withOpacity(0.1), AppColors.errorColor.withOpacity(0.05)],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isSolvable.value ? AppColors.successColor.withOpacity(0.3) : AppColors.errorColor.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isSolvable.value ? Icons.check_circle : Icons.warning,
                                              color: isSolvable.value ? AppColors.successColor : AppColors.errorColor,
                                              size: 24,
                                            ),
                                            SizedBox(width: AppSpacings.s),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Total restant dû : ${totalRestant.value.toStringAsFixed(2)} €', style: AppTypography.bodySmall),
                                                  Text(
                                                    isSolvable.value ? 'Client solvable' : 'Client non solvable',
                                                    style: AppTypography.bodyMedium.copyWith(
                                                      color: isSolvable.value ? AppColors.successColor : AppColors.errorColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: AppSpacings.l),
                                      
                                      // Boutons d'action
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              icon: Icon(Icons.close),
                                              label: Text('Annuler'),
                                              onPressed: () => Navigator.of(ctx).pop(),
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(vertical: AppSpacings.m),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: AppSpacings.m),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.check),
                                              label: Text('Valider'),
                                              onPressed: () async {
                                                if (!formKey.currentState!.validate()) return;
                                                
                                                // Afficher un indicateur de chargement
                                                Get.dialog(
                                                  Center(
                                                    child: Container(
                                                      padding: EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          CircularProgressIndicator(color: AppColors.primaryColor),
                                                          SizedBox(height: 16),
                                                          Text('Création de la dette...', style: AppTypography.bodyMedium),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  barrierDismissible: false,
                                                );
                                                
                                                try {
                                                  final montant = double.parse(montantController.text);
                                                  final avance = double.tryParse(avanceController.text) ?? 0;
                                                  final notes = notesController.text.trim();
                                                  
                                                  await controller.createManualDebt(
                                                    customer: selectedCustomer.value!,
                                                    amount: montant,
                                                    selectedProducts: selectedProducts,
                                                    advanceAmount: avance > 0 ? avance : null,
                                                    notes: notes.isNotEmpty ? notes : null,
                                                  );
                                                  
                                                  // Fermer le dialogue de chargement
                                                  Get.back();
                                                  
                                                  // Fermer le bottom sheet
                                                  Navigator.of(ctx).pop();
                                                  
                                                  // Afficher le message de succès
                                                  Get.snackbar(
                                                    'Succès', 
                                                    'Dette créée avec succès',
                                                    snackPosition: SnackPosition.BOTTOM,
                                                    backgroundColor: AppColors.successColor.withOpacity(0.1),
                                                    colorText: AppColors.successColor,
                                                    duration: Duration(seconds: 3),
                                                  );
                                                } catch (e) {
                                                  // Fermer le dialogue de chargement
                                                  Get.back();
                                                  
                                                  // Afficher l'erreur
                                                  Get.snackbar(
                                                    'Erreur', 
                                                    'Erreur lors de la création de la dette: $e',
                                                    snackPosition: SnackPosition.BOTTOM,
                                                    backgroundColor: AppColors.errorColor.withOpacity(0.1),
                                                    colorText: AppColors.errorColor,
                                                    duration: Duration(seconds: 5),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primaryColor,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(vertical: AppSpacings.m),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.download, color: AppColors.primaryColor),
            tooltip: 'Exporter',
            onPressed: () async {
              final format = await showDialog<String>(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: Text('Exporter les dettes'),
                  children: [
                    SimpleDialogOption(
                      child: Text('CSV'),
                      onPressed: () => Navigator.pop(ctx, 'csv'),
                    ),
                    SimpleDialogOption(
                      child: Text('PDF'),
                      onPressed: () => Navigator.pop(ctx, 'pdf'),
                    ),
                  ],
                ),
              );
              if (format == 'csv') {
                await exportDettesCSV(context, controller, searchController.text, selectedSort, selectedStatus);
              } else if (format == 'pdf') {
                await exportDettesPDF(context, controller, searchController.text, selectedSort, selectedStatus);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        var dettes = controller.dettes;
        // Filtrage
        final search = searchController.text.trim().toLowerCase();
        if (search.isNotEmpty) {
          dettes = dettes.where((d) {
            final client = d.customerLink.value;
            return (client?.name?.toLowerCase().contains(search) ?? false) ||
                (d.notes?.toLowerCase().contains(search) ?? false);
          }).toList().obs;
        }
        // Filtrage par statut
        if (selectedStatus != 'Tous') {
          dettes = dettes.where((d) {
            switch (selectedStatus) {
              case 'Non payée':
                return d.status == DebtStatusIsar.unpaid;
              case 'Partielle':
                return d.status == DebtStatusIsar.partiallyPaid;
              case 'Payée':
                return d.status == DebtStatusIsar.paid;
              default:
                return true;
            }
          }).toList().obs;
        }
        // Tri
        dettes.sort((a, b) {
          switch (selectedSort) {
            case 'Nom client':
              return (a.customerLink.value?.name ?? '').compareTo(b.customerLink.value?.name ?? '');
            case 'Montant restant':
              return (b.remainingAmount ?? 0).compareTo(a.remainingAmount ?? 0);
            case 'Date échéance':
              return (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100));
            case 'Statut':
              return (a.status?.index ?? 0).compareTo(b.status?.index ?? 0);
            default:
              return 0;
          }
        });
        final totalRestant = dettes.fold<double>(0, (sum, d) => sum + (d.remainingAmount ?? 0));
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.backgroundWhite, AppColors.backgroundLight],
            ),
          ),
          child: Column(
            children: [
              // Header avec statistiques
              Container(
                padding: EdgeInsets.all(AppSpacings.l),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Rechercher un client ou une dette...',
                            prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                          ),
                          onChanged: (_) => controller.update(),
                        ),
                        SizedBox(height: AppSpacings.s),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedSort,
                                  isExpanded: true,
                                  items: sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      selectedSort = v;
                                      controller.update();
                                    }
                                  },
                                  underline: SizedBox(),
                                  icon: Icon(Icons.sort, color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacings.s),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedStatus,
                                  isExpanded: true,
                                  items: statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      selectedStatus = v;
                                      controller.update();
                                    }
                                  },
                                  underline: SizedBox(),
                                  icon: Icon(Icons.filter_list, color: AppColors.secondaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacings.m),
                    Container(
                      padding: EdgeInsets.all(AppSpacings.m),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryColor, AppColors.secondaryColor],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total restant dû', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                              Text('${totalRestant.toStringAsFixed(2)} €', style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Liste des dettes
              Expanded(
                child: dettes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: AppColors.primaryColor.withOpacity(0.5)),
                            SizedBox(height: AppSpacings.m),
                            Text('Aucune dette trouvée', style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryColor.withOpacity(0.7))),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.all(AppSpacings.l),
                        itemCount: dettes.length,
                        separatorBuilder: (_, __) => SizedBox(height: AppSpacings.m),
                        itemBuilder: (context, i) {
                          final d = dettes[i];
                          final client = d.customerLink.value;
                          final status = d.status ?? DebtStatusIsar.unpaid;
                          Color statusColor;
                          String statusLabel;
                          IconData statusIcon;
                          switch (status) {
                            case DebtStatusIsar.paid:
                              statusColor = AppColors.successColor;
                              statusLabel = 'Payée';
                              statusIcon = Icons.check_circle;
                              break;
                            case DebtStatusIsar.partiallyPaid:
                              statusColor = AppColors.warningColor;
                              statusLabel = 'Partielle';
                              statusIcon = Icons.hourglass_bottom;
                              break;
                            default:
                              statusColor = AppColors.errorColor;
                              statusLabel = 'Non payée';
                              statusIcon = Icons.warning_amber;
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhite,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: statusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(AppSpacings.m),
                              leading: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(statusIcon, color: statusColor, size: 28),
                              ),
                              title: GestureDetector(
                                onTap: () {
                                  if (client?.id != null) {
                                    Get.toNamed('/details-client', arguments: client!.id);
                                  }
                                },
                                child: Text(
                                  client?.name ?? 'Client inconnu',
                                  style: AppTypography.bodyMedium.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: AppSpacings.xs),
                                  Row(
                                    children: [
                                      Text('Initial: ', style: AppTypography.bodySmall),
                                      Text('${(d.initialAmount ?? 0).toStringAsFixed(2)} €', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                                      SizedBox(width: AppSpacings.m),
                                      Text('Restant: ', style: AppTypography.bodySmall),
                                      Text('${(d.remainingAmount ?? 0).toStringAsFixed(2)} €', style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: status == DebtStatusIsar.paid ? AppColors.successColor : AppColors.errorColor,
                                      )),
                                    ],
                                  ),
                                  if (d.dueDate != null)
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 14, color: AppColors.primaryColor),
                                        SizedBox(width: 4),
                                        Text('Échéance: ${d.dueDate!.day}/${d.dueDate!.month}/${d.dueDate!.year}', style: AppTypography.bodySmall),
                                      ],
                                    ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppSpacings.xs),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (status != DebtStatusIsar.paid)
                                        IconButton(
                                          icon: Icon(Icons.payment, color: AppColors.primaryColor, size: 20),
                                          tooltip: 'Enregistrer un paiement',
                                          onPressed: () => showPaiementDialog(context, controller, d),
                                        ),
                                      IconButton(
                                        icon: Icon(Icons.history, color: AppColors.secondaryColor, size: 20),
                                        tooltip: 'Historique des paiements',
                                        onPressed: () => showPaiementsHistoriqueDialog(context, controller, d),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Future<void> showPaiementDialog(BuildContext context, DettesController controller, Debt debt) async {
  final montantController = TextEditingController(text: (debt.remainingAmount ?? 0).toStringAsFixed(2));
  String paymentMethod = 'Espèces';
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  await showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Enregistrer un paiement', style: AppTypography.titleLarge),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Client : ${debt.customerLink.value?.name ?? "Inconnu"}', style: AppTypography.bodyMedium),
                  SizedBox(height: AppSpacings.s),
                  Text('Restant dû : ${(debt.remainingAmount ?? 0).toStringAsFixed(2)} €', style: AppTypography.bodySmall),
                  SizedBox(height: AppSpacings.s),
                  TextFormField(
                    controller: montantController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Montant payé'),
                    validator: (v) {
                      final val = double.tryParse(v ?? '');
                      if (val == null || val <= 0) return 'Montant invalide';
                      if (val > (debt.remainingAmount ?? 0)) return 'Montant > restant dû';
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacings.s),
                  DropdownButtonFormField<String>(
                    value: paymentMethod,
                    items: [
                      DropdownMenuItem(value: 'Espèces', child: Text('Espèces')),
                      DropdownMenuItem(value: 'Virement', child: Text('Virement')),
                      DropdownMenuItem(value: 'Chèque', child: Text('Chèque')),
                    ],
                    onChanged: (v) => setState(() => paymentMethod = v ?? 'Espèces'),
                    decoration: InputDecoration(labelText: 'Méthode de paiement'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setState(() => isLoading = true);
                        final montant = double.parse(montantController.text);
                        await controller.recordDebtPayment(
                          debtId: debt.id!,
                          amountPaid: montant,
                          paymentMethod: paymentMethod,
                        );
                        setState(() => isLoading = false);
                        Navigator.of(context).pop();
                        Get.snackbar('Succès', 'Paiement enregistré avec succès', snackPosition: SnackPosition.BOTTOM);
                      },
                child: isLoading ? CircularProgressIndicator() : Text('Valider'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showPaiementsHistoriqueDialog(BuildContext context, DettesController controller, Debt debt) async {
  final payments = await controller.getPaymentsForDebt(debt);
  await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text('Historique des paiements', style: AppTypography.titleLarge),
        content: payments.isEmpty
            ? Text('Aucun paiement enregistré.', style: AppTypography.bodyMedium)
            : SizedBox(
                width: 320,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: payments.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, i) {
                    final p = payments[i];
                    return ListTile(
                      leading: Icon(Icons.payments, color: AppColors.primaryColor),
                      title: Text('${p.amountPaid?.toStringAsFixed(2) ?? "-"} €', style: AppTypography.bodyMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (p.paymentDate != null)
                            Text('Date : ${p.paymentDate!.day}/${p.paymentDate!.month}/${p.paymentDate!.year}', style: AppTypography.bodySmall),
                          if (p.paymentMethod != null)
                            Text('Méthode : ${p.paymentMethod}', style: AppTypography.bodySmall),
                          if ((p.notes ?? '').isNotEmpty)
                            Text('Notes : ${p.notes}', style: AppTypography.bodySmall),
                        ],
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
        ],
      );
    },
  );
}

Future<void> exportDettesCSV(BuildContext context, DettesController controller, String search, String sort, String status) async {
  var dettes = controller.dettes;
  // Filtrage recherche
  if (search.trim().isNotEmpty) {
    dettes = dettes.where((d) {
      final client = d.customerLink.value;
      return (client?.name?.toLowerCase().contains(search.toLowerCase()) ?? false) ||
          (d.notes?.toLowerCase().contains(search.toLowerCase()) ?? false);
    }).toList().obs;
  }
  // Filtrage statut
  if (status != 'Tous') {
    dettes = dettes.where((d) {
      switch (status) {
        case 'Non payée':
          return d.status == DebtStatusIsar.unpaid;
        case 'Partielle':
          return d.status == DebtStatusIsar.partiallyPaid;
        case 'Payée':
          return d.status == DebtStatusIsar.paid;
        default:
          return true;
      }
    }).toList().obs;
  }
  // Tri
  dettes.sort((a, b) {
    switch (sort) {
      case 'Nom client':
        return (a.customerLink.value?.name ?? '').compareTo(b.customerLink.value?.name ?? '');
      case 'Montant restant':
        return (b.remainingAmount ?? 0).compareTo(a.remainingAmount ?? 0);
      case 'Date échéance':
        return (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100));
      case 'Statut':
        return (a.status?.index ?? 0).compareTo(b.status?.index ?? 0);
      default:
        return 0;
    }
  });
  final rows = <List<String>>[
    ['Client', 'Montant initial', 'Restant dû', 'Date', 'Échéance', 'Statut', 'Notes'],
    ...dettes.map((d) => [
      d.customerLink.value?.name ?? '',
      (d.initialAmount ?? 0).toStringAsFixed(2),
      (d.remainingAmount ?? 0).toStringAsFixed(2),
      d.debtDate != null ? '${d.debtDate!.day}/${d.debtDate!.month}/${d.debtDate!.year}' : '',
      d.dueDate != null ? '${d.dueDate!.day}/${d.dueDate!.month}/${d.dueDate!.year}' : '',
      d.status == DebtStatusIsar.paid ? 'Payée' : d.status == DebtStatusIsar.partiallyPaid ? 'Partielle' : 'Non payée',
      d.notes ?? '',
    ]),
  ];
  final csvData = const ListToCsvConverter().convert(rows);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/dettes_export.csv');
  await file.writeAsString(csvData);
  await Printing.sharePdf(bytes: file.readAsBytesSync(), filename: 'dettes_export.csv');
}

Future<void> exportDettesPDF(BuildContext context, DettesController controller, String search, String sort, String status) async {
  var dettes = controller.dettes;
  // Filtrage recherche
  if (search.trim().isNotEmpty) {
    dettes = dettes.where((d) {
      final client = d.customerLink.value;
      return (client?.name?.toLowerCase().contains(search.toLowerCase()) ?? false) ||
          (d.notes?.toLowerCase().contains(search.toLowerCase()) ?? false);
    }).toList().obs;
  }
  // Filtrage statut
  if (status != 'Tous') {
    dettes = dettes.where((d) {
      switch (status) {
        case 'Non payée':
          return d.status == DebtStatusIsar.unpaid;
        case 'Partielle':
          return d.status == DebtStatusIsar.partiallyPaid;
        case 'Payée':
          return d.status == DebtStatusIsar.paid;
        default:
          return true;
      }
    }).toList().obs;
  }
  // Tri
  dettes.sort((a, b) {
    switch (sort) {
      case 'Nom client':
        return (a.customerLink.value?.name ?? '').compareTo(b.customerLink.value?.name ?? '');
      case 'Montant restant':
        return (b.remainingAmount ?? 0).compareTo(a.remainingAmount ?? 0);
      case 'Date échéance':
        return (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100));
      case 'Statut':
        return (a.status?.index ?? 0).compareTo(b.status?.index ?? 0);
      default:
        return 0;
    }
  });
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Export Dettes Clients', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Client', 'Montant initial', 'Restant dû', 'Date', 'Échéance', 'Statut', 'Notes'],
              data: [
                ...dettes.map((d) => [
                  d.customerLink.value?.name ?? '',
                  (d.initialAmount ?? 0).toStringAsFixed(2),
                  (d.remainingAmount ?? 0).toStringAsFixed(2),
                  d.debtDate != null ? '${d.debtDate!.day}/${d.debtDate!.month}/${d.debtDate!.year}' : '',
                  d.dueDate != null ? '${d.dueDate!.day}/${d.dueDate!.month}/${d.dueDate!.year}' : '',
                  d.status == DebtStatusIsar.paid ? 'Payée' : d.status == DebtStatusIsar.partiallyPaid ? 'Partielle' : 'Non payée',
                  d.notes ?? '',
                ]),
              ],
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFE0E0E0)),
              cellHeight: 24,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.center,
                4: pw.Alignment.center,
                5: pw.Alignment.center,
                6: pw.Alignment.centerLeft,
              },
            ),
          ],
        );
      },
    ),
  );
  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
