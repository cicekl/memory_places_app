import 'package:flutter/material.dart';

class SelectableCategory extends StatelessWidget{

const SelectableCategory ({super.key,
required this.categoryName});

final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFF728B25),
        )
      ),
      child: Text(categoryName,
       style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 16,
                color: Color(0xFF4A3728),
                fontWeight: FontWeight.w400,
                fontFamily: 'RobotoSlab',
               ),),
    );
  }
}