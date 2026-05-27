import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:memory_places_app/models/category.dart';

class CategoryService {
  CategoryService._internal();

  static final CategoryService _instance = CategoryService._internal();

  factory CategoryService() {
    return _instance;
  }

  final _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getDefaultCategories() async {
    final snapshot = await _firestore
        .collection('defaultCategories')
        .orderBy('title')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Category(
        id: doc.id,
        title: data['title'],
        color: Color(data['color']),
        isDefault: data['isDefault'],
      );
    }).toList();
  }

  Future<void> addUserCategory({
    required String userId,
    required Category category,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(category.id)
        .set({
          'id': category.id,
          'title': category.title,
          'color': category.color.toARGB32(),
          'isDefault': category.isDefault,
          'createdAt': Timestamp.now(),
        });
  }

  Future<List<Category>> getUserCategories(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .orderBy('title')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Category(
        id: doc.id,
        title: data['title'],
        color: Color(data['color']),
        isDefault: data['isDefault'],
      );
    }).toList();
  }

  Future<void> deleteUserCategory({
    required String userId,
    required String categoryId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }
}
