import 'package:derma_ai/screens/capture_screen.dart';
import 'package:derma_ai/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                /// Back arrow
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>HomeScreen() ,
                      ),
                    );
                  }
                ),
              ),
                const Text(
                  "Scan",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Choose one of the following options",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 25),

                /// Scan Card
                _buildCard(
                  color: const Color(0xffE6D9F2),
                  image: "assets/scan.jpeg",
                  title: "Scan",
                  description:
                      "Take a photo of your skin spot and get instant AI analysis",
                  buttonText: "Scan", onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CaptureScreen()),
                );},
                ),

                const SizedBox(height: 20),

                /// Upload Card
                _buildCard(
                  color: const Color(0xffD7EEF2),
                  image: "assets/upload.jpeg",
                  title: "Upload",
                  description:
                      "Upload a photo of your skin spot and get instant AI analysis",
                  buttonText: "Upload",
                  onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
                );
              },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required Color color,
    required String image,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 12),

          /// Title + Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // white button
                  foregroundColor: Colors.black, // black text
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
                child: Text(buttonText),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
