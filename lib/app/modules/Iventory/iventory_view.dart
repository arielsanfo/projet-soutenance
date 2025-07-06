import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'iventory_controller.dart';
// import '../../data/controller/productService.dart';
import '../../data/storage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class IventoryView extends GetView<IventoryController> {
   IventoryView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.backgroundWhite, AppColors.backgroundWhite],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
            'Inventaire',
            style: AppTypography.titleLarge.copyWith(fontSize: isMobile ? 22 : 28),
        ),
        centerTitle: true,
        elevation: 0,
          backgroundColor: Colors.transparent,
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
        body: GetBuilder<IventoryController>(
          builder: (controller) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 24, vertical: isMobile ? 8 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isMobile) _buildMobileFiltersBar(context, controller),
                if (!isMobile) _buildFloatingFiltersBar(controller),
                SizedBox(height: AppSpacings.l),
                _buildMobileStatsTiles(controller, isMobile),
                SizedBox(height: AppSpacings.xxl),
                _buildCustomStats(controller),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
                  child: Text(
                    'Articles',
                    style: AppTypography.titleLarge.copyWith(fontSize: isMobile ? 18 : 24),
                  ),
                ),
                SizedBox(height: AppSpacings.l),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
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
                          key: ValueKey(controller.filteredProducts.length),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.filteredProducts.length,
                          separatorBuilder: (context, index) => SizedBox(height: isMobile ? 8 : AppSpacings.m),
                          itemBuilder: (context, index) {
                            final product = controller.filteredProducts[index];
                            return _buildMobileProductCard(product, isMobile);
                          },
                        ),
                ),
                SizedBox(height: isMobile ? 24 : AppSpacings.xxxl),
            // Section Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              child: Text(
                    'Actions',
                    style: AppTypography.titleLarge.copyWith(fontSize: isMobile ? 16 : 22),
              ),
            ),
            SizedBox(height: AppSpacings.l),
            _buildActionButton(
              icon: AppIcons.list,
              label: 'Voir tous les articles',
            ),
            SizedBox(height: AppSpacings.l),
            _buildActionButton(
              icon: AppIcons.swap_horiz,
              label: 'Mouvements de Stock',
            ),
            SizedBox(height: AppSpacings.l),
            _buildActionButton(
              icon: AppIcons.checklist_rtl,
              label: 'Prise d\'Inventaire',
            ),
          ],
        ),
      ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
        onPressed: () {
                Get.toNamed('/final-inventory');
              },
              icon: Icon(Icons.checklist_rtl, color: AppColors.backgroundInput, size: isMobile ? 22 : 28),
              label: Text(
                'Prise d\'Inventaire',
                style: AppTypography.titleSmall.apply(color: AppColors.textOnPrimary, fontSizeFactor: isMobile ? 1.1 : 1.2),
              ),
              backgroundColor: AppColors.primaryDarker,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 18 : 24)),
              heroTag: 'goToFinalInventory',
              extendedPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
            ),
            SizedBox(height: isMobile ? 10 : 16),
            FloatingActionButton.extended(
              onPressed: () async {
                await _showManualAdjustmentSheet(context, controller);
              },
              icon: Icon(AppIcons.add, color: AppColors.backgroundInput, size: isMobile ? 22 : 28),
        label: Text(
          'Ajustement Manuel',
                style: AppTypography.titleSmall.apply(color: AppColors.textOnPrimary, fontSizeFactor: isMobile ? 1.1 : 1.2),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 18 : 24)),
              heroTag: 'manualAdjustment',
              extendedPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingFiltersBar(IventoryController controller) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(24),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('Tous'),
                    selected: controller.stockFilter.value == 'all',
                    onSelected: (_) => controller.setStockFilter('all'),
                    selectedColor: AppColors.primaryColor.withOpacity(0.15),
                    labelStyle: AppTypography.bodyMedium,
                  ),
                  ChoiceChip(
                    label: Text('En stock'),
                    selected: controller.stockFilter.value == 'in_stock',
                    onSelected: (_) => controller.setStockFilter('in_stock'),
                    selectedColor: AppColors.tagGreenText.withOpacity(0.15),
                    labelStyle: AppTypography.bodyMedium,
                  ),
                  ChoiceChip(
                    label: Text('Rupture'),
                    selected: controller.stockFilter.value == 'out_of_stock',
                    onSelected: (_) => controller.setStockFilter('out_of_stock'),
                    selectedColor: AppColors.errorColor.withOpacity(0.15),
                    labelStyle: AppTypography.bodyMedium,
                  ),
                  ChoiceChip(
                    label: Text('Stock faible'),
                    selected: controller.stockFilter.value == 'low_stock',
                    onSelected: (_) => controller.setStockFilter('low_stock'),
                    selectedColor: Colors.orange.withOpacity(0.15),
                    labelStyle: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
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
            SizedBox(height: 8),
            TextFormField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                labelText: 'Recherche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: AppColors.backgroundLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFiltersBar(BuildContext context, IventoryController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('Tous'),
                  selected: controller.stockFilter.value == 'all',
                  onSelected: (_) => controller.setStockFilter('all'),
                  selectedColor: AppColors.primaryColor.withOpacity(0.15),
                  labelStyle: AppTypography.bodyMedium,
                ),
                ChoiceChip(
                  label: Text('En stock'),
                  selected: controller.stockFilter.value == 'in_stock',
                  onSelected: (_) => controller.setStockFilter('in_stock'),
                  selectedColor: AppColors.tagGreenText.withOpacity(0.15),
                  labelStyle: AppTypography.bodyMedium,
                ),
                ChoiceChip(
                  label: Text('Rupture'),
                  selected: controller.stockFilter.value == 'out_of_stock',
                  onSelected: (_) => controller.setStockFilter('out_of_stock'),
                  selectedColor: AppColors.errorColor.withOpacity(0.15),
                  labelStyle: AppTypography.bodyMedium,
                ),
                ChoiceChip(
                  label: Text('Stock faible'),
                  selected: controller.stockFilter.value == 'low_stock',
                  onSelected: (_) => controller.setStockFilter('low_stock'),
                  selectedColor: Colors.orange.withOpacity(0.15),
                  labelStyle: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
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
          SizedBox(height: 8),
          TextFormField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              labelText: 'Recherche',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: AppColors.backgroundLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCardsGradient(IventoryController controller) {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB6E0FE), Color(0xFFE3F0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacings.xl),
                child: Column(
                  children: [
                    Icon(Icons.inventory, color: AppColors.primaryColor, size: 32),
                    SizedBox(height: AppSpacings.s),
                    Text('En stock', style: AppTypography.titleSmall),
                    SizedBox(height: AppSpacings.s),
                    Text(controller.totalInStock.toString(), style: AppTypography.titleLarge.apply(color: AppColors.primaryColor)),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacings.m),
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD6D6), Color(0xFFF8F8FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacings.xl),
                child: Column(
                  children: [
                    Icon(Icons.warning, color: AppColors.errorColor, size: 32),
                    SizedBox(height: AppSpacings.s),
                    Text('Rupture', style: AppTypography.titleSmall),
                    SizedBox(height: AppSpacings.s),
                    Text(controller.outOfStockCount.toString(), style: AppTypography.titleLarge.apply(color: AppColors.errorColor)),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacings.m),
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB6E0FE), Color(0xFFB6F3FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacings.xl),
                child: Column(
                  children: [
                    Icon(Icons.attach_money, color: AppColors.primaryDarker, size: 32),
                    SizedBox(height: AppSpacings.s),
                    Text('Valeur Stock', style: AppTypography.titleSmall),
                    SizedBox(height: AppSpacings.s),
                    Text('${controller.totalStockValue.toStringAsFixed(2)} FCFA', style: AppTypography.titleLarge.apply(color: AppColors.primaryDarker)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStatsTiles(IventoryController controller, bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatTile(
            icon: Icons.inventory,
            label: 'En stock',
            value: controller.totalInStock.toString(),
            color: AppColors.primaryColor,
            isMobile: isMobile,
          ),
          SizedBox(width: 8),
          _buildStatTile(
            icon: Icons.warning,
            label: 'Rupture',
            value: controller.outOfStockCount.toString(),
            color: AppColors.errorColor,
            isMobile: isMobile,
          ),
          SizedBox(width: 8),
          _buildStatTile(
            icon: Icons.attach_money,
            label: 'Valeur',
            value: '${controller.totalStockValue.toStringAsFixed(0)} FCFA',
            color: AppColors.primaryDarker,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({required IconData icon, required String label, required String value, required Color color, required bool isMobile}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 18 : 24)),
      child: Container(
        width: isMobile ? 120 : 180,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 24, horizontal: isMobile ? 8 : 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.13), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: isMobile ? 28 : 36),
            SizedBox(height: 6),
            Text(label, style: AppTypography.titleSmall.copyWith(fontSize: isMobile ? 13 : 16)),
            SizedBox(height: 4),
            Text(value, style: AppTypography.titleLarge.apply(color: color, fontSizeFactor: isMobile ? 1.1 : 1.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCardPastel(Product product) {
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Row(
          children: [
            // Avatar produit (icône ou image)
            CircleAvatar(
              radius: 28,
              backgroundColor: badgeColor.withOpacity(0.13),
              child: Icon(Icons.shopping_bag, color: badgeColor, size: 32),
            ),
            SizedBox(width: AppSpacings.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name ?? '', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.category, size: 14, color: AppColors.primaryColor),
                            SizedBox(width: 4),
                            Text(product.categoryLink.value?.name ?? '', style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('SKU: ${product.sku ?? '-'}', style: AppTypography.bodySmall.apply(color: AppColors.greyMedium)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: badgeColor.withOpacity(0.18),
                  child: Text(
                    '${product.stockQuantity ?? 0}',
                    style: AppTypography.titleLarge.copyWith(color: badgeColor, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4),
                Text(badgeText, style: AppTypography.bodySmall.copyWith(color: badgeColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProductCard(Product product, bool isMobile) {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 20 : 32)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : AppSpacings.l),
        child: Row(
          children: [
            CircleAvatar(
              radius: isMobile ? 22 : 28,
              backgroundColor: badgeColor.withOpacity(0.13),
              child: Icon(Icons.shopping_bag, color: badgeColor, size: isMobile ? 22 : 32),
            ),
            SizedBox(width: isMobile ? 10 : AppSpacings.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name ?? '', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold, fontSize: isMobile ? 15 : 20)),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.category, size: 13, color: AppColors.primaryColor),
                            SizedBox(width: 2),
                            Text(product.categoryLink.value?.name ?? '', style: AppTypography.bodySmall.copyWith(fontSize: isMobile ? 11 : 13)),
                          ],
                        ),
                      ),
                      SizedBox(width: 6),
                      Text('SKU: ${product.sku ?? '-'}', style: AppTypography.bodySmall.apply(color: AppColors.greyMedium, fontSizeFactor: isMobile ? 0.95 : 1)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: isMobile ? 16 : 22,
                  backgroundColor: badgeColor.withOpacity(0.18),
                  child: Text(
                    '${product.stockQuantity ?? 0}',
                    style: AppTypography.titleLarge.copyWith(color: badgeColor, fontWeight: FontWeight.bold, fontSize: isMobile ? 13 : 18),
                  ),
                ),
                SizedBox(height: 2),
                Text(badgeText, style: AppTypography.bodySmall.copyWith(color: badgeColor, fontSize: isMobile ? 10 : 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomStats(IventoryController controller) {
    // Exemple : top 3 produits en stock, valeur par catégorie
    final topProducts = controller.filteredProducts.toList()
      ..sort((a, b) => (b.stockQuantity ?? 0).compareTo(a.stockQuantity ?? 0));
    final top3 = topProducts.take(3).toList();
    final Map<String, double> valueByCategory = {};
    for (final p in controller.filteredProducts) {
      final cat = p.categoryLink.value?.name ?? 'Autre';
      valueByCategory[cat] = (valueByCategory[cat] ?? 0) + ((p.stockQuantity ?? 0) * (p.salePrice ?? 0));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top 3 produits en stock', style: AppTypography.titleMedium),
        ...top3.map((p) => Text('${p.name} : ${p.stockQuantity ?? 0}', style: AppTypography.bodyMedium)),
        SizedBox(height: AppSpacings.l),
        Text('Valeur du stock par catégorie', style: AppTypography.titleMedium),
        ...valueByCategory.entries.map((e) => Text('${e.key} : ${e.value.toStringAsFixed(2)} FCFA', style: AppTypography.bodyMedium)),
        SizedBox(height: AppSpacings.xxl),
      ],
    );
  }

  Widget _buildTotalValueCard(IventoryController controller) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: AppRadius.defaultRadius,
      ),
      child: Column(
        children: [
          Text('Valeur Totale du Stock', style: AppTypography.titleMedium),
          SizedBox(height: AppSpacings.s),
          Text(
            '${controller.totalStockValue.toStringAsFixed(2)} FCFA',
            style: AppTypography.titleLarge.apply(
              color: AppColors.primaryDarker,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: AppRadius.defaultRadius,
      ),
      child: Column(
        children: [
          Text(title, style: AppTypography.titleSmall),
          SizedBox(height: AppSpacings.m),
          Text(value, style: AppTypography.titleLarge.apply(color: color)),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacings.l,
        horizontal: AppSpacings.m,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppRadius.defaultRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDarker),
          SizedBox(width: AppSpacings.xl),
          Text(
            label,
            style: AppTypography.titleMedium.apply(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, IventoryController controller) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Inventaire', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Date : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 16),
            pw.Text('Valeur totale : ${controller.totalStockValue.toStringAsFixed(2)} FCFA', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Nom', 'Catégorie', 'Stock', 'Prix', 'Valeur'],
              data: controller.filteredProducts.map((p) => [
                p.name ?? '',
                p.categoryLink.value?.name ?? '',
                (p.stockQuantity ?? 0).toString(),
                '${p.salePrice?.toStringAsFixed(2) ?? ''} FCFA',
                ((p.stockQuantity ?? 0) * (p.salePrice ?? 0)).toStringAsFixed(2),
              ]).toList(),
            ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> _showManualAdjustmentSheet(BuildContext context, IventoryController controller) async {
    final _formKey = GlobalKey<FormState>();
    Product? selectedProduct;
    int? quantity;
    String? reason;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Ajustement Manuel', style: AppTypography.titleLarge, textAlign: TextAlign.center),
                SizedBox(height: 18),
                DropdownButtonFormField<Product>(
                  value: selectedProduct,
                  items: controller.products.map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.name ?? ''),
                  )).toList(),
                  onChanged: (p) => selectedProduct = p,
                  decoration: InputDecoration(
                    labelText: 'Produit',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null ? 'Sélectionner un produit' : null,
                ),
                SizedBox(height: 14),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantité (positif = entrée, négatif = sortie)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) => quantity = int.tryParse(v),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n == 0) return 'Entrer une quantité ≠ 0';
                    return null;
                  },
                ),
                SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: reason,
                  items: ['Casse', 'Vol', 'Erreur', 'Autre']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => reason = v,
                  decoration: InputDecoration(
                    labelText: 'Raison',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null ? 'Sélectionner une raison' : null,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(ctx).pop();
                      await controller.productService.updateStock(
                        productId: selectedProduct!.id!,
                        quantityChange: quantity!,
                        movementType: quantity! > 0 ? InventoryMovementTypeIsar.adjustmentIn : InventoryMovementTypeIsar.adjustmentOut,
                        reason: reason,
                      );
                      await controller.loadProducts();
                      Get.snackbar('Succès', 'Ajustement appliqué', backgroundColor: AppColors.successColor, colorText: AppColors.textOnPrimary, icon: Icon(Icons.check_circle, color: Colors.white));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

