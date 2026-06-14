import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/models/place.dart';
import 'package:memory_places_app/providers/notification_provider.dart';
import 'package:memory_places_app/providers/place_provider.dart';
import 'package:memory_places_app/services/storage_service.dart';

class PlaceViewModel extends ChangeNotifier {
  final Ref ref;
  final StorageService _storageService = StorageService();

  bool _loading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategoryId;

  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;

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

  List<Place> get allPlaces => ref.watch(placeProvider);
  PlaceViewModel(this.ref);

  List<Place> get filteredPlaces {
    final places = ref.watch(placeProvider);
    return places.where((place) {
      final matchesSearch = place.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategoryId == null ||
          place.category.id == _selectedCategoryId;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> fetchPlaces(String userId) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      await ref.read(placeProvider.notifier).fetchPlaces(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> addPlace(Place place, {File? image}) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await _storageService.uploadPlaceImage(
          image: image,
          userId: place.userId,
          placeId: place.id,
        );
      }
      final placeWithImage = Place(
        id: place.id,
        userId: place.userId,
        title: place.title,
        description: place.description,
        imageUrl: imageUrl,
        location: place.location,
        totalVisits: place.totalVisits,
        lastVisit: place.lastVisit,
        category: place.category,
      );
      await ref.read(placeProvider.notifier).addPlace(placeWithImage);
      await ref
          .read(notificationProvider.notifier)
          .createPlaceAddedNotification(
            userId: place.userId,
            placeName: place.title,
          );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> deletePlace(String userId, String placeId) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      await ref.read(placeProvider.notifier).deletePlace(userId, placeId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> updatePlace(String userId, Place place, {File? image}) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      String? imageUrl = place.imageUrl;
      if (image != null) {
        imageUrl = await _storageService.uploadPlaceImage(
          image: image,
          userId: userId,
          placeId: place.id,
        );
      }
      final updatedPlace = Place(
        id: place.id,
        userId: place.userId,
        title: place.title,
        description: place.description,
        imageUrl: imageUrl,
        location: place.location,
        totalVisits: place.totalVisits,
        lastVisit: place.lastVisit,
        category: place.category,
      );
      await ref.read(placeProvider.notifier).updatePlace(userId, updatedPlace);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> markPlaceVisited(String userId, String placeId) async {
    try {
      await ref.read(placeProvider.notifier).markPlaceVisited(userId, placeId);
    } catch (e) {
      _error = e.toString();
      _safeNotify();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _safeNotify();
  }

  void setSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    _safeNotify();
  }

  void clearError() {
    _error = null;
    _safeNotify();
  }
}

final placeViewModelProvider = ChangeNotifierProvider<PlaceViewModel>((ref) {
  return PlaceViewModel(ref);
});
