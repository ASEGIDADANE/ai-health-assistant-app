import 'package:flutter/material.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:provider/provider.dart';

class ProfileHomeScreen extends StatelessWidget {
  const ProfileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Home',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Your Chat Type',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 30),
              _buildChatTypeCard(
                context,
                icon: Icons.person_outline_rounded,
                title: 'Personal Health Chat',
                subtitle: 'Get personalized health advice based on your profile',
                features: [
                  'Personalized responses based on your health profile',
                  'More accurate health recommendations',
                  'Track your health conversations',
                ],
                onTap: () {
                  Provider.of<HealthProfileViewModel>(context, listen: false)
                      .initiateProfileSetup();
                  Navigator.pushNamed(context, '/profile_setup');
                },
              ),
              const SizedBox(height: 20),
              _buildChatTypeCard(
                context,
                icon: Icons.chat_bubble_outline_rounded,
                title: 'General Health Chat',
                subtitle: 'Quick answers to general health questions',
                features: [
                  'Instant access to health information',
                  'No profile required',
                  'General health guidance',
                ],
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('General Chat Tapped (Not Implemented)')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatTypeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return Card(
      // color: Theme.of(context).colorScheme.surface, // Uses cardTheme.color
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.blue.shade700, size: 28),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1C2A3A)), // Dark blue text
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check, color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}