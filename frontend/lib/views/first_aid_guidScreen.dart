import 'package:flutter/material.dart';
import 'package:frontend/views/fristAidDetailPage.dart';

class FirstAidGuidePage extends StatelessWidget {
  const FirstAidGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_FirstAidItem> items = [
      _FirstAidItem('Cuts and Bleeding', 'View emergency steps', [
        'Apply pressure to stop the bleeding.',
        'Clean the wound with water.',
        'Cover with a sterile bandage.',
        'Seek medical help if bleeding is severe.'
      ]),
      _FirstAidItem('Burns', 'View emergency steps', [
        'Cool the burn under running water for 10 minutes.',
        'Do not apply ice.',
        'Cover with a clean, non-stick bandage.',
        'Seek medical help for severe burns.'
      ]),
      _FirstAidItem('Choking', 'View emergency steps', [
        'Ask if the person can speak or cough.',
        'If not, perform abdominal thrusts (Heimlich maneuver).',
        'Call emergency services if needed.'
      ]),
      _FirstAidItem('Heart Attack', 'View emergency steps', [
        'Call emergency services immediately.',
        'Keep the person calm and seated.',
        'Loosen tight clothing.',
        'Give aspirin if not allergic.'
      ]),
      _FirstAidItem('Fractures', 'View emergency steps', [
        'Immobilize the injured area.',
        'Apply a cold pack to reduce swelling.',
        'Do not try to realign the bone.',
        'Seek medical help immediately.'
      ]),
      _FirstAidItem('Fractures', 'View emergency steps', [
        'Immobilize the injured area.',
        'Apply a cold pack to reduce swelling.',
        'Do not try to realign the bone.',
        'Seek medical help immediately.'
      ]),
      _FirstAidItem('Fractures', 'View emergency steps', [
        'Immobilize the injured area.',
        'Apply a cold pack to reduce swelling.',
        'Do not try to realign the bone.',
        'Seek medical help immediately.'
      ]),
      _FirstAidItem('Fractures', 'View emergency steps', [
        'Immobilize the injured area.',
        'Apply a cold pack to reduce swelling.',
        'Do not try to realign the bone.',
        'Seek medical help immediately.'
      ]),
      _FirstAidItem('Fractures', 'View emergency steps', [
        'Immobilize the injured area.',
        'Apply a cold pack to reduce swelling.',
        'Do not try to realign the bone.',
        'Seek medical help immediately.'
      ]),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.warning_amber_outlined, color: Colors.red, size: 32),
        title: const Text(
          'First Aid Guide',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
            child: Text(
              'Quick emergency response steps',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  color: Colors.red[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_outlined, color: Colors.red),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.subtitle),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FristAidDetailPage(title: item.title, steps: item.steps),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Text(
                'This guide is for reference only. Always seek professional medical help in emergencies.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FirstAidItem {
  final String title;
  final String subtitle;
  final List<String> steps;
  _FirstAidItem(this.title, this.subtitle, this.steps);
}
