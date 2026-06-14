import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_places_app/views/screens/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memory_places_app/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Places',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: const Color(0xFF4A3728),
          displayColor: const Color(0xFF4A3728),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A9B61),
          primary: const Color(0xFF8A9B61),
          secondary: const Color(0xFFEAB857),
          surface: const Color(0xFFF5F1E8),
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF4A3728),
          onSurface: const Color(0xFF4A3728),
        ),
      ),
      home: LoadingScreen(),
    );
  }
}
