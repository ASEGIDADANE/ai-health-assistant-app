import 'package:flutter/material.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:provider/provider.dart';
import '../../profile_widgets/custom_form_field.dart';

class AllergiesStepScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey; // May not be strictly needed if fields are dynamic
  const AllergiesStepScreen({super.key, required this.formKey});

  @override
  State<AllergiesStepScreen> createState() => _AllergiesStepScreenState();
}

class _AllergiesStepScreenState extends State<AllergiesStepScreen> {
  final TextEditingController _allergyController = TextEditingController();
  final List<String> _medicalHistoryOptions = ['None', 'Asthma', 'Eczema', 'Hay Fever (Rhinitis)', 'Food Allergy History'];

  @override
  void dispose() {
    _allergyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthProfileViewModel>(context); // Listen for allergy list changes
    final user = viewModel.healthProfileModel;

    return Form(
      key: widget.formKey, // Useful if you add validated fields later
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Allergies',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1C2A3A)),
          ),
          const SizedBox(height: 8),
          Text(
            "Tell us about any allergies you have",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          // "Common Allergies" - could be Chips, but UI shows "+ Add Other Allergy" directly
          // For simplicity, focusing on the "Your Allergies" part.

          Text(
            'Your Allergies',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  labelText: '', // Label is above
                  hintText: 'e.g., Peanuts, Pollen',
                  controller: _allergyController,
                  // No validator here, add button handles logic
                ),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                label: const Text('Add', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  if (_allergyController.text.isNotEmpty) {
                    viewModel.addAllergy(_allergyController.text);
                    _allergyController.clear();
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600)
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          if (user.allergies.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: user.allergies.map((allergy) {
                return Chip(
                  label: Text(allergy),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w500),
                  deleteIcon: Icon(Icons.close, size: 16, color: Colors.blue.shade700),
                  onDeleted: () {
                    viewModel.removeAllergy(allergy);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                );
              }).toList(),
            ),
          const SizedBox(height: 25),
          CustomDropdownFormField(
            labelText: 'Medical History Related to Allergies', // Adjusted label for clarity
            hintText: 'Select relevant history', // Default is "Medical History" in UI
            value: user.medicalHistoryForAlergies,
            items: _medicalHistoryOptions,
            onChanged: viewModel.updateMedicalHistoryForAlergies,
            // validator: (value) => value == null ? 'Please select an option' : null, // If required
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}