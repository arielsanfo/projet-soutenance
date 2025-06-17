import 'package:get/get.dart';
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
class ManagementRoleController extends GetxController {
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

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
