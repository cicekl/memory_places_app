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
          title: data['title'], 
          color: Color(data['color']), 
          isDefault: data['isDefault'],
          );
   }).toList();

  }



}