import 'package:flutter/material.dart';
import 'package:memory_places_app/models/notification.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });

  final String title;
  final String description;
  final String time;
  final NotificationType type;

  IconData get icon {
    switch (type) {
      case NotificationType.placeAdded:
        return Icons.add_location_alt_outlined;

      case NotificationType.visitReminder:
        return Icons.notifications_active_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E7DA),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: const Color(0xFF728B25)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 2),

                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: const Color(0xFF728B25),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  time,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
