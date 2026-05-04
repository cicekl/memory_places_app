import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {

const FeatureCard ({super.key, required this.title, required this.description, required this.icon, required this.color});

final String title;
final String description;
final IconData icon;
final Color color;



@override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 12, right: 15, bottom: 12),
      width: 370,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: color,
            ),
            child: Icon(
              icon,
              color: Color(0xFFEBE0CD),
            ),
          ),
          const SizedBox(width: 10,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
              const SizedBox(height:2,),
              Text(description,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 12,
                color: Color(0xFF728B25),
                fontWeight: FontWeight.w400,
              ),),
            ],
          ),
        ),
        ],
      ),
    );
  }

}