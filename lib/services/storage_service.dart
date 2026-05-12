import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

final _storage = FirebaseStorage.instance;

Future<String> uploadPlaceImage({
  required File image,
  required String userId, 
  required String placeId,}
) async {
  final storageRef = _storage.ref().child('place_images/$userId/$placeId.jpg');

  await storageRef.putFile(image);

  return storageRef.getDownloadURL();
}

}