import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/services/place_service.dart';

class PlaceNotifier extends StateNotifier<List<Place>> {
  final PlaceService _service;

  PlaceNotifier(this._service) : super([]);

  Future<void> fetchPlaces(String userId) async {
    state = await _service.getPlaces(userId);
  }

  Future<void> addPlace(Place place) async {
    await _service.addPlace(place);
    await fetchPlaces(place.userId);
  }

  Future<void> deletePlace(String userId, String placeId) async {
    await _service.deletePlace(userId: userId, placeId: placeId);
    await fetchPlaces(userId);
  }

  Future<void> updatePlace(String userId, Place place) async {
    await _service.updatePlace(userId: userId, place: place);
    await fetchPlaces(userId);
  }

  Future<void> markPlaceVisited(String userId, String placeId) async {
    await _service.markPlaceVisited(userId: userId, placeId: placeId);
    await fetchPlaces(userId);
  }

  Future<void> deletePlacesByCategory(String userId, String categoryId) async {
    await _service.deletePlacesByCategory(
      userId: userId,
      categoryId: categoryId,
    );
    await fetchPlaces(userId);
  }
}

final placeProvider = StateNotifierProvider<PlaceNotifier, List<Place>>(
  (ref) => PlaceNotifier(PlaceService()),
);
