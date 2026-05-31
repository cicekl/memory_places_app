import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_places_app/models/category.dart';
import 'package:memory_places_app/models/place.dart';

class PlaceService {
  PlaceService._internal();

  static final PlaceService _instance = PlaceService._internal();

  factory PlaceService() {
    return _instance;
  }

  final _firestore = FirebaseFirestore.instance;

  Future<void> addPlace(Place place) async {
    await _firestore
        .collection('users')
        .doc(place.userId)
        .collection('places')
        .doc(place.id)
        .set({
          'id': place.id,
          'userId': place.userId,
          'title': place.title,
          'description': place.description,
          'imageUrl': place.imageUrl,
          'location': {
            'latitude': place.location.latitude,
            'longitude': place.location.longitude,
            'street': place.location.street,
            'city': place.location.city,
            'postalCode': place.location.postalCode,
            'country': place.location.country,
          },
          'category': {
            'id': place.category.id,
            'title': place.category.title,
            'color': place.category.color.toARGB32(),
            'isDefault': place.category.isDefault,
          },
          'totalVisits': place.totalVisits,
          'lastVisit': Timestamp.fromDate(place.lastVisit),
          'createdAt': Timestamp.now(),
          'reminderSent': place.reminderSent,
        });
  }

  Future<List<Place>> getPlaces(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('places')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final location = data['location'];
      final category = data['category'];

      return Place(
        id: data['id'],
        userId: data['userId'],
        title: data['title'],
        description: data['description'],
        imageUrl: data['imageUrl'],
        location: PlaceLocation(
          latitude: location['latitude'],
          longitude: location['longitude'],
          street: location['street'],
          city: location['city'],
          postalCode: location['postalCode'],
          country: location['country'],
        ),
        category: Category(
          id: category['id'],
          title: category['title'],
          color: Color(category['color']),
          isDefault: category['isDefault'],
        ),
        totalVisits: data['totalVisits'],
        lastVisit: (data['lastVisit'] as Timestamp).toDate(),
        reminderSent: data['reminderSent'] ?? false,
      );
    }).toList();
  }

  Future<void> markPlaceVisited({
    required String userId,
    required String placeId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('places')
        .doc(placeId)
        .update({
          'totalVisits': FieldValue.increment(1),
          'lastVisit': Timestamp.now(),
          'reminderSent': false,
        });
  }

  Future<void> deletePlace({
    required String userId,
    required String placeId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('places')
        .doc(placeId)
        .delete();
  }

  Future<void> updatePlace({
    required String userId,
    required Place place,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('places')
        .doc(place.id)
        .update({
          'title': place.title,
          'description': place.description,
          'imageUrl': place.imageUrl,
          'location': {
            'latitude': place.location.latitude,
            'longitude': place.location.longitude,
            'street': place.location.street,
            'city': place.location.city,
            'postalCode': place.location.postalCode,
            'country': place.location.country,
          },
          'lastVisit': Timestamp.fromDate(place.lastVisit),
          'reminderSent': place.reminderSent,
        });
  }

  Future<void> deletePlacesByCategory({
    required String userId,
    required String categoryId,
  }) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('places')
        .where('category.id', isEqualTo: categoryId)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
