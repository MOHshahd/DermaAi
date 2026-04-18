import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // try {
  //   await dotenv.load(fileName: ".env");
  //   debugPrint(" .env loaded successfully");
  // } catch (e) {
  //   debugPrint("Error loading .env file: $e");
  // }

  //await Firebase.initializeApp();

    await Supabase.initialize(
    url: 'https://fqswccltpvgyfqqlmbyt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxc3djY2x0cHZneWZxcWxtYnl0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYxOTY5MzEsImV4cCI6MjA5MTc3MjkzMX0.g9jJ4OwNSseAXxql1X50QRibMEhSlMUk_oDmZ3d_MVQ',
  );

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