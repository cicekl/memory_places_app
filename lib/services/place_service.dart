import 'package:cloud_firestore/cloud_firestore.dart';
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
    });
  }
}