// import 'package:flutter/material.dart';
// // import 'package:flutter_application_1/customs/app_constante.dart';
// import 'package:flutter_application_1/helpers/app_constante.dart';
// import 'package:flutter_application_1/views/list_client_view.dart';
// // import 'package:flutter_application_1/views/list_products_view.dart';
// // import 'package:flutter_application_1/views/list_supplier_view.dart';
// // import 'package:flutter_application_1/views/new_salescreen_view.dart';
// // import 'package:flutter_application_1/views/report_expense_view.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Accueil', style: AppTypography.titleLarge),),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(AppSpacings.xxl),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSalesCard(),
//             SizedBox(height: AppSpacings.xxl),

//             Text('Accès Rapides', style: AppTypography.titleLarge),
//             SizedBox(height: AppSpacings.xl),
//             _buildQuickAccessGrid(context),
//             SizedBox(height: AppSpacings.xxxl),

//             Text('Alertes Récentes', style: AppTypography.titleLarge),
//             SizedBox(height: AppSpacings.xxl),
//             _buildAlertsList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSalesCard() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(AppSpacings.xxxl),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Ventes du jour', style: AppTypography.titleMedium),
//             SizedBox(height: AppSpacings.xxl),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('12500.75 fcfa ', style: AppTypography.titleLarge),
//                 Icon(
//                   AppIcons.chart,
//                   color: AppColors.primaryDarker,
//                   size: AppSpacings.xxxxl,
//                 ),
//                 // Icon(App, color: Colors.indigo[400], size: 28),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickAccessGrid(BuildContext context) {
//     final quickActions = [
//       {
//         'icon': Icons.outbox_rounded,
//         'label': 'nouvelle commande',
//         'onTap': () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NewSaleScreen()),
//           );
//         },
//       },
//       {
//         'icon': Icons.point_of_sale,
//         'label': 'Nouvelle Vente',
//         'onTap': () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NewSaleScreen()),
//           );
//         },
//       },
//       {
//         'icon': Icons.inventory,
//         'label': 'Produits',
//         'onTap': () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ProductListScreen()),
//           );
//         },
//       },
//       {
//         'icon': Icons.reset_tv,
//         'label': 'gestion des depenses',
//         'onTap': () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ExpenseReportScreen()),
//           );
//         },
//       },
//       {
//         'icon': AppIcons.suppliers,
//         'label': 'Fournisseurs',
//         'onTap': () {
//              Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SupplierListScreen()),
//           );
          
//         },
//       },
//       {
//         'icon': AppIcons.person,
//         'label': 'Clients',
//         'onTap': () {
//                 Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ClientListScreen()),
//           );
          
//         },
//       },
//     ];

//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       childAspectRatio: 1,
//       children:
//           quickActions.map((action) {
//             return Card(
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: action['onTap'] as Function(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         action['icon'] as IconData,
//                         size: 32,
//                         color: Colors.indigo[400],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         action['label'] as String,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//     );
//   }

//   Widget _buildAlertsList() {
//     final alerts = [
//       {'title': 'Stock bas: Pommes Gala', 'detail': 'Plus que 5 unités'},
//       {'title': 'Paiement en retard', 'detail': 'Commande #4587'},
//       {'title': 'Nouveau message', 'detail': 'De Jean Dupont'},
//     ];

//     return Column(
//       children:
//           alerts.map((alert) {
//             return Card(
//               margin: const EdgeInsets.only(bottom: AppSpacings.xxl),
//               child: ListTile(
//                 leading: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.red[50],
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     AppIcons.warning,
//                     color: AppColors.errorColor,
//                     size: AppSpacings.xxxl,
//                   ),
//                 ),
//                 title: Text(
//                   alert['title'] as String,
//                   style: AppTypography.titleMedium,
//                 ),
//                 subtitle: Text(
//                   alert['detail'] as String,
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//                 trailing: const Icon(AppIcons.arrow, size: AppSpacings.xxl),
//               ),
//             );
//           }).toList(),
//     );
//   }
// }
