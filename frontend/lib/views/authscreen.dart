import 'package:flutter/material.dart';
import 'package:frontend/views/loginscreen.dart';
import 'package:frontend/views/signupScreen.dart';

class HealthAssistWelcomeScreen extends StatelessWidget {
  const HealthAssistWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image section (dummy image for now)
                Image.asset(
                  'assets/images/welcome.png', // Replace with your image later
                  height: 200,
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Welcome to HealthAssist',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  'Your personal AI-powered health\nassistant for immediate guidance\nand support.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                     
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    
                    },
                    style: ElevatedButton.styleFrom(
                      
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 16),

    
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                   
                  
                    },
                    style: OutlinedButton.styleFrom(
                      
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
