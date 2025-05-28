import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_application_1/customs/app_constante.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  // Sample user data
  final List<User> users = [
    User(
      id: '1',
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      role: 'Admin',
      isCurrentUser: true,
    ),
    User(
      id: '2',
      fullName: 'Alice Lemoine',
      email: 'alice.l@example.com',
      role: 'Employé',
      isCurrentUser: false,
    ),
    User(
      id: '3',
      fullName: 'Bob Richard',
      email: 'bob.r@example.com',
      role: 'Employé',
      isCurrentUser: false,
    ),
    User(
      id: '4',
      fullName: 'Sophie Martin',
      email: 'sophie.m@example.com',
      role: 'Manager',
      isCurrentUser: false,
    ),
    User(
      id: '5',
      fullName: 'Thomas Bernard',
      email: 'thomas.b@example.com',
      role: 'Employé',
      isCurrentUser: false,
    ),
  ];

  // Available roles for dropdown
  final List<String> roles = ['Admin', 'Manager', 'Employé'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(
          'Gestion des Rôles (Admin)',
          style: AppTypography.titleMedium,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppSpacings.xl),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserCard(user);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacings.l),
            child: ElevatedButton(
              onPressed: () {
                // Handle invite new user
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: Size(double.infinity, AppSpacings.xxxxl * 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.defaultRadius,
                ),
              ),
              child: Text(
                'Inviter un Nouvel Utilisateur',
                style: AppTypography.titleSmall.apply(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(User user) {
    // Generate initials from full name
    final initials =
        user.fullName
            .split(' ')
            .map((name) => name[0])
            .take(2)
            .join()
            .toUpperCase();

    // Generate pastel color based on user id hash
    final color = _generatePastelColor(user.id.hashCode);

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacings.s),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.defaultRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Row(
          children: [
            // Avatar with initials
            Container(
              width: AppSpacings.xxxl,
              height: AppSpacings.xxxl,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: Text(initials, style: AppTypography.titleSmall),
              ),
            ),
            SizedBox(width: AppSpacings.l),
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user.fullName, style: AppTypography.titleSmall),
                      if (user.isCurrentUser) ...[
                        SizedBox(width: AppSpacings.m),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacings.m,
                            vertical: AppSpacings.m,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greyLight,
                            borderRadius: AppRadius.defaultRadius,
                          ),
                          child: Text(
                            'Vous',
                            style: AppTypography.bodyMedium.apply(
                              color: AppColors.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: AppSpacings.m),
                  Text(
                    user.email,
                    style: AppTypography.bodyMedium.apply(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Role selector
            if (user.isCurrentUser)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.m,
                  vertical: AppSpacings.s,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: AppRadius.defaultRadius,
                ),
                child: Text(user.role, style: AppTypography.titleSmall),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s),
                decoration: BoxDecoration(
                  color: AppColors.backgroundInput,
                  borderRadius: AppRadius.defaultRadius,
                  border: Border.all(color: AppColors.greyLight),
                ),
                child: DropdownButton<String>(
                  value: user.role,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.greyMedium,
                  ),
                  iconSize: 25,
                  elevation: 0,
                  underline: SizedBox(),
                  style: AppTypography.bodyMedium,
                  onChanged: (String? newValue) {
                    setState(() {
                      users[users.indexOf(user)].role = newValue!;
                    });
                  },
                  items:
                      roles.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper function to generate pastel colors
  Color _generatePastelColor(int seed) {
    final random = Random(seed);
    return Color.fromRGBO(
      150 + random.nextInt(106),
      150 + random.nextInt(106),
      150 + random.nextInt(106),
      1,
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  String role;
  final bool isCurrentUser;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isCurrentUser,
  });
}

// Add this import if not already present
