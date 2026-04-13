import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    debugPrint(" .env loaded successfully");
  } catch (e) {
    debugPrint("Error loading .env file: $e");
  }

  await Firebase.initializeApp();

  runApp(const DermaAIApp());
}

class DermaAIApp extends StatelessWidget {
  const DermaAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermaAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0056D2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0056D2),
          primary: const Color(0xFF0056D2),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}