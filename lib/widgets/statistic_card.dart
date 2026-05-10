import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatisticCard extends StatelessWidget{

  const StatisticCard ({super.key, 
  required this.statisticNumber, 
  required this.title,
  required this.icon});

final String statisticNumber;
final String title;
final IconData icon;

@override
  Widget build(BuildContext context) {
    return Container(
              width: 170,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xfff7eed9),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(icon,
                        color: Color(0xFFF19E39),
                        size: 25,),
                      ),
                    const SizedBox(height: 5,),  
                    Text(statisticNumber,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontFamily: 'RobotoSlab'),
                    ),
                    const SizedBox(height: 5,),  
                    Text(title,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF728B25),),
                    ),
                  ],
                ),
              ),
            );
  }

}