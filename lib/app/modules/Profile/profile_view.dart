import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import '../../data/storage.dart';

import 'package:get/get.dart';

import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
   ProfileView({super.key}){
    Get.lazyPut(()=>ProfileView());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Title(color:Colors.white, child: Text("Mon Profile")),
      // ),
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mon Profil',
                style: AppTypography.titleLarge.apply(
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: AppSpacings.xxxl),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (controller.currentUser?.name != null &&
                              controller.currentUser!.name!.isNotEmpty)
                          ? controller.currentUser!.name!
                              .substring(0, 2)
                              .toUpperCase()
                          : '--',
                      style: AppTypography.displayLarge.apply(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.xl),
              Center(
                child: Text(
                  controller.currentUser?.name ?? 'Non renseigné',
                  style: AppTypography.titleMedium.apply(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.l),
              Center(
                child: Text(
                  controller.currentUser?.email ?? 'Non renseigné',
                  style: AppTypography.titleSmall,
                ),
              ),
              const SizedBox(height: AppSpacings.xxxxl),
              _buildInfoCard(
                icon: Icons.person_outline,
                label: 'Rôle',
                value: _roleToString(controller.currentUser?.role),
              ),
              SizedBox(height: AppSpacings.l),
              _buildInfoCard(
                icon: Icons.calendar_today,
                label: 'Membre depuis',
                value: _formatDate(controller.currentUser?.createdAt),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showEditProfileDialog(context, controller);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundWhite,
                    foregroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.defaultRadius,
                    ),
                  ),
                  child: Text('Modifier les Informations'),
                ),
              ),
              SizedBox(height: AppSpacings.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tagRedText,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.defaultRadius,
                    ),
                  ),
                  child: Text('Se Déconnecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.defaultRadius,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.titleSmall.apply(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacings.s),
              Text(value, style: AppTypography.titleMedium),
            ],
          ),
          Spacer(),
          IconButton(
              onPressed: () {},
              icon: Icon(
                icon,
                color: AppColors.primaryDarker,
              ))
          // IconButton(icon, color: AppColors.primaryDarker),
        ],
      ),
    );
  }

  String _roleToString(dynamic role) {
    if (role == null) return 'Non renseigné';
    switch (role) {
      case UserRoleIsar.admin:
        return 'Administrateur';
      case UserRoleIsar.manager:
        return 'Manager';
      case UserRoleIsar.employee:
        return 'Employé';
      default:
        return role.toString();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Non renseigné';
    // Format français : 12 Mars 2024
    final months = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  void _showEditProfileDialog(
      BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le profil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(labelText: 'Nom complet'),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: controller.passwordController,
                  decoration:
                      InputDecoration(labelText: 'Nouveau mot de passe'),
                  obscureText: true,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: controller.confirmPasswordController,
                  decoration:
                      InputDecoration(labelText: 'Confirmer le mot de passe'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await controller.updateProfile();
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
