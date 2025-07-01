import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'management_role_controller.dart';

class ManagementRoleView extends GetView<ManagementRoleController> {
   ManagementRoleView({super.key}){
        Get.lazyPut(() => ManagementRoleView());

  }

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
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
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
                    // setState(() {
                      controller.users[controller.users.indexOf(user)].role = newValue!;
                    // });
                  },
                  items:
                      controller.roles.map<DropdownMenuItem<String>>((String value) {
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
      (150 + random.nextInt(106)) ,
      (150 + random.nextInt(106)) ,
      (150 + random.nextInt(106)) ,
      1,
    );
  }
}



// Add this import if not already present
