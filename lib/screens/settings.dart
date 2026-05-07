import 'package:flutter/material.dart';
import 'package:memory_places_app/screens/login.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/widgets/settings_option.dart';

class SettingsScreen extends StatelessWidget{

 SettingsScreen ({super.key});

final _authService = AuthService();


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 130,
      leadingWidth: 45,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 32,
              fontFamily: 'RobotoSlab',
              fontWeight: FontWeight.w500,),
              ),
            Text('Manage your account and preferences',
            maxLines: 2,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontFamily: 'RobotoSlab',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF728B25),),),
          ], 
        )
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 365,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF728B25),
                      radius: 40,
                      child: Text('IP',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30,
                        color: Color(0xFFF5F1E8),
                      ),),
                    ),
                    const SizedBox(width: 18,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ime Prezime',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      ),),
                        Text('ime.prezime@gmail.com',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF728B25),
                      ),),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40,),
          SettingsOption(option: 'Edit profile', 
          description: 'Edit your information', 
          icon: Icons.person_outline, 
          color: Color(0xFF728B25),),
          const SizedBox(height: 10,),
          SettingsOption(option: 'Categories', 
          description: 'Manage place types', 
          icon: Icons.star_outline_outlined, 
          color: Color(0xFFF19E39),),
          const SizedBox(height: 10,),
          SettingsOption(option: 'Notifications', 
          description: 'Manage notifications', 
          icon: Icons.notifications_outlined, 
          color: Color(0xFF728B25),),
          const SizedBox(height: 10,),
          SettingsOption(option: 'Help', 
          description: 'Learn how to use the app', 
          icon: Icons.help_outline, 
          color: Color(0xFFF19E39),),
          const SizedBox(height: 50,),
          SizedBox(
          width: 368,
          height: 57,
          child: ElevatedButton(
            onPressed: (){
              _authService.logout();
              if (!context.mounted) return;

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xff4A3728),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(
                color: Color(0xFF728B25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_sharp,
                color: Color(0xff4A3728),
                size: 25,),
                const SizedBox(width: 10,),
                Text('Log out',
                style: TextStyle(
                  fontSize: 16,
                ),
                ),
              ],
            ),
            ),
        ),
        const Spacer(),
         Padding(
           padding: const EdgeInsets.only(bottom: 10),
           child: Text("Memory Places v1.0.0",
           textAlign: TextAlign.center,
           style: TextStyle(
            color: Color(0xFF8A9B61),
           ),),
         ),   
            ],
          ),
        );
  }

}