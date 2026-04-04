import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;

  Future<void> signUp() async {
    // 🔴 Validation
    if (email.text.isEmpty ||
        password.text.isEmpty ||
        name.text.isEmpty ||
        phone.text.isEmpty) {
      showMessage("Please fill all fields");
      return;
    }

    if (password.text.length < 6) {
      showMessage("Password must be at least 6 characters");
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      showMessage("Account created successfully ✅");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already registered";
          break;
        case 'invalid-email':
          message = "Invalid email format";
          break;
        case 'weak-password':
          message = "Password is too weak";
          break;
        default:
          message = "Signup failed";
      }

      showMessage(message);
    } catch (e) {
      showMessage("Something went wrong");
    }

    setState(() => isLoading = false);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

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
          children: [
            Text(
              "Create Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: "Full name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            TextField(
              controller: phone,
              decoration: InputDecoration(
                labelText: "Phone number",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 24),

            /// 🔥 SIGN UP BUTTON
            ElevatedButton(
              onPressed: isLoading ? null : signUp,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueGrey,
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("SIGN UP",
                      style: TextStyle(color: Colors.white)),
            ),

            SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Already have an account? Sign in",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}