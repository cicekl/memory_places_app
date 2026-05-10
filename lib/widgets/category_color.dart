import 'package:flutter/material.dart';

class CategoryColor extends StatelessWidget{

const CategoryColor ({super.key,
required this.text,
required this.color});

final Color color;
final String text;

@override
  Widget build(BuildContext context) {
    return Container(
                alignment: Alignment.center,
                width: 75,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: color,
                ),
               child: Text(text,
               style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 16,
                color: Color(0xffF5F1E8),
                fontWeight: FontWeight.w400,
                fontFamily: 'RobotoSlab',
               ),), 
              );
  }  
}