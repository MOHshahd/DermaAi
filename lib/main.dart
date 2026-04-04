import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(DermaAIApp());
}

class DermaAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermaAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Roboto'),
      home: SplashScreen(),
    );
  }
}
