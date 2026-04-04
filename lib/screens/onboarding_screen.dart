import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/onboarding1.jpeg",
      "title": "Detect Skin Diseases Early",
      "subtitle": "Scan affected areas and get an AI-based analysis.",
    },
    {
      "image": "assets/onboarding2.jpeg",
      "title": "Monitor Your Condition",
      "subtitle": "Track your condition step by step.",
    },
    {
      "image": "assets/onboarding3.jpeg",
      "title": "Consult Dermatologists",
      "subtitle": "Connect with certified dermatologists.",
    },
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.blueGrey : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(onboardingData[index]["image"]!),
                      ),
                      SizedBox(height: 20),
                      Text(
                        onboardingData[index]["title"]!,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        onboardingData[index]["subtitle"]!,
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          buildDots(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: nextPage,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueGrey,
              ),
              child: Text(currentIndex == 2 ? "Get Started" : "Next",style: TextStyle(color: Colors.white)),)
            ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
