import 'package:flutter/material.dart';
import 'package:frontend/common/navigation/app_navigation.dart';
import 'package:frontend/views/loginscreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Color _primaryColor = Colors.blue;

  final List<OnboardingPage> _onboardingPages = [
    OnboardingPage(
      title: "AI-Powered\nHealth Support",
      description:
          "Get instant answers to your\nhealth questions with our\nadvanced AI Assistant",
      imagePath: 'assets/images/support.png',
    ),
    OnboardingPage(
      title: "Quick Symptom Check",
      description:
          "Understand your symptoms and get\nrecommended actions with\nour smart symptom checker",
      imagePath: 'assets/images/symptoms.png',
    ),
    OnboardingPage(
      title: "Find Care Nearby",
      description:
          "Locate hospitals, clinics, and\npharmacies in your area when you\nneed them most",
      imagePath: 'assets/images/nearby.png',
    ),
  ];

  void _navigateToLogin() {
    AppNavigator.pushReplacement(context, const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _onboardingPages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPageWidget(
                  page: _onboardingPages[index],
                  primaryColor: _primaryColor,
                );
              },
            ),

            // Skip button (top right)
            if (_currentPage != _onboardingPages.length - 1)
              Positioned(
                top: 20,
                right: 20,
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),

            // Page indicator (bottom center)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),

            // Next/Get Started button (bottom right)
            Positioned(
              bottom: 40,
              right: 30,
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextButton(
                  onPressed: () {
                    if (_currentPage == _onboardingPages.length - 1) {
                      _navigateToLogin();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _onboardingPages.length - 1
                        ? "Get Started"
                        : "Next",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    return List.generate(
      _onboardingPages.length,
      (index) => Container(
        width: 7.0,
        height: 7.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              _currentPage == index
                  ? _primaryColor
                  : Colors.grey.withOpacity(0.4),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final Color primaryColor;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(page.imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
