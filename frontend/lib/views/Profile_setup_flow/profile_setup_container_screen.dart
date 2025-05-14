import 'package:flutter/material.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:frontend/views/Profile_setup_flow/set_up_steps/allergies_screen.dart';
import 'package:frontend/views/Profile_setup_flow/set_up_steps/basic_info_screen.dart';
import 'package:frontend/views/Profile_setup_flow/set_up_steps/health_profile_screen.dart';
import 'package:frontend/views/Profile_setup_flow/set_up_steps/personal_info_screen.dart';
import 'package:frontend/views/Profile_setup_flow/set_up_steps/physical_info_screen.dart';
import 'package:provider/provider.dart';

import '../profile_widgets/custom_progress_indicator.dart';

class ProfileSetupContainerScreen extends StatefulWidget {
  const ProfileSetupContainerScreen({super.key});

  @override
  State<ProfileSetupContainerScreen> createState() => _ProfileSetupContainerScreenState();
}

class _ProfileSetupContainerScreenState extends State<ProfileSetupContainerScreen> {
  // Each step has its own form key for validation
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Step 1 (PI1)
    GlobalKey<FormState>(), // Step 2 (PI2)
    GlobalKey<FormState>(), // Step 3 (PI3)
    GlobalKey<FormState>(), // Step 4 (PI4)
    GlobalKey<FormState>(), // Step 5 (PI5)
  ];

  // Memoized list of step widgets
  late List<Widget> _stepWidgets;

  @override
  void initState() {
    super.initState();
    _stepWidgets = [
      PersonalInfoStepScreen(formKey: _formKeys[0]),
      BasicInfoStepScreen(formKey: _formKeys[1]),
      AllergiesStepScreen(formKey: _formKeys[2]),
      PhysicalInfoStepScreen(formKey: _formKeys[3]),
      HealthProfileStepScreen(formKey: _formKeys[4]),
    ];
  }


  @override
  Widget build(BuildContext context) {
    // Using Consumer to rebuild when viewModel changes
    return Consumer<HealthProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              // As per your PI1 screenshot, it shows a back arrow, not a close icon.
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () {
                if (viewModel.currentDataScreenIndex == 0) {
                  // If on the first step of profile setup, pop back to previous route (e.g., HomeScreen)
                  Navigator.of(context).pop();
                } else {
                  // Otherwise, go to the previous step in the profile setup
                  viewModel.previousStep();
                }
              },
            ),
            toolbarHeight: 50,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomProgressIndicator(
                  currentStep: viewModel.currentVisualStep,
                  totalSteps: viewModel.totalVisualSteps,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: IndexedStack(
                    index: viewModel.currentDataScreenIndex,
                    children: _stepWidgets.map((stepWidget) {
                      // Wrap each step in a SingleChildScrollView WITH A KEY to preserve scroll state
                      // and ensure it's treated as a distinct item in the IndexedStack for state.
                      return SingleChildScrollView(
                        key: PageStorageKey(stepWidget.runtimeType.toString() + _stepWidgets.indexOf(stepWidget).toString()),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: stepWidget,
                      );
                    }).toList(),
                  ),
                ),
              ),
              _buildNavigationButtons(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context, HealthProfileViewModel viewModel) {
    bool isLastStep = viewModel.currentDataScreenIndex == viewModel.totalDataScreens - 1;
    // Ensure the correct form key is used for the current step
    GlobalKey<FormState>? currentFormKey = _formKeys[viewModel.currentDataScreenIndex];

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // "Back" button is always present as per your PI1 screenshot
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                if (viewModel.currentDataScreenIndex == 0) {
                  // If on the first step, pop back to previous route (e.g., HomeScreen)
                  Navigator.of(context).pop();
                } else {
                  // Otherwise, go to the previous step
                  viewModel.previousStep();
                }
              },
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 16), // SizedBox is always present
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Call nextStep from the viewModel, passing the context and current form key
                viewModel.nextStep(context, currentFormKey);
              },
              child: Text(isLastStep ? 'Complete' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}