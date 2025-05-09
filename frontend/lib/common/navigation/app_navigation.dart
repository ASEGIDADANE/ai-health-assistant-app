import 'package:flutter/material.dart';
import 'package:frontend/views/onbordingScreen.dart';

class AppNavigator {

  static void pushReplacement(BuildContext context,Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget)
    );
  }

  static void push(BuildContext context,Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget)
    );
  }

  static void pushAndRemove(BuildContext context,Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false
    );
  }
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
 
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}