import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'final_inventory_controller.dart';
// import '../../data/controller/productService.dart';
import '../../data/storage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FinalInventoryView extends GetView<FinalInventoryController> {
   FinalInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Prise d\'Inventaire',
            style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: AppColors.primaryColor),
            tooltip: 'Exporter PDF',
            onPressed: () async {
              await _exportPdf(context, controller);
            },
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(AppSpacings.l),
        child: GetBuilder<FinalInventoryController>(
          builder: (controller) => Column(
            children: [
              _buildFiltersChips(controller),
              SizedBox(height: AppSpacings.l),
              _buildCustomStatsCards(controller),
              Expanded(
                child: controller.filteredProducts.isEmpty
                  ? Center(child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2, color: AppColors.primaryColor, size: 48),
                          SizedBox(height: 12),
                          Text('Aucun produit trouvé.', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ))
                  : ListView.separated(
                      itemCount: controller.filteredProducts.length,
                      separatorBuilder: (context, index) => SizedBox(height: AppSpacings.m),
                      itemBuilder: (context, index) {
                        final product = controller.filteredProducts[index];
                        final variance = controller.getVariance(product);
                        return _buildProductCard(product, variance, controller);
                      },
                    ),
              ),
              _buildActionButtons(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersChips(FinalInventoryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: Text('Toutes les catégories'),
                selected: controller.selectedCategory.value == null,
                onSelected: (_) => controller.setCategory(null),
                selectedColor: AppColors.primaryColor.withOpacity(0.15),
                labelStyle: AppTypography.bodyMedium,
              ),
              ...controller.categories.map((cat) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(cat.name ?? ''),
                  selected: controller.selectedCategory.value?.id == cat.id,
                  onSelected: (_) => controller.setCategory(cat),
                  selectedColor: AppColors.primaryColor.withOpacity(0.15),
                  labelStyle: AppTypography.bodyMedium,
                ),
              )),
            ],
          ),
        ),
        SizedBox(height: AppSpacings.l),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(16),
          child: TextFormField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              labelText: 'Recherche',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: AppColors.backgroundLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomStatsCards(FinalInventoryController controller) {
    final withVariance = controller.filteredProducts.where((p) => controller.getVariance(p) != 0).toList();
    final totalVariance = withVariance.fold(0, (sum, p) => sum + controller.getVariance(p));
    return Row(
      children: [
        Expanded(
          child: Card(
            color: AppColors.primaryColor.withOpacity(0.08),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.xl),
              child: Column(
                children: [
                  Icon(Icons.compare_arrows, color: AppColors.primaryColor, size: 32),
                  SizedBox(height: AppSpacings.s),
                  Text('Produits avec écart', style: AppTypography.titleSmall),
                  SizedBox(height: AppSpacings.s),
                  Text(withVariance.length.toString(), style: AppTypography.titleLarge.apply(color: AppColors.primaryColor)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacings.m),
        Expanded(
          child: Card(
            color: AppColors.errorColor.withOpacity(0.08),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.xl),
              child: Column(
                children: [
                  Icon(Icons.trending_down, color: AppColors.errorColor, size: 32),
                  SizedBox(height: AppSpacings.s),
                  Text('Écart total', style: AppTypography.titleSmall),
                  SizedBox(height: AppSpacings.s),
                  Text(totalVariance.toString(), style: AppTypography.titleLarge.apply(color: AppColors.errorColor)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product, int variance, FinalInventoryController controller) {
    Color badgeColor;
    String badgeText;
    if ((product.stockQuantity ?? 0) == 0) {
      badgeColor = AppColors.errorColor;
      badgeText = 'Rupture';
    } else if ((product.stockQuantity ?? 0) < 5) {
      badgeColor = Colors.orange;
      badgeText = 'Stock faible';
    } else {
      badgeColor = AppColors.tagGreenText;
      badgeText = 'OK';
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2, color: badgeColor, size: 18),
                      SizedBox(width: 4),
                      Text(badgeText, style: AppTypography.bodySmall.copyWith(color: badgeColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacings.l),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name ?? '', style: AppTypography.titleMedium),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.category, size: 14, color: AppColors.primaryColor),
                          SizedBox(width: 4),
                          Text(product.categoryLink.value?.name ?? '', style: AppTypography.bodySmall),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('SKU: ${product.sku ?? '-'}', style: AppTypography.bodySmall.apply(color: AppColors.greyMedium)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${product.stockQuantity ?? 0}', style: AppTypography.titleLarge.apply(color: badgeColor)),
                    Text('Théorique', style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: controller.physicalCounts[product.id]?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Stock Physique Compté',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                    ),
                    onChanged: (value) {
                      final v = int.tryParse(value) ?? 0;
                      controller.setPhysicalCount(product, v);
                    },
                  ),
                ),
                SizedBox(width: AppSpacings.l),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: variance == 0
                        ? AppColors.primaryColor.withOpacity(0.10)
                        : (variance > 0 ? AppColors.tagGreenText.withOpacity(0.15) : AppColors.errorColor.withOpacity(0.15)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        variance == 0
                            ? Icons.check_circle
                            : (variance > 0 ? Icons.trending_up : Icons.trending_down),
                        color: variance == 0
                            ? AppColors.primaryColor
                            : (variance > 0 ? AppColors.tagGreenText : AppColors.errorColor),
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        variance == 0
                            ? 'OK'
                            : (variance > 0 ? '+$variance' : '$variance'),
                        style: AppTypography.bodySmall.copyWith(
                          color: variance == 0
                              ? AppColors.primaryColor
                              : (variance > 0 ? AppColors.tagGreenText : AppColors.errorColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (variance != 0) ...[
              SizedBox(height: AppSpacings.l),
              DropdownButtonFormField<String>(
                value: controller.reasons[product.id],
                decoration: InputDecoration(
                  labelText: 'Choisir une raison',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppColors.backgroundLight,
                ),
                items: ['Casse', 'Vol', 'Erreur']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium))))
                    .toList(),
                onChanged: (val) => controller.setReason(product, val),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(FinalInventoryController controller) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await controller.saveInventoryAdjustments();
            Get.snackbar('Succès', 'Ajustements d\'inventaire enregistrés', backgroundColor: AppColors.successColor, colorText: AppColors.textOnPrimary);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(double.infinity, AppSpacings.xxxl *2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
            ),
          ),
          child: Text('Valider et Suivant',
              style: AppTypography.bodyLarge.apply(color: AppColors.textOnPrimary)),
        ),
        SizedBox(height: AppSpacings.l),
        OutlinedButton(
          onPressed: () async {
            await controller.saveInventoryAdjustments();
            Get.snackbar('Inventaire Finalisé', 'Tous les ajustements ont été enregistrés', backgroundColor: AppColors.primaryColor, colorText: AppColors.textOnPrimary);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            minimumSize: Size(double.infinity, AppSpacings.xxxl *2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
            ),
          ),
          child: Text('Finaliser l\'Inventaire',
              style: AppTypography.bodyLarge.apply(color: AppColors.primaryColor)),
        ),
      ],
    );
  }

  Future<void> _exportPdf(BuildContext context, FinalInventoryController controller) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Prise d\'Inventaire', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Date : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Nom', 'Catégorie', 'Théorique', 'Physique', 'Écart', 'Raison'],
              data: controller.filteredProducts.map((p) => [
                p.name ?? '',
                p.categoryLink.value?.name ?? '',
                (p.stockQuantity ?? 0).toString(),
                (controller.physicalCounts[p.id] ?? '').toString(),
                controller.getVariance(p).toString(),
                controller.reasons[p.id] ?? '',
              ]).toList(),
            ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}

class ProductWidget extends StatefulWidget {
  final Product product;
  final int theoretical;
  final Function(String) onChanged;
  final int variance;
  final String? reason;
  final Function(String?) onReasonChanged;

  const ProductWidget({
    required this.product,
    required this.theoretical,
    required this.onChanged,
    required this.variance,
    this.reason,
    required this.onReasonChanged,
  });

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Produit: ${widget.product.name}',
                style: AppTypography.bodyMedium),
        SizedBox(height: AppSpacings.l),
        Text('Stock Théorique: ${widget.theoretical}',
            style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium)),
        SizedBox(height: AppSpacings.l),
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Stock Physique Compté',
            hintText: widget.theoretical.toString(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
            ),
          ),
          onChanged: widget.onChanged,
        ),
        if (widget.variance != 0) ...[
          SizedBox(height: AppSpacings.l),
          Text('Écart: ${widget.variance > 0 ? '+' : ''}${widget.variance}',
              style: AppTypography.bodyMedium.apply(color: widget.variance > 0 ? AppColors.tagGreenText : AppColors.tagRedText)),
          SizedBox(height: AppSpacings.l),
          DropdownButtonFormField<String>(
            value: widget.reason,
            decoration: InputDecoration(
              labelText: 'Choisir une raison',
              border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppSpacings.l),
              ),
            ),
            items: ['Casse', 'Vol', 'Erreur']
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium)  )))
                .toList(),
            onChanged: widget.onReasonChanged,
          ),
        ],
      ],
    );
  }
}