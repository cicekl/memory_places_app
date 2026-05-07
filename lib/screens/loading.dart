import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:memory_places_app/screens/landing_page.dart';
import 'package:memory_places_app/screens/tabs.dart';

class LoadingScreen extends StatefulWidget {

const LoadingScreen ({super.key});

@override
  State<LoadingScreen> createState() {
   return _LoadingScreenState();
  }


}

class _LoadingScreenState extends State<LoadingScreen> {

@override
  void initState() {
    super.initState();
    Future.delayed(const Duration(
      seconds: 3),
      () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.hasData) {
                return TabsScreen();
              }
              return const LandingPageScreen();
            }
          )),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logoLoading.png'),
            const SizedBox(height: 20),
            Text('Memory Places',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 36,
              fontFamily: 'RobotoSlab',
              fontWeight: FontWeight.w500,
            ),
            ),
            const SizedBox(height: 15,),
            const SpinKitThreeBounce(
              color: Color(0xFFEAB857),
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}