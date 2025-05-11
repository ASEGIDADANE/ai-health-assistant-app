// import 'package:flutter/material.dart';

// class AIAnalysisResultDialog extends StatelessWidget {
//   final List<String> symptoms;

//   const AIAnalysisResultDialog({Key? key, required this.symptoms}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Example result, you can replace this with your AI logic
//     String result = "Based on your reported symptoms, you most likely have "
//         "Influenza (Flu). Please note this is an AI-generated assessment and should not be considered a medical diagnosis.";

//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: Row(
//         children: const [
//           Icon(Icons.bolt, color: Colors.green),
//           SizedBox(width: 8),
//           Text('AI Analysis Result'),
//         ],
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Wrap(
//             spacing: 8,
//             children: symptoms
//                 .where((s) => s.isNotEmpty)
//                 .map((s) => Chip(label: Text(s)))
//                 .toList(),
//           ),
//           const SizedBox(height: 16),
//           Text.rich(
//             TextSpan(
//               children: [
//                 TextSpan(text: result),
//               ],
//             ),
//             style: const TextStyle(fontSize: 15),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.red[50],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: const [
//                 Icon(Icons.warning_amber_outlined, color: Colors.red, size: 20),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'If symptoms are severe or worsen, please seek immediate medical attention.',
//                     style: TextStyle(color: Colors.red, fontSize: 13),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Got it'),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';

class AIAnalysisResultDialog extends StatelessWidget {
  final List<String> symptoms;
  final String analysisResult; // Added to receive the actual result

  const AIAnalysisResultDialog({
    Key? key,
    required this.symptoms,
    required this.analysisResult, // Make it required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.bolt, color: Colors.green), // Changed icon color
          SizedBox(width: 8),
          Text('AI Analysis Result', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView( // Added SingleChildScrollView for potentially long results
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Based on symptoms:", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4, // Added runSpacing
              children: symptoms
                  .where((s) => s.isNotEmpty)
                  .map((s) => Chip(
                        label: Text(s),
                        backgroundColor: Colors.blue[50],
                        labelStyle: TextStyle(color: Colors.blue[700]),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              analysisResult, // Use the passed analysisResult
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12), // Increased padding
              decoration: BoxDecoration(
                color: Colors.orange[50], // Changed color for better visibility
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200) // Added border
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
                children: [
                  Icon(Icons.warning_amber_outlined, color: Colors.orange.shade700, size: 24), // Adjusted color and size
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'This is an AI-generated assessment and not a medical diagnosis. If symptoms are severe or worsen, please seek immediate medical attention.',
                      style: TextStyle(color: Colors.red, fontSize: 13.5, fontWeight: FontWeight.w500), // Adjusted style
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue, // Adjusted button style
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Got it'),
          ),
        ),
      ],
    );
  }
}