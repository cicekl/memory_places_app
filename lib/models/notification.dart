enum NotificationType { placeAdded, visitReminder }

class Notification {
  const Notification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
}
