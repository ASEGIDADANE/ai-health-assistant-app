import 'package:flutter/material.dart';
import 'package:frontend/views/fristAidDetailPage.dart';

class FirstAidGuidePage extends StatelessWidget {
  const FirstAidGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_FirstAidItem> items = [
      _FirstAidItem('Cuts and Bleeding', 'View emergency steps', [
        'Apply direct pressure to the wound using a clean cloth or sterile bandage.',
        'If bleeding is severe, elevate the injured part above the heart if possible.',
        'Clean the wound gently with mild soap and water once bleeding is controlled.',
        'Apply an antibiotic ointment and cover with a sterile bandage.',
        'Seek medical help if bleeding is severe, doesn\'t stop, or if the wound is deep or dirty.'
      ]),
      _FirstAidItem('Burns (Minor)', 'View emergency steps', [
        'Cool the burn immediately with cool (not ice-cold) running water for 10-20 minutes or until pain subsides.',
        'Gently clean the burn area with mild soap and water.',
        'Cover the burn with a sterile non-stick bandage or clean cloth.',
        'Do not apply ice, butter, or ointments to severe burns.',
        'Do not break blisters.',
        'Seek medical help for burns larger than 3 inches, burns on the face, hands, feet, genitals, or major joints, or any third-degree burns.'
      ]),
      _FirstAidItem('Choking (Adult/Child)', 'View emergency steps', [
        'Ask "Are you choking? Can you speak or cough?".',
        'If the person can cough forcefully, encourage them to continue coughing.',
        'If the person cannot speak, cough, or breathe, or is making high-pitched noises: Perform abdominal thrusts (Heimlich maneuver).',
        'For a conscious adult or child: Stand behind the person. Place one fist just above their navel. Grasp your fist with your other hand. Perform quick, upward and inward thrusts.',
        'Continue until the object is expelled or the person becomes unconscious.',
        'If the person becomes unconscious, carefully lower them to the floor and start CPR, beginning with chest compressions. Check for an object in the mouth before giving rescue breaths.',
        'Call emergency services immediately if you are alone or after starting maneuvers if someone else can call.'
      ]),
      _FirstAidItem('Suspected Heart Attack', 'View emergency steps', [
        'Call emergency services (e.g., 911, 112) immediately. Do not delay.',
        'Help the person sit down, rest, and try to keep calm.',
        'Loosen any tight clothing.',
        'If the person takes nitroglycerin, help them take their prescribed dose.',
        'If the person is not allergic to aspirin, has no history of bleeding problems, and is not taking blood thinners, you may offer them one regular-strength (325 mg) or two low-dose (81 mg) aspirin to chew, if local protocols allow and they are able to swallow.',
        'Be prepared to start CPR if the person becomes unconscious and stops breathing.'
      ]),
      _FirstAidItem('Suspected Fracture or Sprain', 'View emergency steps', [
        'Immobilize the injured area. Do not try to realign the bone or push a bone back in.',
        'If there is bleeding, apply pressure with a clean cloth.',
        'Apply a cold pack or ice wrapped in a cloth to the injured area for up to 20 minutes at a time to reduce swelling and pain. Do not apply ice directly to the skin.',
        'Elevate the injured limb if possible to reduce swelling.',
        'Do not move the person if a head, neck, or back injury is suspected, unless they are in immediate danger.',
        'Seek medical help immediately for fractures or if a sprain is severe.'
      ]),
      _FirstAidItem('Nosebleed', 'View emergency steps', [
        'Sit upright and lean forward slightly. Leaning back can cause blood to flow down the throat.',
        'Pinch all the soft parts of the nose (just below the bony bridge) together between your thumb and index finger.',
        'Hold the pinch continuously for 10-15 minutes. Breathe through your mouth.',
        'If bleeding continues after 15-20 minutes of continuous pressure, or if the nosebleed follows an injury, seek medical attention.'
      ]),
      _FirstAidItem('Insect Bites and Stings', 'View emergency steps', [
        'If the stinger is visible, remove it by scraping it off horizontally with a fingernail or a credit card. Do not use tweezers as this may squeeze more venom.',
        'Wash the area with soap and water.',
        'Apply a cold pack or cloth filled with ice to reduce swelling and pain.',
        'Apply calamine lotion or a hydrocortisone cream to relieve itching.',
        'Watch for signs of an allergic reaction (anaphylaxis), such as difficulty breathing, swelling of the face or throat, dizziness, or a rapid heartbeat. If these occur, call emergency services immediately and use an epinephrine auto-injector if available.'
      ]),
      _FirstAidItem('Heat Exhaustion', 'View emergency steps', [
        'Move the person to a cooler place, preferably air-conditioned.',
        'Loosen or remove tight clothing.',
        'Have the person sip cool water or a sports drink. Avoid caffeine or alcohol.',
        'Apply cool, wet cloths to the skin or give a cool bath.',
        'If symptoms worsen or do not improve within an hour, or if the person shows signs of heatstroke (e.g., confusion, high body temperature, unconsciousness), seek immediate medical attention.'
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
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
             
              Navigator.pop(context);

             
            },
          ),
        ],
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
