import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
   HistoryView({super.key}){
        Get.lazyPut(() => HistoryView());

  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Historique des Ventes'),
        centerTitle: true,
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: 'Toutes'),
            Tab(text: 'Payées'),
            Tab(text: 'En attente'),
          ],
          labelColor: Colors.deepPurple, // Couleur pour l'onglet actif
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue, // Soulignement
        ),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding:  EdgeInsets.all(AppSpacings.m),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.filterSales,
              decoration: InputDecoration(
                hintText: 'Rechercher par ID, client...',
                prefixIcon:  Icon(AppIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Liste des ventes (filtrée par onglet)
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildSalesList(controller.filteredSales), // Toutes
                _buildSalesList(controller.filteredSales.where((s) => s.isPaid).toList()), // Payées
                _buildSalesList(controller.filteredSales.where((s) => !s.isPaid).toList()), // En attente
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesList(List<Sale> sales) {
    return ListView.builder(
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return _buildSaleCard(sale);
      },
    );
  }

  Widget _buildSaleCard(Sale sale) {
    return Card(
      margin:  EdgeInsets.symmetric(horizontal: AppSpacings.l, vertical: AppSpacings.m),
      child: Padding(
        padding:  EdgeInsets.all(AppSpacings.l),
        child: Row(
          children: [
            // Icône
            Icon(AppIcons.ript, color: AppColors.primaryColor, size: AppSpacings.xxxxl ),
             SizedBox(width: AppSpacings.l),
            // Détails
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vente #${sale.id}', style: AppTypography.titleSmall),
                  Text('Client : ${sale.client}'),
                  Text(sale.date, style: TextStyle(color:AppColors.greyMedium)),
                ],
              ),
            ),
            // Montant et statut
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${sale.amount} f', style:  AppTypography.titleSmall),
                 SizedBox(height: AppSpacings.m),
                Container(
                  padding:  EdgeInsets.symmetric(horizontal: AppSpacings.m, vertical: AppSpacings.s),
                  decoration: BoxDecoration(
                    color: sale.isPaid ? AppColors.borderMedium : AppColors.warningColor,
                    borderRadius: AppRadius.defaultRadius,
                  ),
                  child: Text(
                    sale.isPaid ? 'Payée' : 'En attente',
                    style: TextStyle(
                      color: sale.isPaid ? AppColors.accentColor :AppColors.greyDark,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

