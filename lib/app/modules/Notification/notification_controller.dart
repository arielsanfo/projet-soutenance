import 'package:flutter/material.dart';
import 'package:get/get.dart';
class NotificationItem {
  String id;
  String title;
  String description;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isRead,
  });
}

class NotificationController extends GetxController {
    late TabController tabController;
  int unreadCount = 2;
  int totalCount = 5;

  final List<NotificationItem> allNotifications = [
    NotificationItem(
      id: '1',
      title: 'Nouvelle commande #C20240080',
      description: 'Client: S. Lefevre - Il y a 5 minutes',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Stock bas: Jus de Pomme Bio',
      description: 'Plus que 3 unités - Il y a 1 heure',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Paiement reçu: Vente #C20240075',
      description: 'Client: M. Dubois - Hier',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Retour produit #R20240012',
      description: 'Huile d\'Olive Bio - Il y a 2 jours',
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Inventaire programmé',
      description: 'Prévu pour demain à 9h - Il y a 3 jours',
      isRead: true,
    ),
  ];

// @override

//   void initState() {
//     super.initState()/;
//     tabController = TabController(length: 2, vsync: this);
//   }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void markAllAsRead() {
    // setState(() {
      for (var notification in allNotifications) {
        notification.isRead = true;
      }
      unreadCount = 0;
    // });
  }
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
