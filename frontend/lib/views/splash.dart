import 'package:flutter/material.dart';
class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 2, 15, 39),
     
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/splash.jpg' ,), fit: BoxFit.cover),
            SizedBox(height: 20),
            Text(
              'Your Personal Health Companion',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300 , color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}