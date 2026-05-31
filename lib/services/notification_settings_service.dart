import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationSettingsService {
  NotificationSettingsService._internal();

  static final NotificationSettingsService _instance =
      NotificationSettingsService._internal();

  factory NotificationSettingsService() {
    return _instance;
  }

  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, bool>> getSettings(String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('notifications')
        .get();

    if (!doc.exists) {
      return {'newPlacesAdded': true, 'visitReminders': true};
    }

    final data = doc.data()!;

    return {
      'newPlacesAdded': data['newPlacesAdded'] ?? true,
      'visitReminders': data['visitReminders'] ?? true,
    };
  }

  Future<void> updateNewPlacesAdded({
    required String userId,
    required bool value,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('notifications')
        .set({'newPlacesAdded': value}, SetOptions(merge: true));
  }

  Future<void> updateVisitReminders({
    required String userId,
    required bool value,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('notifications')
        .set({'visitReminders': value}, SetOptions(merge: true));
  }
}
