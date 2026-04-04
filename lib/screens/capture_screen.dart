import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'scan_screen.dart';

class CaptureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinCameraPage(),
    );
  }
}

class SkinCameraPage extends StatefulWidget {
  const SkinCameraPage({super.key});

  @override
  State<SkinCameraPage> createState() => _SkinCameraPageState();
}

class _SkinCameraPageState extends State<SkinCameraPage> {
  File? imageFile;
  String result = "Capture a skin image to analyze";

  final ImagePicker picker = ImagePicker();

  // 📷 Capture image from camera
  Future captureImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
        result = "Image captured. Send to AI server.";
      });
    }
  }

  // 📤 Send image to AI server
  Future sendImage() async {
    if (imageFile == null) {
      setState(() {
        result = "Please capture an image first";
      });
      return;
    }

    const url = "https://rf3t-skin-disease-backend.hf.space/predict";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile!.path),
      );

      var response = await request.send();

      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        setState(() {
          result =
              "Disease: ${data["disease_name"]}\nConfidence: ${data["confidence"]}%";
        });
      } else {
        setState(() {
          result = "Server Error ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Request Failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(title: const Text("Skin Disease Detection")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanScreen()),
                  );
                },
              ),
            ),
            const Text(
              "📋 How to take a clear skin image",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "• Hold the camera 10–15 cm from the skin\n"
              "• Ensure good lighting\n"
              "• Focus clearly on the affected area\n"
              "• Avoid shadows or blurry photos\n"
              "• Keep only the skin area in the frame",
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 25),

            imageFile != null
                ? Image.file(imageFile!, height: 220)
                : const Text("No image captured"),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: captureImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Image"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: sendImage,
              child: const Text("Analyze Skin"),
            ),

            const SizedBox(height: 30),

            Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
