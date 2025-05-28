import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';



class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _unreadCount = 2;
  int _totalCount = 5;

  final List<NotificationItem> _allNotifications = [
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification.isRead = true;
      }
      _unreadCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title:  Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.greyMedium,
          tabs: [
            Tab(text: 'Toutes ($_totalCount)'),
            Tab(text: 'Non lues ($_unreadCount)'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All notifications tab
                _buildNotificationsList(_allNotifications),
                // Unread notifications tab
                _buildNotificationsList(
                    _allNotifications.where((n) => !n.isRead).toList()),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(AppSpacings.m),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _markAllAsRead,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textOnPrimary,
                  side: BorderSide(color: AppColors.greyDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.s),
                  ),
                  padding:  EdgeInsets.symmetric(vertical: AppSpacings.m),
                ),
                child:  Text('Marquer tout comme lu'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('Aucune notification'),
      );
    }

    return ListView.separated(
      padding:  EdgeInsets.only(top: AppSpacings.s),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: AppColors.borderMedium,
      ),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return InkWell(
      onTap: () {
        // Handle notification tap
      },
      child: Container(
        color: notification.isRead ? AppColors.textOnPrimary : AppColors.tagBlueText,
        padding:  EdgeInsets.symmetric(horizontal: AppSpacings.xxl, vertical: AppSpacings.xl),
        child: Row(
          children: [
            if (!notification.isRead)
              Container(
                width: AppSpacings.m,
                height: AppSpacings.m,
                margin:  EdgeInsets.only(right: AppSpacings.l),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              )
            else
               SizedBox(width: AppSpacings.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                   SizedBox(height: AppSpacings.m),
                  Text(
                    notification.description,
                   style: AppTypography.titleSmall.apply(color: AppColors.tagGreenText),
                  ),
                ],
              ),
            ),
             Icon(AppIcons.chevron_right, color: AppColors.greyDark),
          ],
        ),
      ),
    );
  }
}

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