import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/splash_capsules.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "Derma",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: "AI",
                    style: TextStyle(color: Color(0xff5F9EA0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
