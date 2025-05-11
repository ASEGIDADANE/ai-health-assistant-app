import 'package:flutter/material.dart';
import 'package:frontend/views/ai_analysis_result.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({Key? key}) : super(key: key);

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();

  void _analyzeSymptoms() {
    final symptoms = _symptomController.text.trim();
    if (symptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your symptoms.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AIAnalysisResultDialog(
        symptoms: symptoms.split(',').map((s) => s.trim()).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Symptom Checker'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      
      
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 30,bottom: 16),
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(child: Text('S')),
              title: Text('Symptom Checker', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Identify possible conditions based on your symptoms'),
            ),
            SizedBox(height:20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Note: This tool provides general guidance only and should not replace professional medical advice. If you're experiencing severe symptoms, seek immediate medical attention.",
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Your Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    controller: _symptomController,
                    maxLength: null,
                    decoration: const InputDecoration(
                      hintText: 'Search symptoms...',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _analyzeSymptoms,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Analyze Symptoms'),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Always consult with a healthcare professional for accurate medical diagnosis and treatment.',
                style: TextStyle(color: Colors.black54, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}