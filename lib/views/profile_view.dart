import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';
import 'package:flutter_application_1/views/login_view.dart';
import 'package:flutter_application_1/views/sign_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                      'AR',
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
                  'Ariel Sanfo',
                  style: AppTypography.titleMedium.apply(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacings.l),

              const Center(
                child: Text(
                  'arielsanfo@gmail.com',
                  style: AppTypography.titleSmall,
                ),
              ),
              const SizedBox(height: AppSpacings.xxxxl),

              _buildInfoCard(
                icon: Icons.person_outline,
                label: 'Rôle',
                value: 'Administrateur',
              ),
              SizedBox(height: AppSpacings.l),

              _buildInfoCard(
                icon: Icons.calendar_today,
                label: 'Membre depuis',
                value: '12 Mars 2020',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignView()),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
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
            icon: Icon(icon, color: AppColors.primaryDarker),
          ),
          // IconButton(icon, color: AppColors.primaryDarker),
        ],
      ),
    );
  }
}
