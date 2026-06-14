import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/services/notification_settings_service.dart';

class NotificationSettingsNotifier extends StateNotifier<Map<String, bool>> {
  final NotificationSettingsService _service;

  NotificationSettingsNotifier(this._service)
    : super({'newPlacesAdded': true, 'visitReminders': true});

  Future<void> fetchSettings(String userId) async {
    state = await _service.getSettings(userId);
  }

  Future<void> updateNewPlacesAdded(String userId, bool value) async {
    await _service.updateNewPlacesAdded(userId: userId, value: value);
    state = {...state, 'newPlacesAdded': value};
  }

  Future<void> updateVisitReminders(String userId, bool value) async {
    await _service.updateVisitReminders(userId: userId, value: value);
    state = {...state, 'visitReminders': value};
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, Map<String, bool>>(
      (ref) => NotificationSettingsNotifier(NotificationSettingsService()),
    );
