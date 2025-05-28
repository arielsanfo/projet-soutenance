import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';
import 'package:iconsax/iconsax.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonjour John !', style: AppTypography.titleMedium),
            Text(
              'Voici le résumé de vos ventes...',
              style: AppTypography.bodyMedium.apply(color: AppColors.greyDark),
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Sales Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacings.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ventes du Jour',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: AppSpacings.s),
                    Text(
                      '567.89 €',
                      style: AppTypography.titleMedium.apply(
                        color: AppColors.accentColor,
                      ),
                    ),
                    SizedBox(height: AppSpacings.s),
                    Row(
                      children: [
                        Text(
                          '10 Ventes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: AppSpacings.l),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Colors.green.shade400,
                              size: 20,
                            ),
                            SizedBox(width: AppSpacings.s),
                            Text(
                              '+5%',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Key Stats Section
            SizedBox(height: AppSpacings.l),
            Text('Statistiques Clés', style: AppTypography.titleMedium),
            SizedBox(height: AppSpacings.s),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacings.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Marge Brute',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: AppSpacings.s),
                          Text(
                            '35%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacings.l),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacings.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Panier Moyen',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: AppSpacings.s),
                          Text(
                            '56.78 €',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Quick Navigation Section
            SizedBox(height: AppSpacings.l),
            Text(
              'Navigation Rapide',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacings.s),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildQuickActionButton(
                  icon: Iconsax.shopping_cart,
                  label: 'Nouvelle Vente',
                  color: AppColors.accentColor,
                ),
                _buildQuickActionButton(
                  icon: Iconsax.people,
                  label: 'Clients',
                  color: AppColors.accentColor,
                ),
                _buildQuickActionButton(
                  icon: Iconsax.box,
                  label: 'Inventaire',
                  color: AppColors.accentColor,
                ),
                _buildQuickActionButton(
                  icon: Iconsax.document_text,
                  label: 'Commandes',
                  color: AppColors.accentColor,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Rapports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacings.m),
        onTap: () {
          // Handle button tap
        },
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSpacings.l, color: color),
              SizedBox(height: AppSpacings.s),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.apply(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
