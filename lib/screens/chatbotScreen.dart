import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chat_screen.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io';

class ChatbotIntroApp extends StatelessWidget {
  const ChatbotIntroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatbot Intro',
      home: const ChatbotIntroScreen(),
    );
  }
}

class ChatbotIntroScreen extends StatefulWidget {
  const ChatbotIntroScreen({super.key});

  @override
  State<ChatbotIntroScreen> createState() => _ChatbotIntroScreenState();
}

class _ChatbotIntroScreenState extends State<ChatbotIntroScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = "";

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _speechText = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // هنا ممكن تبعتي الصورة للـ ChatScreen أو السيرفر
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Back arrow
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              /// Robot Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/robo.jpeg",
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Title
              const Text(
                "Your Medical Assistant",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              /// Description
              const Text(
                "“Meet Lateef, your medical assistant who helps you understand your condition and gives you personalized advice based on your health.”",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              /// Audio & Image Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 32),
                    onPressed: _listen,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.image, size: 32),
                    onPressed: _pickImage,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5D8AA8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}