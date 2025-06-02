import 'package:flutter/material.dart';
import 'package:frontend/common/navigation/app_navigation.dart';
import 'package:frontend/view_models/auth_viewModel.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:frontend/views/Profile_setup_flow/profile_setup_container_screen.dart';
import 'package:frontend/views/general_chat_withai.dart';
import 'package:frontend/views/homeScreen.dart';
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
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Your Chat Type',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              _buildChatTypeCard(
                context,
                icon: Icons.person_outline_rounded,
                title: 'Personal Health Chat',
                subtitle:
                    'Get personalized health advice based on your profile',
                features: [
                  'Personalized responses based on your health profile',
                  'More accurate health recommendations',
                  'Track your health conversations',
                ],
                
                onTap: () {
                  Provider.of<HealthProfileViewModel>(
                    context,
                    listen: false,
                  ).initiateProfileSetup();

                  final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                  if (authViewModel.isProfileCompleted) {
                    // Profile is complete, navigate directly to personalized chat
                    AppNavigator.push(
                      context,
                      const homeScreen(), // Ensure this screen exists and is imported
                    );
                  } else {
                    // Profile is not complete, initiate setup
                    AppNavigator.push(
                      context,
                      const ProfileSetupContainerScreen(),
                    );
                  }
                  

                  // AppNavigator.push(
                  //   context,
                  //   const ProfileSetupContainerScreen(),
                  // );
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
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //       content: Text('General Chat Tapped (Not Implemented)')),
                  // );
                  AppNavigator.push(context, const GeneralChatWithAi());
                  // AppNavigator.push(context, );
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
                            color: Color(0xFF1C2A3A),
                          ), // Dark blue text
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...features.map(
                (feature) => Padding(
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
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:frontend/common/navigation/app_navigation.dart';
// import 'package:frontend/view_models/auth_viewModel.dart'; // Added import for AuthViewModel
// import 'package:frontend/view_models/healthProfile_viewModel.dart';
// import 'package:frontend/views/Profile_setup_flow/profile_setup_container_screen.dart';
// import 'package:frontend/views/chat_with_ai_page.dart';
// import 'package:frontend/views/general_chat_withai.dart';
// // Assuming you have a personalized chat screen, replace with your actual screen
// // import 'package:frontend/views/personalized_chat_screen.dart'; // Placeholder for your personalized chat screen
// import 'package:provider/provider.dart';

// class ProfileHomeScreen extends StatelessWidget {
//   const ProfileHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Access AuthViewModel here to check profile completion status
//     final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Home',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white70,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Choose Your Chat Type',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               _buildChatTypeCard(
//                 context,
//                 icon: Icons.person_outline_rounded,
//                 title: 'Personal Health Chat',
//                 subtitle:
//                     'Get personalized health advice based on your profile',
//                 features: [
//                   'Personalized responses based on your health profile',
//                   'More accurate health recommendations',
//                   'Track your health conversations',
//                 ],
//                 onTap: () {
//                   if (authViewModel.isProfileCompleted) {
//                     // Profile is complete, navigate directly to personalized chat
//                     // Replace PersonalizedChatScreen() with your actual personalized chat screen widget
//                     AppNavigator.push(
//                       context,
//                       const ChatWithAIPage(), // Ensure this screen exists and is imported
//                     );
//                   } else {
//                     // Profile is not complete, initiate setup
//                     Provider.of<HealthProfileViewModel>(
//                       context,
//                       listen: false,
//                     ).initiateProfileSetup();

//                     AppNavigator.push(
//                       context,
//                       const ProfileSetupContainerScreen(),
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildChatTypeCard(
//                 context,
//                 icon: Icons.chat_bubble_outline_rounded,
//                 title: 'General Health Chat',
//                 subtitle: 'Quick answers to general health questions',
//                 features: [
//                   'Instant access to health information',
//                   'No profile required',
//                   'General health guidance',
//                 ],
//                 onTap: () {
//                   AppNavigator.push(context, const GeneralChatWithAi());
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChatTypeCard(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required List<String> features,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(icon, color: Colors.blue.shade700, size: 28),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1C2A3A),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           subtitle,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               ...features.map(
//                 (feature) => Padding(
//                   padding: const EdgeInsets.only(bottom: 10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.check, color: Colors.green.shade600, size: 20),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           feature,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }