import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/providers/auth_provider.dart';

class AuthViewModel extends ChangeNotifier {
  final Ref ref;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  AuthViewModel(this.ref);

  bool get isLoggedIn => ref.read(authProvider) != null;
  String? get userId => ref.read(authProvider)?.uid;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await ref
          .read(authProvider.notifier)
          .signUp(email: email, password: password, fullName: fullName);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await ref
          .read(authProvider.notifier)
          .signIn(email: email, password: password);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await ref.read(authProvider.notifier).logout();
  }

  Future<void> updateProfile({
    required String? fullName,
    required String? email,
    required String? currentPassword,
    required String? newPassword,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await ref
          .read(authProvider.notifier)
          .updateProfile(
            fullName: fullName,
            email: email,
            currentPassword: currentPassword,
            newPassword: newPassword,
          );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await ref.read(authProvider.notifier).resetPassword(email);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>(
  (ref) => AuthViewModel(ref),
);
