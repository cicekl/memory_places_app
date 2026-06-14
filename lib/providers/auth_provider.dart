import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/services/auth_service.dart';

class AuthNotifier extends StateNotifier<User?> {
  final AuthService _service;

  AuthNotifier(this._service) : super(null) {
    state = _service.currentUser;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credentials = await _service.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    state = credentials.user;
  }

  Future<void> signIn({required String email, required String password}) async {
    final credentials = await _service.signIn(email: email, password: password);
    state = credentials.user;
  }

  Future<void> logout() async {
    await _service.logout();
    state = null;
  }

  Future<void> updateProfile({
    required String? fullName,
    required String? email,
    required String? currentPassword,
    required String? newPassword,
  }) async {
    await _service.updateProfile(
      fullName: fullName,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    state = _service.currentUser;
  }

  Future<void> resetPassword(String email) async {
    await _service.resetPassword(email);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>(
  (ref) => AuthNotifier(AuthService()),
);
