// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Détails Vente',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         fontFamily: 'Roboto',
//       ),
//       home: const SaleDetailsScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class SaleDetailsScreen extends StatelessWidget {
//   const SaleDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'Détails Vente #202400125',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Section Client
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Client',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Alexandre Dupont',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'alex.d@example.com',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Section Articles
//             const Text(
//               'Articles',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Column(
//               children: [
//                 _buildArticleItem('Pommes Gala Bio (2kg)', '5.98 €'),
//                 const SizedBox(height: 16),
//                 _buildArticleItem('Lait Demi-écrémé (1L)', '1.20 €'),
//                 const SizedBox(height: 16),
//                 _buildArticleItem('Pain Complet (500g)', '2.50 €'),
//                 const SizedBox(height: 16),
//                 _buildArticleItem('Fromage Emmental (250g)', '4.00 €'),
//               ],
//             ),
//             const Divider(height: 32, thickness: 1, color: Colors.grey),

//             // Total
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Total Payé:',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   '13.68 €',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildActionBar(context),
//     );
//   }

//   Widget _buildArticleItem(String name, String price) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 4, right: 12),
//           child: Container(
//             width: 6,
//             height: 6,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 price,
//                 style: TextStyle(
//                   color: Colors.blue[700],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionBar(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: SizedBox(
//                 height: 60,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[200],
//                     foregroundColor: Colors.grey[800],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   onPressed: () {},
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.print, size: 18),
//                       SizedBox(width: 8),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Imprimer'),
//                           Text('Reçu', style: TextStyle(fontSize: 12)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: SizedBox(
//                 height: 60,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).primaryColor,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.replay, size: 18),
//                       SizedBox(width: 8),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Effectuer'),
//                           Text('un Retour', style: TextStyle(fontSize: 12)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }