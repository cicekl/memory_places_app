import 'package:flutter_riverpod/legacy.dart';
import 'package:memory_places_app/models/category.dart';
import 'package:memory_places_app/services/category_service.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  final CategoryService _service;

  CategoryNotifier(this._service) : super([]);

  Future<void> fetchAllCategories(String userId) async {
    final defaultCategories = await _service.getDefaultCategories();
    final userCategories = await _service.getUserCategories(userId);
    state = [...defaultCategories, ...userCategories];
  }

  Future<void> addCategory(String userId, Category category) async {
    await _service.addUserCategory(userId: userId, category: category);
    await fetchAllCategories(userId);
  }

  Future<void> deleteCategory(String userId, String categoryId) async {
    await _service.deleteUserCategory(userId: userId, categoryId: categoryId);
    await fetchAllCategories(userId);
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
      (ref) => CategoryNotifier(CategoryService()),
    );
