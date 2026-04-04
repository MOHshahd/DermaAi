import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            // Name
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: "Full name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            // Phone
            TextField(
              controller: phone,
              decoration: InputDecoration(
                labelText: "Phone number",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            // Email
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            // Password
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 24),

            // SIGN UP BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueGrey,
              ),
              child: Text("SIGN UP",style: TextStyle(color: Colors.white),),
            ),

            SizedBox(height: 16),

            // SIGN IN BUTTON
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  "Already have an account? Sign in",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}