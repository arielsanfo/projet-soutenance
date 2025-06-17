import 'package:get/get.dart';

class ClientListController extends GetxController {
  final RxString searchQuery = ''.obs;
  late final RxList<Client> filteredClients;

  @override
  void onInit() {
    super.onInit();
    filteredClients = clients.obs;
    ever(searchQuery, (_) => _filterClients());
  }

  void _filterClients() {
    filteredClients.value = clients.where((client) {
      final fullName = '${client.firstName} ${client.lastName}'.toLowerCase();
      return fullName.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  final List<Client> clients = [
    Client(
      id: '1',
      firstName: 'Alexandre',
      lastName: 'Dupont',
      email: 'alex.d@example.com',
      lastPurchase: DateTime(2024, 5, 5),
      debt: 12.0,
    ),
    Client(
      id: '2',
      firstName: 'Sophie',
      lastName: 'Martin',
      email: 'sophie.m@example.com',
      lastPurchase: DateTime(2024, 5, 10),
      debt: 0.0,
    ),
    Client(
      id: '3',
      firstName: 'Thomas',
      lastName: 'Leroy',
      email: 'thomas.l@example.com',
      lastPurchase: DateTime(2024, 4, 28),
      debt: 45.50,
    ),
    Client(
      id: '4',
      firstName: 'Émilie',
      lastName: 'Bernard',
      email: 'emilie.b@example.com',
      lastPurchase: DateTime(2024, 5, 12),
      debt: 0.0,
    ),
  ];

  final count = 0.obs;
  // @override
  // void onInit() {
  //   super.onInit();
  // }

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

class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime lastPurchase;
  final double debt;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.lastPurchase,
    required this.debt,
  });
}

String searchQuery = '';
