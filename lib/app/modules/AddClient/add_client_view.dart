import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'add_client_controller.dart';

class AddClientView extends GetView<AddClientController> {
  const AddClientView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditMode = Get.arguments != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(AppIcons.backArrow, color: AppColors.textSecondary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEditMode ? 'Modifier Client' : 'Nouveau Client',
          style: AppTypography.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Header avec illustration
            Container(
              padding: EdgeInsets.all(AppSpacings.xl),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacings.m),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryDarker,
                        ],
                      ),
                      borderRadius: AppRadius.circular,
                    ),
                    child: Icon(
                      isEditMode ? AppIcons.edit : AppIcons.person,
                      color: AppColors.textOnPrimary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: AppSpacings.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditMode ? 'Modifier Client' : 'Nouveau Client',
                          style: AppTypography.titleLarge,
                        ),
                        SizedBox(height: AppSpacings.xs),
                        Text(
                          isEditMode
                              ? 'Mettez à jour les informations'
                              : 'Ajoutez un nouveau client',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Formulaire
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacings.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Informations Personnelles
                    _buildSectionCard(
                      title: 'Informations Clients',
                      icon: AppIcons.person,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.firstNameController,
                                label: 'Prénom',
                                icon: AppIcons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un prénom';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: AppSpacings.m),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.lastNameController,
                                label: 'Nom',
                                icon: AppIcons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un nom';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacings.xl),

                    // Section Contact
                    _buildSectionCard(
                      title: 'Informations de Contact',
                      icon: AppIcons.email,
                      children: [
                        _buildTextField(
                          controller: controller.emailController,
                          label: 'Adresse email',
                          icon: AppIcons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                !value.contains('@')) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacings.l),
                        _buildTextField(
                          controller: controller.phoneController,
                          label: 'Numéro de téléphone',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacings.xl),

                    // Section Adresse
                    _buildSectionCard(
                      title: 'Adresse',
                      icon: Icons.location_on_outlined,
                      children: [
                        _buildTextField(
                          controller: controller.addressController,
                          label: 'Adresse complète',
                          icon: Icons.home_outlined,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacings.xl),

                    // Section Notes
                    _buildSectionCard(
                      title: 'Notes supplémentaires',
                      icon: Icons.note_outlined,
                      children: [
                        _buildTextField(
                          controller: controller.notesController,
                          label: 'Notes (facultatif)',
                          icon: AppIcons.edit,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bouton Enregistrer
            Container(
              padding: EdgeInsets.all(AppSpacings.xl),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryDarker,
                    ],
                  ),
                  borderRadius: AppRadius.large,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.formKey.currentState!.validate()) {
                      await controller.saveCustomer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                isEditMode ? AppIcons.success : AppIcons.person,
                                color: AppColors.textOnPrimary,
                              ),
                              SizedBox(width: AppSpacings.m),
                              Text(
                                isEditMode
                                    ? 'Client modifié avec succès'
                                    : 'Client enregistré avec succès',
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.accentColor,
                          duration: AppDurations.snackbarDuration,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                          ),
                        ),
                      );
                      Get.offAllNamed(Routes.CLIENT_LIST);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.large,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isEditMode ? AppIcons.edit : AppIcons.person,
                        color: AppColors.textOnPrimary,
                        size: 24,
                      ),
                      SizedBox(width: AppSpacings.m),
                      Text(
                        isEditMode ? 'Modifier Client' : 'Enregistrer Client',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: AppRadius.large,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacings.s),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: AppRadius.small,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacings.m),
              Text(
                title,
                style: AppTypography.titleMedium,
              ),
            ],
          ),
          SizedBox(height: AppSpacings.xl),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textLight,
        ),
        prefixIcon: Container(
          margin: EdgeInsets.only(right: AppSpacings.m),
          padding: EdgeInsets.all(AppSpacings.s),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: AppRadius.small,
          ),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: AppColors.backgroundInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.rDefault),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.rDefault),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.rDefault),
          borderSide: BorderSide(
            color: AppColors.errorColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.rDefault),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacings.l,
          vertical: AppSpacings.l,
        ),
      ),
    );
  }
}

// DropdownButtonFormField<String>(
//   decoration: const InputDecoration(hintText: 'Pays'),
//   items: ['France', 'Belgique', 'Suisse']
//       .map((country) => DropdownMenuItem(
//             value: country,
//             child: Text(country),
//           ))
//       .toList(),
//   onChanged: (value) {},
// )
// IconButton(
//   onPressed: () async {
//     final image = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (image != null) {
//       // Traiter l'image
//     }
//   },
//   icon: const Icon(Icons.camera_alt),
// )
// AnimatedContainer(
//   duration: const Duration(milliseconds: 300),
//   height: _showAdditionalFields ? 200 : 0,
//   child: /* Vos champs supplémentaires */
// )
