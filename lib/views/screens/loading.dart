import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:memory_places_app/providers/auth_provider.dart';
import 'package:memory_places_app/views/screens/landing_page.dart';
import 'package:memory_places_app/views/screens/tabs.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = ref.read(authProvider);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            if (user != null) {
              return const TabsScreen();
            }

            return const LandingPageScreen();
          },
        ),
      );
    });
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
            Text(
              'Memory Places',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 36,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            const SpinKitThreeBounce(color: Color(0xFFEAB857), size: 25),
          ],
        ),
      ),
    );
  }
}
