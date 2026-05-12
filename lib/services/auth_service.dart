import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  AuthService._internal();
  
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  final _firebase = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

User? get currentUser {
  return _firebase.currentUser;
}  

Future<UserCredential> signUp ({
  required String email, 
  required String password, 
  required String fullName}) async {

    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
      email: email, 
      password: password,
      );
    await userCredentials.user!.updateDisplayName(fullName);
    await _firestore.collection('users').doc(userCredentials.user!.uid).
    set({
      'userId': userCredentials.user!.uid,
      'fullName': fullName,
      'email': email,
      'createdAt':Timestamp.now(),
    });
    return userCredentials;
    } on FirebaseAuthException{
      rethrow;
    }

  }

Future<UserCredential> signIn({
  required String email,
  required String password,
}) async {

  try {
    final userCredentials = await _firebase.signInWithEmailAndPassword(
      email: email, 
      password: password);

  return userCredentials; 
  
  } on FirebaseAuthException {
    rethrow;
  }

}

Future<void> logout () {
  return _firebase.signOut();
}


}