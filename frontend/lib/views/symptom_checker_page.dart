// import 'package:flutter/material.dart';
// import 'package:frontend/views/ai_analysis_result.dart';

// class SymptomCheckerPage extends StatefulWidget {
//   const SymptomCheckerPage({Key? key}) : super(key: key);

//   @override
//   State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
// }

// class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
//   final TextEditingController _symptomController = TextEditingController();

//   void _analyzeSymptoms() {
//     final symptoms = _symptomController.text.trim();
//     if (symptoms.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your symptoms.')),
//       );
//       return;
//     }
//     showDialog(
//       context: context,
//       builder: (context) => AIAnalysisResultDialog(
//         symptoms: symptoms.split(',').map((s) => s.trim()).toList(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text('Symptom Checker'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
      
      
//       body: Padding(
//         padding: const EdgeInsets.only(left: 16,right: 16,top: 30,bottom: 16),
//         child: Column(
//           children: [
//             const ListTile(
//               leading: CircleAvatar(child: Text('S')),
//               title: Text('Symptom Checker', style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Text('Identify possible conditions based on your symptoms'),
//             ),
//             SizedBox(height:20),
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 16),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.red[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 "Note: This tool provides general guidance only and should not replace professional medical advice. If you're experiencing severe symptoms, seek immediate medical attention.",
//                 style: TextStyle(color: Colors.red, fontSize: 14),
//               ),
//             ),
//             SizedBox(height: 20,),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Select Your Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   TextField(
//                     maxLines: 3,
//                     controller: _symptomController,
//                     maxLength: null,
//                     decoration: const InputDecoration(
//                       hintText: 'Search symptoms...',
//                       border: OutlineInputBorder(),
//                       counterText: '',
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _analyzeSymptoms,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text('Analyze Symptoms'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             const Padding(
//               padding: EdgeInsets.only(bottom: 8),
//               child: Text(
//                 'Always consult with a healthcare professional for accurate medical diagnosis and treatment.',
//                 style: TextStyle(color: Colors.black54, fontSize: 13),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

import 'package:flutter/material.dart';
import 'package:frontend/view_models/symptom_view_model.dart'; // Import ViewModel
import 'package:frontend/views/ai_analysis_result.dart';
import 'package:provider/provider.dart'; // Import Provider

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({Key? key}) : super(key: key);

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }

  Future<void> _analyzeSymptoms() async { // Make it async
    final symptomsText = _symptomController.text.trim();
    if (symptomsText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your symptoms.')),
        );
      }
      return;
    }

    final viewModel = Provider.of<SymptomViewModel>(context, listen: false);
    await viewModel.analyzeSymptoms(symptomsText);

    if (mounted) { // Check if the widget is still in the tree
      if (viewModel.error == null && viewModel.result != null) {
        showDialog(
          context: context,
          builder: (context) => AIAnalysisResultDialog(
            symptoms: symptomsText.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
            analysisResult: viewModel.result!, // Pass the result from ViewModel
          ),
        );
      } else if (viewModel.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${viewModel.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel to listen for changes for UI elements like the button
    final symptomViewModel = Provider.of<SymptomViewModel>(context);

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
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16), // Reduced top padding
        child: SingleChildScrollView( // Added SingleChildScrollView
          child: Column(
            children: [
              const ListTile(
                leading: CircleAvatar(child: Text('S')),
                title: Text('Symptom Checker', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Identify possible conditions based on your symptoms'),
              ),
              const SizedBox(height: 10), // Reduced SizedBox
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10), // Reduced margin
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
              const SizedBox(height: 10), // Reduced SizedBox
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
                    const Text('Enter Your Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // Changed text
                    const SizedBox(height: 12),
                    TextField(
                      maxLines: 5, // Increased maxLines for more input space
                      controller: _symptomController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., fever, cough, headache...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12), // Adjusted padding
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: symptomViewModel.isLoading ? null : _analyzeSymptoms,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: symptomViewModel.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : const Text(
                                'Analyze Symptoms',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Added SizedBox for spacing before footer
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
      ),
    );
  }
}