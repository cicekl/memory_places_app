
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {

  const PlaceLocation({
  required this.latitude, 
  required this.longitude, 
  required this.address,
  required this.category});

final double latitude;
final double longitude;
final String address;
final Category category;

}

class Place {

 Place ({
  required this.title,
  required this.description, 
  required this.image,
  required this.location,
  required this.totalVisits,
  required this.lastVisit,
}) : id = uuid.v4();

final String id;
final String title;
final String description;
final File image;
final PlaceLocation location;
final int totalVisits;
final DateTime? lastVisit;

}