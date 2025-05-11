import 'package:flutter/material.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:provider/provider.dart';

class HealthProfileStepScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey; // May not be strictly needed for choice chips
  const HealthProfileStepScreen({super.key, required this.formKey});

  @override
  State<HealthProfileStepScreen> createState() => _HealthProfileStepScreenState();
}

class _HealthProfileStepScreenState extends State<HealthProfileStepScreen> {
  final List<String> _lifestyleOptions = ['smoking', 'alcohol'];
  final List<String> _exerciseFrequencies = ['Rarely', 'Sometimes', 'Regularly', 'Daily'];

  Widget _buildLifestyleChip(HealthProfileViewModel viewModel, String option) {
    bool isSelected = viewModel.healthProfileModel.lifestyleChoices.contains(option);
    return ChoiceChip(
      label: Text(option[0].toUpperCase() + option.substring(1)), // Capitalize
      selected: isSelected,
      onSelected: (selected) {
        viewModel.toggleLifestyleChoice(option);
      },
       labelStyle: TextStyle(
        color: isSelected ? Colors.white : Theme.of(context).chipTheme.labelStyle?.color,
        fontWeight: FontWeight.w500,
      ),
      selectedColor: Theme.of(context).chipTheme.selectedColor,
      backgroundColor: Theme.of(context).chipTheme.backgroundColor,
      shape: Theme.of(context).chipTheme.shape,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

   Widget _buildExerciseChip(HealthProfileViewModel viewModel, String frequency) {
    bool isSelected = viewModel.healthProfileModel.exerciseFrequency == frequency;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          label: Center(child: Text(frequency)),
          selected: isSelected,
          onSelected: (selected) {
            viewModel.updateExerciseFrequency(frequency);
          },
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).chipTheme.labelStyle?.color,
            fontWeight: FontWeight.w500,
          ),
          selectedColor: Theme.of(context).chipTheme.selectedColor,
          backgroundColor: Theme.of(context).chipTheme.backgroundColor,
          shape: Theme.of(context).chipTheme.shape,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthProfileViewModel>(context); // Listen for changes
    // final user = viewModel.healthProfileModel; // Already accessed via viewModel

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Health Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1C2A3A)),
          ),
          const SizedBox(height: 8),
          Text(
            "Almost done! Final health details",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 30),
          Text(
            'Lifestyle',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800),
          ),
          const SizedBox(height: 10),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start, // Default
            children: _lifestyleOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: _buildLifestyleChip(viewModel, option),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),
          Text(
            'Exercise Frequency',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800),
          ),
          const SizedBox(height: 10),
          // First row of exercise chips
          Row(
            children: [
              _buildExerciseChip(viewModel, _exerciseFrequencies[0]), // Rarely
              _buildExerciseChip(viewModel, _exerciseFrequencies[1]), // Sometimes
            ],
          ),
          const SizedBox(height: 10),
          // Second row of exercise chips
          Row(
            children: [
              _buildExerciseChip(viewModel, _exerciseFrequencies[2]), // Regularly
              _buildExerciseChip(viewModel, _exerciseFrequencies[3]), // Daily
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}