import 'package:isar/isar.dart';
import '../storage.dart';

//----------------------------------------------------------------------------//
// SERVICE: Gestion des Utilisateurs (UserService)
//----------------------------------------------------------------------------//
class UserService {
  final Isar isar;

  UserService(this.isar);

  /// Créer ou mettre à jour un utilisateur.
  /// Le hachage du mot de passe doit être effectué avant d'appeler cette méthode.
  Future<User> saveUser(User user) async {
    await isar.writeTxn(() async {
      user.updatedAt = DateTime.now();
      await isar.users.put(user);
    });
    return user;
  }

  /// Obtenir un utilisateur par son email (pour la connexion).
  Future<User?> getUserByEmail(String email) async {
    return await isar.users.where().emailEqualTo(email).findFirst();
  }

  /// Obtenir un utilisateur par son ID.
  Future<User?> getUserById(Id id) async {
    return await isar.users.get(id);
  }

  /// Obtenir tous les utilisateurs.
  Future<List<User>> getAllUsers() async {
    return await isar.users.where().findAll();
  }

  /// Supprimer un utilisateur.
  Future<bool> deleteUser(Id id) async {
    // Attention: Pensez aux implications si l'utilisateur est lié à d'autres données.
    return await isar.writeTxn(() async {
      return await isar.users.delete(id);
    });
  }
}
