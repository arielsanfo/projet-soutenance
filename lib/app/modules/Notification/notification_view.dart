import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
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
          controller: controller.tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.greyMedium,
          tabs: [
            Tab(text: 'Toutes ($controller.totalCount)'),
            Tab(text: 'Non lues ($controller.unreadCount)'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                // All notifications tab
                _buildNotificationsList(controller.allNotifications),
                // Unread notifications tab
                _buildNotificationsList(
                    controller.allNotifications.where((n) => !n.isRead).toList()),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(AppSpacings.m),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: controller.markAllAsRead,
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


