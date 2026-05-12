import 'package:memory_places_app/models/category.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class PlaceLocation {

  const PlaceLocation({
  required this.latitude, 
  required this.longitude, 
  required this.city,
  required this.country,
  required this.postalCode,
  required this.street,
  });

final double latitude;
final double longitude;
final String street;
final String city;
final String postalCode;
final String country;

 String get fullAddress {
    return [
      street,
      postalCode,
      city,
      country,
    ].where((part) => part.trim().isNotEmpty).join(', ');
  }

}

class Place {

 Place ({
  String? id,
  required this.title,
  required this.description, 
  this.imageUrl,
  required this.location,
  this.totalVisits = 0,
  required this.lastVisit,
  required this.userId,
  required this.category,
}) : id = id ?? _uuid.v4();

final String id;
final String userId;
final String title;
final String description;
final String? imageUrl;
final PlaceLocation location;
final int totalVisits;
final DateTime lastVisit;
final Category category;

}