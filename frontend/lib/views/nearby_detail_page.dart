import 'package:flutter/material.dart';
// Import a map plugin if you plan to show a map, e.g.:
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyDetailPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String placeName;
  final String placeId;
  final String vicinity;

  const NearbyDetailPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.placeName,
    required this.placeId,
    required this.vicinity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeName),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1D2D3A), // For back arrow and title color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details for: $placeName',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Place ID: $placeId', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Address: $vicinity', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Latitude: $latitude', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Longitude: $longitude', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // Placeholder for a map view
            // Expanded(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.grey),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Center(
            //       child: Text(
            //         'Map View for $placeName\nLat: $latitude, Lng: $longitude',
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     // child: GoogleMap(
            //     //   initialCameraPosition: CameraPosition(
            //     //     target: LatLng(latitude, longitude),
            //     //     zoom: 15,
            //     //   ),
            //     //   markers: {
            //     //     Marker(
            //     //       markerId: MarkerId(placeId),
            //     //       position: LatLng(latitude, longitude),
            //     //       infoWindow: InfoWindow(title: placeName, snippet: vicinity),
            //     //     ),
            //     //   },
            //     // ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}