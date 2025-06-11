import 'package:flutter/material.dart';
import '../../lib/helpers/app_constante.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Sale> _sales = [];
  List<Sale> _filteredSales = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSales(); // Simule le chargement des données
  }

  void _loadSales() {
    // Données simulées
    _sales = [
      Sale(id: '202400125', client: 'A. Dupont', date: '05 Mai 2024, 14:30', amount: 35.50, isPaid: true),
      Sale(id: '202400124', client: 'B. Martin', date: '04 Mai 2024, 10:15', amount: 42.80, isPaid: false),
      Sale(id: '202400123', client: 'C. Leroy', date: '03 Mai 2024, 16:45', amount: 19.99, isPaid: true),
    ];
    _filteredSales = _sales;
  }

  void _filterSales(String query) {
    setState(() {
      _filteredSales = _sales.where((sale) =>
          sale.id.contains(query) || sale.client.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Historique des Ventes'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
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
              controller: _searchController,
              onChanged: _filterSales,
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
              controller: _tabController,
              children: [
                _buildSalesList(_filteredSales), // Toutes
                _buildSalesList(_filteredSales.where((s) => s.isPaid).toList()), // Payées
                _buildSalesList(_filteredSales.where((s) => !s.isPaid).toList()), // En attente
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

class Sale {
  final String id;
  final String client;
  final String date;
  final double amount;
  final bool isPaid;

  Sale({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.isPaid,
  });
}