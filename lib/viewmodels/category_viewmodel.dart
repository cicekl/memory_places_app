import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/models/category.dart';
import 'package:memory_places_app/providers/category_provider.dart';
import 'package:memory_places_app/providers/place_provider.dart';

class CategoryViewModel extends ChangeNotifier {
  final Ref ref;

  bool _loading = false;
  String? _error;
  List<Category> _categories = [];

  bool get loading => _loading;
  String? get error => _error;
  List<Category> get categories => _categories;

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

  CategoryViewModel(this.ref) {
    ref.listen(categoryProvider, (previous, next) {
      _categories = next;
      _safeNotify();
    });
  }

  Future<void> fetchCategories(String userId) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      await ref.read(categoryProvider.notifier).fetchAllCategories(userId);
      _categories = ref.read(categoryProvider);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> addCategory(String userId, Category category) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      await ref.read(categoryProvider.notifier).addCategory(userId, category);
      _categories = ref.read(categoryProvider);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> deleteCategory(String userId, String categoryId) async {
    _loading = true;
    _error = null;
    _safeNotify();
    try {
      await ref
          .read(placeProvider.notifier)
          .deletePlacesByCategory(userId, categoryId);
      await ref
          .read(categoryProvider.notifier)
          .deleteCategory(userId, categoryId);
      _categories = ref.read(categoryProvider);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  void clearError() {
    _error = null;
    _safeNotify();
  }
}

final categoryViewModelProvider = ChangeNotifierProvider<CategoryViewModel>(
  (ref) => CategoryViewModel(ref),
);
