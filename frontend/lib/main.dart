import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:frontend/view_models/symptom_view_model.dart';
import 'package:frontend/views/onbordingScreen.dart';
// import 'package:frontend/views/onbordingScreen.dart';
import 'package:frontend/views/symptom_checker_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend/view_models/auth_viewModel.dart';

// Import device_preview

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
        ChangeNotifierProvider(create: (_) => SymptomViewModel()),
        ChangeNotifierProvider(create: (_) => HealthProfileViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true, // Important for DevicePreview
        locale: DevicePreview.locale(context), // Add the locale
        builder: DevicePreview.appBuilder, // Add the builder
        title: 'ai-health-app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}