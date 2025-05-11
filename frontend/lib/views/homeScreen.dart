import 'package:flutter/material.dart';
import 'package:frontend/views/chat_with_ai_page.dart';
import 'package:frontend/views/first_aid_guidScreen.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.green[100],
            child: const Text('H', style: TextStyle(color: Colors.white)),
          ),
        ),
        title: const Text(
          'Health Assistant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'How can we help you today?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _HomeCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Chat with AI',
                    subtitle: 'Get instant answers to your health questions',
                    color: Colors.blue[50],
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChatWithAIPage()
                          ),
                        ),
                  ),
                  _HomeCard(
                    icon: Icons.warning_amber_outlined,
                    title: 'First Aid Guide',
                    subtitle: 'Quick access to emergency care steps',
                    color: Colors.red[50],
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => FirstAidGuidePage()
                          ),
                        ),
                  ),
                  _HomeCard(
                    icon: Icons.assignment_outlined,
                    title: 'Symptom Checker',
                    subtitle: 'Check your symptoms and get guidance',
                    color: Colors.green[50],
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const PlaceholderPage(
                                  title: 'Symptom Checker',
                                ),
                          ),
                        ),
                  ),
                  _HomeCard(
                    icon: Icons.location_on_outlined,
                    title: 'Nearby Services',
                    subtitle: 'Find hospitals and pharmacies nearby',
                    color: Colors.blueGrey[50],
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const PlaceholderPage(
                                  title: 'Nearby Services',
                                ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.only(left: 16, right:16,top:16,bottom:11),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.black54),
            const SizedBox(height: 16),
            Text(
              textAlign: TextAlign.center,
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title page.')),
    );
  }
}
