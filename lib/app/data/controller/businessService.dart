import 'package:isar/isar.dart';
import '../storage.dart';

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Informations de l'Entreprise (BusinessService)
//----------------------------------------------------------------------------//
class BusinessService {
  final Isar isar;
  BusinessService(this.isar);
  
  /// Sauvegarder les détails de l'entreprise.
  Future<BusinessDetails> saveDetails(BusinessDetails details) async {
    await isar.writeTxn(() => isar.businessDetails.put(details));
    return details;
  }
  
  /// Obtenir les détails de l'entreprise (il n'y en a qu'un).
  Future<BusinessDetails?> getDetails() async {
    return await isar.businessDetails.get(BusinessDetails.fixedId);
  }
}