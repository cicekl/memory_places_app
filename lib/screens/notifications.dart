import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget{

const NotificationsScreen ({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  bool _newPlacesAdded = true;

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
              Text('Notifications',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,),
                ),
              Text('Manage your alerts',
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
      child: Column(
        children: [
          Container(
            width: 365,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: 
                  SwitchListTile(
                    title: Text('New Places Added',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        ),
                    ),
                    subtitle: Text('Get notified when you add a new place',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xFF728B25),
                        ),
                        ),
                   value: _newPlacesAdded,
                  onChanged: (value) {
                    setState(() {
                      _newPlacesAdded = value;
                    });
                  },
                  activeTrackColor: Color(0xFF728B25),
                  inactiveTrackColor: Color(0xffAEB3A1),
                  inactiveThumbColor: Color(0xffE6E7DA),
                ),
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            width: 365,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: 
                  SwitchListTile(
                    title: Text('Reminder',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        ),
                    ),
                    subtitle: Text('Remind you to revisit your favorite places',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xFF728B25),
                        ),
                        ),
                   value: _newPlacesAdded,
                  onChanged: (value) {
                    setState(() {
                      _newPlacesAdded = value;
                    });
                  },
                  activeTrackColor: Color(0xFF728B25),
                  inactiveTrackColor: Color(0xffAEB3A1),
                  inactiveThumbColor: Color(0xffE6E7DA),
                ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}