import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../providers/app_provider.dart';

import '../models/models.dart';

import '../utils/profix_colors.dart';



class NotificationsScreen extends StatelessWidget {

  final VoidCallback onBack;

  const NotificationsScreen({super.key, required this.onBack});



  @override

  Widget build(BuildContext context) {

    final app = context.watch<AppProvider>();

    final role = app.user?.role == UserRole.technician ? NotificationRole.technician : NotificationRole.customer;

    final notifs = app.notifications.where((n) => n.role == role).toList();



    return Scaffold(

      appBar: AppBar(

        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),

        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600)),

        actions: [

          TextButton(

            onPressed: () => app.markAllNotificationsRead(),

            child: const Text('Mark all read', style: TextStyle(color: ProfixColors.primary)),

          ),

        ],

      ),

      body: notifs.isEmpty

          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Icon(Icons.notifications_none, size: 56, color: Colors.grey),

        SizedBox(height: 12),

        Text('No notifications', style: TextStyle(color: Colors.grey)),

      ]))

          : ListView.separated(

        itemCount: notifs.length,

        separatorBuilder: (_, __) => const Divider(height: 1),

        itemBuilder: (_, i) {

          final n = notifs[i];

          return InkWell(

            onTap: () => app.markNotificationRead(n.id),

            child: Container(

              color: n.isRead ? null : ProfixColors.primary.withOpacity(0.04),

              padding: const EdgeInsets.all(16),

              child: Row(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Container(

                    width: 42, height: 42,

                    decoration: BoxDecoration(

                      color: _iconColor(n).withOpacity(0.1),

                      shape: BoxShape.circle,

                    ),

                    child: Icon(_iconData(n), color: _iconColor(n), size: 20),

                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold, fontSize: 14)),

                        const SizedBox(height: 2),

                        Text(n.body, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),

                        const SizedBox(height: 4),

                        Text(DateFormat('MMM d, h:mm a').format(n.createdAt), style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),

                      ],

                    ),

                  ),

                  if (!n.isRead)

                    Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: ProfixColors.primary, shape: BoxShape.circle)),

                ],

              ),

            ),

          );

        },

      ),

    );

  }



  IconData _iconData(AppNotification n) {

    switch (n.role) {

      case NotificationRole.customer:

        if (n.title.contains('Accepted')) return Icons.check_circle;

        if (n.title.contains('Way')) return Icons.directions_car;

        if (n.title.contains('Completed')) return Icons.done_all;

        if (n.title.contains('Rate')) return Icons.star;

        return Icons.notifications;

      case NotificationRole.technician:

        if (n.title.contains('Request')) return Icons.assignment;

        if (n.title.contains('Message')) return Icons.chat;

        if (n.title.contains('Rating')) return Icons.star;

        return Icons.notifications;

    }

  }



  Color _iconColor(AppNotification n) {

    if (n.title.contains('Accepted') || n.title.contains('Completed') || n.title.contains('Rating')) return ProfixColors.green;

    if (n.title.contains('Way') || n.title.contains('Request')) return ProfixColors.primary;

    if (n.title.contains('Rate')) return ProfixColors.amber;

    return Colors.grey;

  }

}