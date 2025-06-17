import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'client_list_controller.dart';

class ClientListView extends GetView<ClientListController> {
  const ClientListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyMedium,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text('Clients', style: AppTypography.titleLarge),
                SizedBox(height: AppSpacings.m),
                SearchBar(
                  hintText: 'Rechercher un client...',
                  onChanged: (value) {
                    // setState(() {
                    //   searchQuery = value;
                    // });
                  },
                ),
              ],
            ),
          ),

          // Liste des clients
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: controller.filteredClients.length,
                itemBuilder: (context, index) {
                  final client = controller.filteredClients[index];
                  return ClientCard(client: client);
                },
              ),
            ),
          ),
        ],
      ),

      // Bouton d'ajout
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.ADD_CLIENT);
        },
        icon: Icon(AppIcons.person, size: AppSpacings.xxxl),
        label: Text('Ajouter un Client'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.backgroundWhite,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.defaultRadius),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class SearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchBar({super.key, required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search, size: AppSpacings.xxxl),
        filled: true,
        fillColor: AppColors.primaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.m),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: AppSpacings.l,
          horizontal: AppSpacings.m,
        ),
      ),
    );
  }
}

class ClientCard extends StatelessWidget {
  final Client client;

  const ClientCard({super.key, required this.client});

  get lastPurchase => null;

  @override
  Widget build(BuildContext context) {
    final initials = '${client.firstName[0]}${client.lastName[0]}';
    // final lastPurchase = DateFormat('dd/MM/yyyy').format(client.lastPurchase);
    final hasDebt = client.debt > 0;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          //
        },
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Row(
            children: [
              // Avatar avec initiales
              Container(
                width: AppSpacings.xxxl * 1.5,
                height: AppSpacings.xxxl * 1.5,
                decoration: BoxDecoration(
                  color: _getAvatarColor(client.id),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(initials, style: AppTypography.titleSmall),
                ),
              ),
              SizedBox(width: AppSpacings.m),

              // Détails du client
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${client.firstName} ${client.lastName}',
                      style: AppTypography.titleMedium,
                    ),
                    SizedBox(height: AppSpacings.m),
                    Text(client.email, style: AppTypography.bodySmall),
                    SizedBox(height: AppSpacings.s),
                    Row(
                      children: [
                        Text(
                          'Dernier achat: $lastPurchase',
                          style: AppTypography.bodySmall,
                        ),
                        SizedBox(width: AppSpacings.s),
                        Container(
                          width: AppSpacings.s,
                          height: AppSpacings.xl,
                          color: AppColors.greyMedium,
                        ),
                        SizedBox(width: AppSpacings.xl),
                        Text(
                          'dettes: ${client.debt.toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontSize: 6,
                            color: hasDebt
                                ? AppColors.errorColor
                                : AppColors.accentColor,
                            fontWeight:
                                hasDebt ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Icône de flèche
              Icon(
                AppIcons.chevron_right,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
    // )
    // );
  }

  Color _getAvatarColor(String id) {
    final colors = [
      Colors.blue.shade500,
      Colors.green.shade500,
      Colors.orange.shade500,
      Colors.purple.shade500,
      Colors.teal.shade500,
    ];
    return colors[int.parse(id) % colors.length];
  }
}
