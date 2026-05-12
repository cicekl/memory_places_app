import 'package:flutter/material.dart';
import 'package:memory_places_app/screens/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Places',
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

