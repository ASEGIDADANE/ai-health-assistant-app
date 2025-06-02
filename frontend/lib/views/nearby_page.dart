// import 'package:flutter/material.dart';
// import 'package:frontend/views/nearby_detail_page.dart';

// class HospitalInfo {
//   final String name;
//   final String place_id;
  
 

//   HospitalInfo({
//     required this.name,
//     required this.place_id,

   
//   });
// }

// class NearbyHospitalsScreen extends StatelessWidget {
//   final List<HospitalInfo> hospitals = [
//     HospitalInfo(
//       name: "Paul's Hospitals",
//       place_id: '123 Main St',
   
//     ),
//     HospitalInfo(
//       name: 'Black Lion Hospital',
//       place_id: 'Ras Desta Damtew St',
     
//     ),
//     HospitalInfo(
//       name: 'Zewditu Memorial Hospital',
//       place_id: '432 Addis Ketema St',
 
//     ),
//     HospitalInfo(
//       name: 'Yekatit 12 Hospital',
//       place_id: '249 Churchill Road',
    
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF0F4F8), 
//       appBar: AppBar(
//         backgroundColor: Colors.white, 
//         elevation: 0, 
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFF1D2D3A), size: 22),
//           onPressed: () {
           
//             if (Navigator.canPop(context)) {
//               Navigator.pop(context);
//             }
//           },
//         ),
//         title: Text(
//           'Nearby Hospitals',
//           style: TextStyle(
//             color: Color(0xFF1D2D3A), 
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         titleSpacing: 0, 
//       ),
     
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//               itemCount: hospitals.length,
//               itemBuilder: (context, index) {
//                 final hospital = hospitals[index];
//                 return HospitalCard(
//                   hospitalInfo: hospital,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HospitalCard extends StatelessWidget {
//   final HospitalInfo hospitalInfo;

//   HospitalCard({
//     required this.hospitalInfo,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
        
//         Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyDetailPage()));
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16.0),
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//           border: Border.all(color: Color(0xFF2F80ED), width: 1.5), 
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     hospitalInfo.name,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1D2D3A),
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     hospitalInfo.place_id,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     'avaliable',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[700], 
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 10), 
//             Padding(
//               padding: const EdgeInsets.only(top: 2.0), 
//               child: Text(
//                 '5 min',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:frontend/models/nearby_model.dart'; // Your backend data model
// import 'package:frontend/view_models/nearby_viewModel.dart';
// import 'package:frontend/views/nearby_detail_page.dart';
// import 'package:provider/provider.dart';
// import 'package:geolocator/geolocator.dart'; // Import geolocator

// class NearbyHospitalsScreen extends StatefulWidget {
//   // Constructor no longer requires latitude, longitude, or placeType
//   const NearbyHospitalsScreen({Key? key}) : super(key: key);

//   @override
//   State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
// }

// class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
//   Position? _currentPosition;
//   String _locationError = '';
//   bool _isFetchingLocation = true;
//   final String _placeType = "hospital"; // Default place type

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentDeviceLocationAndFetchPlaces();
//   }

//   Future<void> _getCurrentDeviceLocationAndFetchPlaces() async {
//     setState(() {
//       _isFetchingLocation = true;
//       _locationError = '';
//     });

