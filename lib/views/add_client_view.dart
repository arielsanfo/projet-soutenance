import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';



class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        title:  Text('Nouveau Client'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:  EdgeInsets.all(AppSpacings.l),
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
                      controller: _firstNameController,
                      decoration:  InputDecoration(
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
                      controller: _lastNameController,
                      decoration:  InputDecoration(
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
                      controller: _emailController,
                      decoration:  InputDecoration(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && !value.contains('@')) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                    ),
                          SizedBox(height: AppSpacings.s),

                    // Champ Téléphone
                    TextFormField(
                      controller: _phoneController,
                      decoration:  InputDecoration(
                        hintText: 'Téléphone',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacings.s),

                    // Champ Adresse
                    TextFormField(
                      controller: _addressController,
                      decoration:  InputDecoration(
                        hintText: 'Adresse complète',
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: AppSpacings.s),

                    // Champ Notes
                    TextFormField(
                      controller: _notesController,
                      decoration:  InputDecoration(
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
              padding:  EdgeInsets.all(AppSpacings.xl),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  backgroundColor: AppColors.primaryColor,
                  minimumSize:  Size(double.infinity, AppSpacings.xxl),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.m),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveCustomer();
                  }
                },
                child:  Text(
                  'Enregistrer Client',
                  style: AppTypography.bodyMedium.apply(color: AppColors.textOnPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCustomer() {
    // Logique d'enregistrement du client
    final newCustomer = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'notes': _notesController.text,
    };

    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
        content: Text('Client enregistré avec succès'),
        duration: Duration(seconds: AppSpacings.l.toInt()),
      ),
    );

    // Effacer les champs après enregistrement
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _notesController.clear();
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