import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';
// import 'package:intl/intl.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final List<Client> clients = [
    Client(
      id: '1',
      firstName: 'Alexandre',
      lastName: 'Dupont',
      email: 'alex.d@example.com',
      lastPurchase: DateTime(2024, 5, 5),
      debt: 12.0,
    ),
    Client(
      id: '2',
      firstName: 'Sophie',
      lastName: 'Martin',
      email: 'sophie.m@example.com',
      lastPurchase: DateTime(2024, 5, 10),
      debt: 0.0,
    ),
    Client(
      id: '3',
      firstName: 'Thomas',
      lastName: 'Leroy',
      email: 'thomas.l@example.com',
      lastPurchase: DateTime(2024, 4, 28),
      debt: 45.50,
    ),
    Client(
      id: '4',
      firstName: 'Émilie',
      lastName: 'Bernard',
      email: 'emilie.b@example.com',
      lastPurchase: DateTime(2024, 5, 12),
      debt: 0.0,
    ),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredClients =
        clients.where((client) {
          final fullName =
              '${client.firstName} ${client.lastName}'.toLowerCase();
          return fullName.contains(searchQuery.toLowerCase());
        }).toList();

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
                    setState(() {
                      searchQuery = value;
                    });
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
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  final client = filteredClients[index];
                  return ClientCard(client: client);
                },
              ),
            ),
          ),
        ],
      ),

      // Bouton d'ajout
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(AppIcons.person, size: AppSpacings.xxxl),
        label: Text('Ajouter un Client'),
        backgroundColor: Theme.of(context).primaryColor,
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
        onTap: () {},
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
                            color:
                                hasDebt
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

class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime lastPurchase;
  final double debt;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.lastPurchase,
    required this.debt,
  });
}
