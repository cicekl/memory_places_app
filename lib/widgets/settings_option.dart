import 'package:flutter/material.dart';

class SettingsOption extends StatelessWidget{

const SettingsOption ({super.key, 
required this.option, 
required this.description, 
required this.icon, 
required this.color});

final String option;
final String description;
final IconData icon;
final Color color;

@override
  Widget build(BuildContext context) {
    return Container(
              width: 365,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xffE6E7DA),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(icon,
                      color: color,),
                    ),
                    const SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(option,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      ),),
                        Text(description,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF728B25),
                      ),),
                      ],
                    ),
                    const Spacer(),
                     IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.keyboard_arrow_right_rounded,
                      color: Color(0xFF728B25),),)
                  ],
                ),
              ),
            );
  }

}