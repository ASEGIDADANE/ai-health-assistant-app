import 'package:flutter/material.dart';

class AIAnalysisResultDialog extends StatelessWidget {
  final List<String> symptoms;

  const AIAnalysisResultDialog({Key? key, required this.symptoms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example result, you can replace this with your AI logic
    String result = "Based on your reported symptoms, you most likely have "
        "Influenza (Flu). Please note this is an AI-generated assessment and should not be considered a medical diagnosis.";

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.bolt, color: Colors.green),
          SizedBox(width: 8),
          Text('AI Analysis Result'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: symptoms
                .where((s) => s.isNotEmpty)
                .map((s) => Chip(label: Text(s)))
                .toList(),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: result),
              ],
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.warning_amber_outlined, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'If symptoms are severe or worsen, please seek immediate medical attention.',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}

