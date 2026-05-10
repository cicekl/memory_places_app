import 'package:flutter/material.dart';

class HelpCard extends StatelessWidget{

  const HelpCard ({super.key, required this.option, required this.description, required this.icon});


final String option;
final String description;
final IconData icon;


@override
  Widget build(BuildContext context) {
    return Container(
              width: 365,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffE6E7DA),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(icon,
                      color: Color(0xFF728B25),),
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(option,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        ),),
                        const SizedBox(height: 5,),
                          Text(description,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xFF728B25),
                        ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
  }


}