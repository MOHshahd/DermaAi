import 'package:derma_ai/screens/doctorDetails.dart';
import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'location_screen.dart';
import 'doctorDetails.dart';
import 'chatbotScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget serviceCard(IconData icon, String title, Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget doctorCard(BuildContext context, String name, Color color, Image img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(25), child: img),

          const SizedBox(width: 70, height: 70),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text("Dermatologist"),
            ],
          ),
          const Spacer(),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => doctordetails(name: name),
                ),
              );
            },
            child: const Text("Details"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Hello, User ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications_none),
                      SizedBox(width: 10),
                      Icon(Icons.person_outline),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanScreen(),
                        ),
                      );
                    },
                    child: serviceCard(Icons.camera_alt, "Scan", Colors.orange),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationScreen(),
                        ),
                      );
                    },
                    child: serviceCard(
                      Icons.location_on,
                      "Nearby",
                      Colors.blue,
                    ),
                  ),

                  serviceCard(Icons.monitor_heart, "Monitor", Colors.purple),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatbotIntroApp(),
                        ),
                      );
                    },
                    child: serviceCard(Icons.chat, "Chatbot", Colors.green),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                "Recommended Doctors Near You",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              doctorCard(
                context,
                "Dr. Ahmed Ali",
                const Color(0xffE9DDF7),
                Image.asset(
                  "assets/doc1.jpeg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),

              doctorCard(
                context,
                "Dr. Salim Khaled",
                const Color(0xffF6E6C9),
                Image.asset(
                  "assets/doc2.jpeg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),

              doctorCard(
                context,
                "Dr. Sara Hassan",
                const Color(0xffDCEFF5),
                Image.asset(
                  "assets/doc1.jpeg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              doctorCard(
                context,
                "Dr. Salim Khaled",
                const Color(0xffE9DDF7),
                Image.asset(
                  "assets/doc2.jpeg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),

              doctorCard(
                context,
                "Dr. Sara Hassan",
                const Color(0xffF6E6C9),
                Image.asset(
                  "assets/doc1.jpeg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              doctorCard(
                context,
                "Dr. Salim Khaled",
                const Color(0xffDCEFF5),
                Image.asset(
                  "assets/doc2.jpeg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
