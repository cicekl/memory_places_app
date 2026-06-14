import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/models/notification.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/providers/notification_provider.dart';
import 'package:memory_places_app/providers/notification_settings_provider.dart';

class NotificationViewModel extends ChangeNotifier {
  final Ref ref;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  Map<String, bool> _settings = {
    'newPlacesAdded': true,
    'visitReminders': true,
  };
  Map<String, bool> get settings => _settings;
  List<Notification> _notifications = [];
  List<Notification> get notifications => _notifications;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  NotificationViewModel(this.ref) {
    ref.listen(notificationSettingsProvider, (previous, next) {
      _settings = next;
      _safeNotify();
    });

    ref.listen(notificationProvider, (previous, next) {
      _notifications = next;
      _safeNotify();
    });
  }

  Future<void> fetchNotifications(String userId) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      await ref.read(notificationProvider.notifier).fetchNotifications(userId);
      await ref
          .read(notificationSettingsProvider.notifier)
          .fetchSettings(userId);
      _notifications = ref.read(notificationProvider);
      _settings = ref.read(notificationSettingsProvider);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      await ref.read(notificationProvider.notifier).markAllAsRead(userId);
      _notifications = ref.read(notificationProvider);
      _safeNotify();
    } catch (e) {
      _error = e.toString();
      _safeNotify();
    }
  }

  Future<void> updateNewPlacesAdded(String userId, bool value) async {
    try {
      await ref
          .read(notificationSettingsProvider.notifier)
          .updateNewPlacesAdded(userId, value);
      _settings = ref.read(notificationSettingsProvider);
      _safeNotify();
    } catch (e) {
      _error = e.toString();
      _safeNotify();
      ();
    }
  }

  Future<void> updateVisitReminders(String userId, bool value) async {
    try {
      await ref
          .read(notificationSettingsProvider.notifier)
          .updateVisitReminders(userId, value);
      _settings = ref.read(notificationSettingsProvider);
      _safeNotify();
    } catch (e) {
      _error = e.toString();
      _safeNotify();
    }
  }

  void clearError() {
    _error = null;
    _safeNotify();
  }

  Stream<int> unreadCount(String userId) {
    return ref.read(notificationProvider.notifier).unreadCount(userId);
  }

  Future<void> checkVisitReminders(String userId, List<Place> places) async {
    try {
      await ref
          .read(notificationProvider.notifier)
          .checkVisitReminders(userId, places);
    } catch (e) {
      _error = e.toString();
      _safeNotify();
    }
  }
}

final notificationViewModelProvider =
    ChangeNotifierProvider<NotificationViewModel>(
      (ref) => NotificationViewModel(ref),
    );
