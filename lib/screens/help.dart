import 'package:flutter/material.dart';
import 'package:memory_places_app/widgets/help_card.dart';

class HelpScreen extends StatelessWidget{

const HelpScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
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
          ),
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
              Text('How To Use',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Color(0xFF728B25),
                fontSize: 16,
              ),
              ),
            const SizedBox(height: 10,),
            HelpCard(option: 'Add Places', description: 'Tap the + button to add a new favorite place. You can add photos, location, category and personal notes about why it’s special to you.', icon: Icons.add),
             const SizedBox(height: 10,),
             HelpCard(option: 'Take Photos', description: 'Capture moments at your favorite spots using the camera feature. Photos are optional but help you remember the place better.', icon: Icons.camera_alt_outlined),
            const SizedBox(height: 10,),
             HelpCard(option: 'View Statistics', description: 'Track your collection with insights on total places, photos, visits, and activity. See which categories you visit most and your recent activity.', icon: Icons.trending_up_rounded),
            const SizedBox(height: 10,),
             HelpCard(option: 'Organize by Categories', description: 'Filter your places by categories like Coffee Shops, Parks, Restaurants and more. Create custom categories in Settings.', icon: Icons.favorite_border_outlined),
            const SizedBox(height: 20,),
             Text('Quick Tips',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Color(0xFF728B25),
                fontSize: 16,
              ),
              ),
            const SizedBox(height: 10,), 
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                    child: Text(
                '• Use the search bar to quickly find saved places\n\n'
                '• Tap on any place card to view full details and notes\n\n'
                '• Create custom categories in More → Categories\n\n'
                '• Filter places by category using the buttons below the search',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Color(0xFF728B25),
                    fontSize: 13,
                    ),),
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }

}