import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/models/notification.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/services/notification_service.dart';

class NotificationNotifier extends StateNotifier<List<Notification>> {
  final NotificationService _service;

  NotificationNotifier(this._service) : super([]);

  Future<void> fetchNotifications(String userId) async {
    state = await _service.getNotifications(userId);
  }

  Future<void> markAllAsRead(String userId) async {
    await _service.markAllAsRead(userId);
    await fetchNotifications(userId);
  }

  Future<void> createPlaceAddedNotification({
    required String userId,
    required String placeName,
  }) async {
    await _service.createPlaceAddedNotification(
      userId: userId,
      placeName: placeName,
    );
    await fetchNotifications(userId);
  }

  Future<void> createVisitReminderNotification({
    required String userId,
    required String placeName,
    required int days,
  }) async {
    await _service.createVisitReminderNotification(
      userId: userId,
      placeName: placeName,
      days: days,
    );
    await fetchNotifications(userId);
  }

  Stream<int> unreadCount(String userId) {
    return _service.getUnreadNotificationsCount(userId);
  }

  Future<void> checkVisitReminders(String userId, List<Place> places) async {
    await _service.checkVisitReminders(userId: userId, places: places);
    await fetchNotifications(userId);
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<Notification>>(
      (ref) => NotificationNotifier(NotificationService()),
    );
