import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'scan_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Professional Medical Color Palette
  final Color primaryBlue = const Color(0xFF0056D2);
  final Color surfaceWhite = const Color(0xFFF8FAFC);

  // 🖼 Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // 📤 Send image to SwinV2-Base Server
  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;

    setState(() => _isLoading = true);

    const url = "https://rf3t-skin-disease-backend.hf.space/predict";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

      // 30 second timeout for the 88M parameter SwinV2-Base model
      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _handleServerResponse(data);
      } else {
        _showSnackBar("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackBar("Connection failed. Please check your internet.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleServerResponse(Map<String, dynamic> data) {
    String status = data['status'];

    if (status == "success") {
      _showResultSheet(
        title: "Analysis Complete",
        disease: data['disease_name'],
        confidence: data['confidence'].toString(),
        isError: false,
      );
    } else {
      _showResultSheet(
        title: status == "invalid" ? "Object Not Recognized" : "Uncertain Analysis",
        message: data['message'],
        suggestion: data['suggestion'],
        isError: true,
      );
    }
  }

  void _showResultSheet({
    required String title,
    String? disease,
    String? confidence,
    String? message,
    String? suggestion,
    required bool isError,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isError ? Colors.redAccent : primaryBlue
                )
            ),
            const Divider(height: 30),
            if (!isError) ...[
              Text("Detected Condition:", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 5),
              Text(disease!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text("AI Confidence: $confidence%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ),
            ] else ...[
              Text(message!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3))
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          "Suggestion: $suggestion",
                          style: const TextStyle(color: Colors.black87, fontSize: 14)
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceWhite,
      appBar: AppBar(
        title: const Text("DermaAI Gallery", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen())),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Instruction Card
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.grey.shade200)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.collections, color: primaryBlue),
                            const SizedBox(width: 10),
                            const Text("Gallery Guidelines", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStep("Select high-resolution photos"),
                        _buildStep("Avoid screenshots or blurry images"),
                        _buildStep("Ensure the lesion is the main focus"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Image Preview Area
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(_imageFile!, fit: BoxFit.cover)
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("No Image Selected", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: primaryBlue)
                        ),
                        onPressed: _pickImage,
                        icon: Icon(Icons.add_photo_alternate, color: primaryBlue),
                        label: Text("Select Image", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: (_imageFile == null || _isLoading) ? null : _analyzeImage,
                        child: const Text("Analyze Skin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(35),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: primaryBlue),
                        const SizedBox(height: 25),
                        const Text("SwinV2-Base Analysis", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text("Extracting deep features...", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}