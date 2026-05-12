import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Category {

   Category ({
    String? id,
    required this.title,
    required this.color,
    required this.isDefault,
  }): id = id ?? _uuid.v4();

final String id;
final String title;
final Color color;
final bool isDefault;

}