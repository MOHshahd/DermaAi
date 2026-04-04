import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final double lat;
  final double lng;
  final String apiKey;

  const MapScreen({required this.lat, required this.lng, required this.apiKey});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    fetchClinics();
    fetchClinicss();
  }

  Future<void> fetchClinics() async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${widget.lat},${widget.lng}"
        "&radius=5000"
        "&type=doctor"
        "&keyword=dermatologist"
        "&key=${widget.apiKey}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data["results"];

      Set<Marker> newMarkers = {};

      // User location marker
      newMarkers.add(
        Marker(
          markerId: MarkerId("user"),
          position: LatLng(widget.lat, widget.lng),
          infoWindow: InfoWindow(title: "You are here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      // Clinics markers
      for (var clinic in results) {
        var loc = clinic["geometry"]["location"];

        newMarkers.add(
          Marker(
            markerId: MarkerId(clinic["name"]),
            position: LatLng(loc["lat"], loc["lng"]),
            infoWindow: InfoWindow(
              title: clinic["name"],
              snippet: clinic["vicinity"],
            ),
          ),
        );
      }

      setState(() {
        markers = newMarkers;
      });
    }
  }

  Future<void> fetchClinicss() async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${widget.lat},${widget.lng}"
        "&radius=5000"
        "&type=doctor"
        "&keyword=dermatologist"
        "&key=${widget.apiKey}";

    final response = await http.get(Uri.parse(url));

    print(response.body); // 👈 ADD THIS

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // 👈 DEBUG

      final results = data["results"];

      if (results.isEmpty) {
        print("No clinics found");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Clinics")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 14,
        ),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
