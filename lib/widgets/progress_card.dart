import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget{

const ProgressCard ({super.key,
required this.categoryName,
required this.number,
required this.color});

final String categoryName;
final String number;
final Color color;

@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(categoryName,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                        ),),
            const Spacer(),
            Text(number,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF728B25),
                        ),)
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.6,
          minHeight: 8,
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
      ],
    );
  }

}