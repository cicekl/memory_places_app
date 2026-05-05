import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {

   Category ({
    required this.title,
    required this.color,
  }): id = uuid.v4();

final String id;
final String title;
final Color color;

}