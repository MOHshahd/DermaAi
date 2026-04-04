import 'package:flutter/material.dart';
import 'home_screen.dart';

class doctordetails extends StatelessWidget {
  final String name;
  const doctordetails({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Profile',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DoctorProfileScreen(),
    );
  }
}

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF7F7),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const Text(
              "Doctor’s Profile",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15, width: 100),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xffD7EEF2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. Ahmed Ali",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text("Dermatology", style: TextStyle(fontSize: 15)),
                        Text(
                          "1.2 km away from u",
                          style: TextStyle(fontSize: 15),
                        ),
                        Row(
                          children: [Icon(Icons.star, size: 16), Text("4.8")],
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/doc1.jpeg",
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Address",style: TextStyle(fontSize: 15)),
            const Text("El-Gaish Rd, Gleem District, Alexandria",style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            const Text("About",style: TextStyle(fontSize: 15)),
            const Text(
              "Dr Ahmed is one of the most prestigious dermatologists...",style: TextStyle(fontSize: 15)
            ),
            const SizedBox(height: 10),
            const Text("Working times",style: TextStyle(fontSize: 15)),
            const Text("Monday to Friday, 08:00 AM – 19:00 PM",style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
