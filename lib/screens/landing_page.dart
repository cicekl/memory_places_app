import 'package:flutter/material.dart';
import 'package:memory_places_app/screens/login.dart';
import 'package:memory_places_app/widgets/feature_card.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

class LandingPageScreen extends StatelessWidget {

const LandingPageScreen ({super.key});

void _getStarted(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (ctx) => const LoginScreen()));
}


@override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
            "assets/landingBackground.jpeg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Image.asset('assets/logo.png'),
                  const SizedBox(height: 15,),
                  Text('Memory Places',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 36,
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                  const SizedBox(height: 8,),
                  Text('Hold onto the places that matter',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 20,
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                  const SizedBox(height: 40,),
                  FeatureCard(
                    title: 'Capture Moments', 
                    description: 'Take photos of your favorite spots', 
                    icon: Icons.camera_alt, 
                    color: Color(0xFFEAB857),
                    ),
                    const SizedBox(height: 10,),
                    FeatureCard(
                    title: 'Save Locations', 
                    description: 'Mark where memories live', 
                    icon: Icons.pin_drop, 
                    color: Color(0xFF728B25),
                    ),
                    const SizedBox(height: 10,),
                    FeatureCard(
                    title: 'Relive Memories', 
                    description: 'Moments you can return to', 
                    icon: Icons.favorite, 
                    color: Color(0xFF714D2D),
                    ),
                  const SizedBox(height: 47,),
                  PrimaryButton(btnText: 'Get Started', onPress: () {
                    _getStarted(context);
                  })
                ],
              ),
            ),
        ),
        ),
    ]);
  }

}