import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';

// Import your screens
import 'package:frontend/views/Profile_home_screen.dart'; // <<< IMPORT YOUR HomeScreen
import 'package:frontend/views/Profile_setup_flow/profile_setup_container_screen.dart';

// Import your ViewModels
// Make sure this import path is correct for your HealthProfileViewModel
import 'package:frontend/view_models/auth_viewModel.dart'; // Their ViewModel

import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HealthProfileViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'ai-health-app', // Can be your title for now
        theme: ThemeData( // You'll eventually merge your full theme here
          // For now, let's use a simpler version of your theme's ColorScheme
          // to get the dark background on HomeScreen working.
          // When doing the actual PR, you'll merge your ThemeData more carefully.
          primaryColor: Colors.blue.shade600,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade600).copyWith(
            background: const Color(0xFF2C3E50), // Dark bg for Home Screen
            surface: Colors.white,
          ),
          // You can add more of your theme properties here for testing if needed
        ),
        // home: const ProfileSetupContainerScreen(), // <<< COMMENT OUT OR REMOVE 'home'

        initialRoute: '/', // <<< SET YOUR INITIAL ROUTE
        routes: {
          '/': (context) => const ProfileHomeScreen(), // <<< YOUR HOME SCREEN AT '/'
          '/profile_setup': (context) => const ProfileSetupContainerScreen(), // YOUR PROFILE SETUP
          // If the team has other routes, you'd eventually merge them here too.
          // For example:
          // '/onboarding': (context) => const OnboardingScreen(),
        },
      ),
    );
  }
}