//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (mounted) {
//         setState(() {
//           _locationError = 'Location services are disabled. Please enable them.';
//           _isFetchingLocation = false;
//         });
//       }
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         if (mounted) {
//           setState(() {
//             _locationError = 'Location permissions are denied.';
//             _isFetchingLocation = false;
//           });
//         }
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       if (mounted) {
//         setState(() {
//           _locationError = 'Location permissions are permanently denied. Please enable them in app settings.';
//           _isFetchingLocation = false;
//         });
//       }
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       if (mounted) {
//         setState(() {
//           _currentPosition = position;
//           _isFetchingLocation = false;
//         });
//         // Fetch nearby places now that we have the location
//         final nearbyViewModel = Provider.of<NearbyViewModel>(context, listen: false);
//         print('++++Fetching nearby places for lat: ${_currentPosition!.latitude}, lng: ${_currentPosition!.longitude}');
//         nearbyViewModel.fetchNearbyPlaces(
//           _currentPosition!.latitude.toString(),
//           _currentPosition!.longitude.toString(),
//           _placeType, // Use the default place type
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _locationError = 'Failed to get current location: ${e.toString()}';
//           _isFetchingLocation = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String appBarTitle = _placeType.isNotEmpty
//         ? 'Nearby ${_placeType[0].toUpperCase()}${_placeType.substring(1)}s'
//         : 'Nearby Places';

//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1D2D3A), size: 22),
//           onPressed: () {
//             if (Navigator.canPop(context)) {
//               Provider.of<NearbyViewModel>(context, listen: false).clearData();
//               Navigator.pop(context);
//             }
//           },
//         ),
//         title: Text(
//           appBarTitle,
//           style: const TextStyle(
//             color: Color(0xFF1D2D3A),
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         titleSpacing: 0,
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isFetchingLocation) {
//       return const Center(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 10),
//           Text("Fetching your location..."),
//         ],
//       ));
//     }

//     if (_locationError.isNotEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 _locationError,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _getCurrentDeviceLocationAndFetchPlaces,
//                 child: const Text("Retry"),
//               )
//             ],
//           ),
//         ),
//       );
//     }

//     // If location is fetched successfully, use the Consumer for NearbyViewModel
//     return Consumer<NearbyViewModel>(
//       builder: (context, viewModel, child) {
//         if (viewModel.isLoading && _currentPosition == null) {
//           // This case might be brief if location is fetched quickly
//           // but viewmodel starts loading before location is fully set for the viewmodel's fetch.
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (viewModel.isLoading && _currentPosition != null) {
//            // ViewModel is loading places data
//            return const Center(child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 10),
//               Text("Finding nearby places..."),
//             ],
//           ));
//         }
//         if (viewModel.error != null) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Error fetching places: ${viewModel.error}\nPlease ensure your backend server is running and you have an internet connection.',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         }
//         if (viewModel.nearbyPlaces.isEmpty) {
//           return Center(child: Text('No nearby ${_placeType}s found.'));
//         }
//         return Column(
//           children: [
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//                 itemCount: viewModel.nearbyPlaces.length,
//                 itemBuilder: (context, index) {
//                   final place = viewModel.nearbyPlaces[index];
//                   return NearbyPlaceCard(
//                     place: place,
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class NearbyPlaceCard extends StatelessWidget {
//   final NearbyPlace place;

//   const NearbyPlaceCard({
//     Key? key,
//     required this.place,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => NearbyDetailPage(
//               latitude: place.geometry.location.lat,
//               longitude: place.geometry.location.lng,
//               placeName: place.name,
//               placeId: place.placeId,
//               vicinity: place.vicinity,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16.0),
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//           border: Border.all(color: const Color(0xFF2F80ED), width: 1.5),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     place.name,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1D2D3A),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     place.vicinity,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   if (place.amenity != null)
//                     Text(
//                       'Type: ${place.amenity}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Padding(
//               padding: const EdgeInsets.only(top: 2.0),
//               child: Icon(Icons.info_outline, color: Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:frontend/models/nearby_model.dart'; // Your backend data model
// import 'package:frontend/view_models/nearby_viewModel.dart'; // No longer needed for dummy data
import 'package:frontend/views/nearby_detail_page.dart';
// import 'package:provider/provider.dart'; // No longer needed for dummy data
// import 'package:geolocator/geolocator.dart'; // No longer needed for dummy data

class NearbyHospitalsScreen extends StatelessWidget {
  // Using a default place type for the title, can be adjusted if needed
  final String _placeType = "hospital";

  const NearbyHospitalsScreen({Key? key}) : super(key: key);

  // Create a list of dummy NearbyPlace objects
  static final List<NearbyPlace> _dummyPlaces = [
    NearbyPlace(
      name: "Paul's Hospitals (Dummy)",
      placeId: 'dummy_place_1',
      geometry: Geometry(
        location: Location(lat: 9.0216, lng: 38.7495), // Example coordinates
      ),
      vicinity: '123 Main St, Addis Ababa (Dummy)',
      amenity: 'hospital',
    ),
    NearbyPlace(
      name: 'Black Lion Hospital (Dummy)',
      placeId: 'dummy_place_2',
      geometry: Geometry(
        location: Location(lat: 9.0150, lng: 38.7600), // Example coordinates
      ),
      vicinity: 'Ras Desta Damtew St, Addis Ababa (Dummy)',
      amenity: 'hospital',
    ),
    NearbyPlace(
      name: 'Zewditu Memorial Hospital (Dummy)',
      placeId: 'dummy_place_3',
      geometry: Geometry(
        location: Location(lat: 9.0083, lng: 38.7550), // Example coordinates
      ),
      vicinity: '432 Addis Ketema St, Addis Ababa (Dummy)',
      amenity: 'hospital',
    ),
    NearbyPlace(
      name: 'Yekatit 12 Hospital (Dummy)',
      placeId: 'dummy_place_4',
      geometry: Geometry(
        location: Location(lat: 9.0300, lng: 38.7620), // Example coordinates
      ),
      vicinity: '249 Churchill Road, Addis Ababa (Dummy)',
      amenity: 'hospital',
    ),
     NearbyPlace(
      name: 'Kadisco General Hospital (Dummy)',
      placeId: 'dummy_place_5',
      geometry: Geometry(
        location: Location(lat: 8.9948, lng: 38.7860), // Example coordinates for Kadisco area
      ),
      vicinity: 'Near Kadisco roundabout, Addis Ababa (Dummy)',
      amenity: 'hospital',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    String appBarTitle = _placeType.isNotEmpty
        ? 'Nearby ${_placeType[0].toUpperCase()}${_placeType.substring(1)}s'
        : 'Nearby Places';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1D2D3A), size: 22),
          onPressed: () {
            if (Navigator.canPop(context)) {
              // If you were clearing ViewModel data, that's no longer needed here
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Color(0xFF1D2D3A),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        titleSpacing: 0,
      ),
      body: _buildBodyWithDummyData(context),
    );
  }

  Widget _buildBodyWithDummyData(BuildContext context) {
    if (_dummyPlaces.isEmpty) {
      return Center(child: Text('No nearby ${_placeType}s found (Dummy Data).'));
    }
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            itemCount: _dummyPlaces.length,
            itemBuilder: (context, index) {
              final place = _dummyPlaces[index];
              return NearbyPlaceCard(
                place: place,
              );
            },
          ),
        ),
      ],
    );
  }
}

class NearbyPlaceCard extends StatelessWidget {
  final NearbyPlace place;

  const NearbyPlaceCard({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NearbyDetailPage(
              latitude: place.geometry.location.lat,
              longitude: place.geometry.location.lng,
              placeName: place.name,
              placeId: place.placeId,
              vicinity: place.vicinity,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFF2F80ED), width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2D3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.vicinity,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (place.amenity != null)
                    Text(
                      'Type: ${place.amenity}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(Icons.info_outline, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}