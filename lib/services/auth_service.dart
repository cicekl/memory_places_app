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

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredentials.user!.updateDisplayName(fullName);
      await _firestore.collection('users').doc(userCredentials.user!.uid).set({
        'userId': userCredentials.user!.uid,
        'fullName': fullName,
        'email': email,
        'createdAt': Timestamp.now(),
      });
      return userCredentials;
    } on FirebaseAuthException {
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
        password: password,
      );

      return userCredentials;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> logout() {
    return _firebase.signOut();
  }

  Future<void> updateProfile({
    required String? fullName,
    required String? email,
    required String? currentPassword,
    required String? newPassword,
  }) async {
    final user = _firebase.currentUser;

    if (user == null) return;

    final currentEmail = user.email;

    final emailChanged =
        email != null &&
        email.trim().isNotEmpty &&
        email.trim() != currentEmail;

    final passwordChanged =
        newPassword != null && newPassword.trim().isNotEmpty;

    if (emailChanged || passwordChanged) {
      if (currentEmail == null ||
          currentPassword == null ||
          currentPassword.trim().isEmpty) {
        throw FirebaseAuthException(
          code: 'requires-recent-login',
          message: 'Current password is required.',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: currentEmail,
        password: currentPassword.trim(),
      );

      await user.reauthenticateWithCredential(credential);
    }

    if (fullName != null && fullName.trim().isNotEmpty) {
      await user.updateDisplayName(fullName.trim());

      await _firestore.collection('users').doc(user.uid).update({
        'fullName': fullName.trim(),
      });
    }

    if (emailChanged) {
      await user.verifyBeforeUpdateEmail(email.trim());
      await user.reload();
      await _firestore.collection('users').doc(user.uid).update({
        'email': email.trim(),
      });
    }

    if (passwordChanged) {
      await user.updatePassword(newPassword.trim());
    }

    await user.reload();
  }
}
