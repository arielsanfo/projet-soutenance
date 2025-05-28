import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';

class ReturnDetailsScreen extends StatefulWidget {
  const ReturnDetailsScreen({super.key});

  @override
  State<ReturnDetailsScreen> createState() => _ReturnDetailsScreenState();
}

class _ReturnDetailsScreenState extends State<ReturnDetailsScreen> {
  String selectedStatus = 'En attente';
  final TextEditingController _notesController = TextEditingController();

  final List<String> statusOptions = [
    'En attente',
    'Approuvé',
    'Refusé',
    'En cours de traitement',
    'Terminé',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(
          'Détail Retour #R2024-015',
          style: AppTypography.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Informations du Retour
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Retour #R2024-015', style: AppTypography.titleLarge),
                SizedBox(height: AppSpacings.m),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacings.xl,
                    vertical: AppSpacings.m,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tagBlueBackground,
                    borderRadius: BorderRadius.circular(AppSpacings.l),
                  ),
                  child: Text(
                    selectedStatus,
                    style: AppTypography.titleSmall.apply(
                      color: AppColors.tagOrangeText,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacings.m),
                Text(
                  'Demandé le: 04 Mai 2024',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: AppSpacings.xxl),

            // Section Détails du Retour
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacings.l),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: AppRadius.defaultRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyMedium,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Client', 'Julien Petit'),
                  SizedBox(height: AppSpacings.xl),
                  _buildDetailRow('Produit', 'Café en Grains Bio (1 unité)'),
                  SizedBox(height: AppSpacings.xl),
                  _buildDetailRow('Raison', 'Produit endommagé à la livraison'),
                ],
              ),
            ),
            SizedBox(height: AppSpacings.xxl),

            // Section Action
            Text('Action', style: AppTypography.titleLarge),
            SizedBox(height: AppSpacings.xl),

            // Sélecteur de statut
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: AppSpacings.xl),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: AppRadius.defaultRadius,
              ),
              child: DropdownButton<String>(
                value: selectedStatus,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.greyDark),
                iconSize: 24,
                elevation: 0,
                isExpanded: true,
                underline: SizedBox(),
                style: AppTypography.bodyLarge,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
                items:
                    statusOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
             SizedBox(height: AppSpacings.l),

            // Champ de notes
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Note interne...',
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.m),
                  
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.m),
                  borderSide: BorderSide(color: AppColors.greyMedium, width: 1),
                ),
                contentPadding:  EdgeInsets.all(AppSpacings.l),
              ),
            ),
             SizedBox(height: AppSpacings.xxxl),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.all(AppSpacings.l),
        child: ElevatedButton(
          onPressed: () {
            // Handle status update
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize:  Size(double.infinity, AppSpacings.xxxxl*1.5),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.defaultRadius,
            ),
          ),
          child:  Text(
            'Mettre à jour le statut',
          style: AppTypography.titleSmall.apply(color: AppColors.textOnPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
        style: AppTypography.bodyMedium,
        ),
         SizedBox(height: AppSpacings.s),
        Text(value, style:  TextStyle(fontSize: AppSpacings.l)),
      ],
    );
  }
}
