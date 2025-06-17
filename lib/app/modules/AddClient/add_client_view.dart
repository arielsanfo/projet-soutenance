import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'add_client_controller.dart';

class AddClientView extends GetView<AddClientController> {
  const AddClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        title: Text('Nouveau Client'),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacings.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Informations Client
                    Text(
                      'Informations du Client',
                      style: AppTypography.titleMedium,
                    ),
                    SizedBox(height: AppSpacings.l),

                    // Champ Prénom
                    TextFormField(
                      controller: controller.firstNameController,
                      decoration: InputDecoration(
                        hintText: 'Prénom',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un prénom';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacings.s),

                    // Champ Nom
                    TextFormField(
                      controller: controller.lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Nom',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacings.s),

                    // Champ Email
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
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
                    SizedBox(height: AppSpacings.s),

                    // Champ Téléphone
                    TextFormField(
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                        hintText: 'Téléphone',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacings.s),

                    // Champ Adresse
                    TextFormField(
                      controller: controller.addressController,
                      decoration: InputDecoration(
                        hintText: 'Adresse complète',
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: AppSpacings.s),

                    // Champ Notes
                    TextFormField(
                      controller: controller.notesController,
                      decoration: InputDecoration(
                        hintText: 'Notes (Facultatif)',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // Bouton Enregistrer
            Padding(
              padding: EdgeInsets.all(AppSpacings.xl),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size(double.infinity, AppSpacings.xxl),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.m),
                  ),
                ),
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    _saveCustomer(context);
                    //
                    Get.toNamed(Routes.DETAILS_CLIENT);
                  }
                },
                child: Text(
                  'Enregistrer Client',
                  style: AppTypography.bodyMedium
                      .apply(color: AppColors.textOnPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCustomer(BuildContext context) {
    // Logique d'enregistrement du client
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Client enregistré avec succès'),
        duration: Duration(seconds: AppSpacings.l.toInt()),
      ),
    );
    // ignore: unused_local_variable
    final newCustomer = {
      'firstName': controller.firstNameController.text,
      'lastName': controller.lastNameController.text,
      'email': controller.emailController.text,
      'phone': controller.phoneController.text,
      'address': controller.addressController.text,
      'notes': controller.notesController.text,
    };

    // Afficher un message de confirmation

    // Effacer les champs après enregistrement
    controller.firstNameController.clear();
    controller.lastNameController.clear();
    controller.emailController.clear();
    controller.phoneController.clear();
    controller.notesController.clear();
    controller.addressController.clear();
    controller.notesController.clear();
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
