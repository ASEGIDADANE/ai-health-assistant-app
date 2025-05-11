import 'package:flutter/material.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:provider/provider.dart';
import '../../profile_widgets/custom_form_field.dart';

class BasicInfoStepScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const BasicInfoStepScreen({super.key, required this.formKey});

  @override
  State<BasicInfoStepScreen> createState() => _BasicInfoStepScreenState();
}

class _BasicInfoStepScreenState extends State<BasicInfoStepScreen> {
  final List<String> _countries = ['USA', 'Canada', 'UK', 'Australia', 'India', 'Germany', 'France', 'Other']; // Example

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthProfileViewModel>(context, listen: false);
    final user = viewModel.healthProfileModel;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Basic Information', // Or "Basic Information / personal info"
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1C2A3A)),
          ),
          const SizedBox(height: 8),
          Text(
            "Let's start with your contact details",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 30),
          CustomFormField(
            labelText: 'Phone Number',
            hintText: '+1 234 567 8900',
            initialValue: user.phoneNumber,
            onChanged: viewModel.updatePhoneNumber,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Phone number is required';
              // Add more specific phone validation if needed
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomFormField(
            labelText: 'Age',
            hintText: '25',
            initialValue: user.age,
            onChanged: viewModel.updateAge,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Age is required';
              if (int.tryParse(value.trim()) == null) return 'Enter a valid age';
              if (int.parse(value.trim()) <= 0) return 'Enter a valid age';
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Consumer for Dropdown to rebuild only this part on change
          Consumer<HealthProfileViewModel>(
            builder: (context, vm, child) {
              return CustomDropdownFormField(
                labelText: 'Country',
                hintText: 'Select country',
                value: vm.healthProfileModel.country, // Use value from vm to ensure it updates
                items: _countries,
                onChanged: vm.updateCountry,
                validator: (value) => value == null ? 'Country is required' : null,
              );
            }
          ),
          const SizedBox(height: 20),
          CustomFormField(
            labelText: 'Current Disease (if any)',
            hintText: 'None', // Default/placeholder text
            initialValue: user.currentDisease ?? 'None',
            onChanged: viewModel.updateCurrentDisease,
            // No validator needed if optional, or add one if it should not be empty if not "None"
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}