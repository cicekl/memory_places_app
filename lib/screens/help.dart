import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget{

const HelpScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
      toolbarHeight: 130,
      leadingWidth: 45,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Help',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 32,
              fontFamily: 'RobotoSlab',
              fontWeight: FontWeight.w500,),
              ),
            Text('Learn how to use Memory Places',
            maxLines: 2,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF728B25),),),
          ], 
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About Memory Places',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Color(0xFF728B25),
                fontSize: 16,
              ),
              ),
              const SizedBox(height: 10,),
              Container(
              width: 365,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text('Memory Places is an application which helps you capture and cherish places which bring you joy.  Whether it’s your favorite coffee shop, restaurant or a peaceful park bench, save these special locations with photos and notes to revisit them anytime. ',
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 15,
                    fontFamily: 'RobotoSlab',
                  ),),
                ),
              ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

}