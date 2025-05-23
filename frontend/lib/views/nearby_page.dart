import 'package:flutter/material.dart';
import 'package:frontend/views/nearby_detail_page.dart';

class HospitalInfo {
  final String name;
  final String place_id;
  
 

  HospitalInfo({
    required this.name,
    required this.place_id,

   
  });
}

class NearbyHospitalsScreen extends StatelessWidget {
  final List<HospitalInfo> hospitals = [
    HospitalInfo(
      name: "Paul's Hospitals",
      place_id: '123 Main St',
   
    ),
    HospitalInfo(
      name: 'Black Lion Hospital',
      place_id: 'Ras Desta Damtew St',
     
    ),
    HospitalInfo(
      name: 'Zewditu Memorial Hospital',
      place_id: '432 Addis Ketema St',
 
    ),
    HospitalInfo(
      name: 'Yekatit 12 Hospital',
      place_id: '249 Churchill Road',
    
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8), 
      appBar: AppBar(
        backgroundColor: Colors.white, 
        elevation: 0, 
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFF1D2D3A), size: 22),
          onPressed: () {
           
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Nearby Hospitals',
          style: TextStyle(
            color: Color(0xFF1D2D3A), 
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        titleSpacing: 0, 
      ),
     
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                final hospital = hospitals[index];
                return HospitalCard(
                  hospitalInfo: hospital,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final HospitalInfo hospitalInfo;

  HospitalCard({
    required this.hospitalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyDetailPage()));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Color(0xFF2F80ED), width: 1.5), 
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    hospitalInfo.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2D3A),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    hospitalInfo.place_id,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'avaliable',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700], 
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10), 
            Padding(
              padding: const EdgeInsets.only(top: 2.0), 
              child: Text(
                '5 min',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
