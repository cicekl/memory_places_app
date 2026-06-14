import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget{

const CategoryTile ({super.key,
required this.categoryName,
required this.description,
required this.color});

final String categoryName;
final String description;
final Color color;

@override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 15,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color,
              ),
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(categoryName,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 3,),
                Text(description,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF728B25),
                ),),
              ],
            )
          ],
        ),
      ),
    );
  }

}