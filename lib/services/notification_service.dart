import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:memory_places_app/models/notification.dart';
import 'package:memory_places_app/services/notification_settings_service.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  final _firestore = FirebaseFirestore.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _settingsService = NotificationSettingsService();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('notification_icon');

    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings: settings);
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'memory_places_channel',
      'Memory Places Notifications',
      icon: 'notification_icon',
      channelDescription: 'Notifications for Memory Places app',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  Future<void> addNotification({
    required String userId,
    required Notification notification,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notification.id)
        .set({
          'id': notification.id,
          'title': notification.title,
          'description': notification.description,
          'type': notification.type.name,
          'createdAt': Timestamp.fromDate(notification.createdAt),
          'isRead': notification.isRead,
        });
  }

  Future<List<Notification>> getNotifications(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Notification(
        id: doc.id,
        title: data['title'],
        description: data['description'],
        type: NotificationType.values.firstWhere(
          (type) => type.name == data['type'],
          orElse: () => NotificationType.placeAdded,
        ),
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        isRead: data['isRead'] ?? false,
      );
    }).toList();
  }

  Future<void> createPlaceAddedNotification({
    required String userId,
    required String placeName,
  }) async {
    final settings = await _settingsService.getSettings(userId);

    if (!settings['newPlacesAdded']!) {
      return;
    }

    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New place added',
      description: '$placeName has been saved to your memories.',
      type: NotificationType.placeAdded,
      createdAt: DateTime.now(),
    );

    await addNotification(userId: userId, notification: notification);

    await showLocalNotification(
      title: notification.title,
      body: notification.description,
    );
  }

  Future<void> createVisitReminderNotification({
    required String userId,
    required String placeName,
    required int days,
  }) async {
    final settings = await _settingsService.getSettings(userId);

    if (!settings['visitReminders']!) {
      return;
    }

    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Visit reminder',
      description: 'You have not visited $placeName in $days days.',
      type: NotificationType.visitReminder,
      createdAt: DateTime.now(),
    );

    await addNotification(userId: userId, notification: notification);

    await showLocalNotification(
      title: notification.title,
      body: notification.description,
    );
  }

  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  Stream<int> getUnreadNotificationsCount(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> checkVisitReminders({
    required String userId,
    required List places,
  }) async {
    for (final place in places) {
      final daysSinceLastVisit = DateTime.now()
          .difference(place.lastVisit)
          .inDays;

      if (daysSinceLastVisit >= 30 && !place.reminderSent) {
        final alreadyExists = await _firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .where('type', isEqualTo: NotificationType.visitReminder.name)
            .where(
              'description',
              isEqualTo:
                  'You have not visited ${place.title} in $daysSinceLastVisit days.',
            )
            .get();

        if (alreadyExists.docs.isEmpty) {
          await createVisitReminderNotification(
            userId: userId,
            placeName: place.title,
            days: daysSinceLastVisit,
          );
        }
      }
    }
  }
}
