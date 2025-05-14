import 'package:flutter/material.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:provider/provider.dart';
import '../../profile_widgets/custom_form_field.dart';

class PhysicalInfoStepScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const PhysicalInfoStepScreen({super.key, required this.formKey});

  @override
  State<PhysicalInfoStepScreen> createState() => _PhysicalInfoStepScreenState();
}

class _PhysicalInfoStepScreenState extends State<PhysicalInfoStepScreen> {
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown'];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  Widget _buildChoiceChip(
      HealthProfileViewModel viewModel, String label, String currentValue, Function(String) onSelected) {
    bool isSelected = currentValue == label;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          label: Center(child: Text(label)),
          selected: isSelected,
          onSelected: (selected) {
             onSelected(label); // ViewModel handles deselection logic
          },
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).chipTheme.labelStyle?.color,
            fontWeight: FontWeight.w500,
          ),
          selectedColor: Theme.of(context).chipTheme.selectedColor,
          backgroundColor: Theme.of(context).chipTheme.backgroundColor,
          shape: Theme.of(context).chipTheme.shape,
          padding: const EdgeInsets.symmetric(vertical: 12), // Ensure good height
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthProfileViewModel>(context); // Listen for gender/blood type
    final user = viewModel.healthProfileModel;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Physical Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1C2A3A)),
          ),
          const SizedBox(height: 8),
          Text(
            "Your physical measurements help us personalize",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  labelText: 'Height (cm)',
                  hintText: '175',
                  initialValue: user.heightCm,
                  onChanged: viewModel.updateHeight,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    if (double.tryParse(value.trim()) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  labelText: 'Weight (kg)',
                  hintText: '70',
                  initialValue: user.weightKg,
                  onChanged: viewModel.updateWeight,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                     if (value == null || value.trim().isEmpty) return 'Required';
                    if (double.tryParse(value.trim()) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Gender',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _genders.map((gender) {
              return _buildChoiceChip(viewModel, gender, user.gender ?? '', viewModel.updateGender);
            }).toList(),
          ),
          const SizedBox(height: 20),
           CustomDropdownFormField(
            labelText: 'Blood Type',
            hintText: 'Select blood type',
            value: user.bloodType,
            items: _bloodTypes,
            onChanged: viewModel.updateBloodType,
            // validator: (value) => value == null ? 'Required' : null, // If mandatory
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}