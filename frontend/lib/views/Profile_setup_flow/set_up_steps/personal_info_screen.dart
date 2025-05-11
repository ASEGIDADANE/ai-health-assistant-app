import 'package:flutter/material.dart';
import 'package:frontend/view_models/healthProfile_viewModel.dart';
import 'package:provider/provider.dart';
import '../../profile_widgets/custom_form_field.dart';

class PersonalInfoStepScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const PersonalInfoStepScreen({super.key, required this.formKey});

  @override
  State<PersonalInfoStepScreen> createState() => _PersonalInfoStepScreenState();
}

class _PersonalInfoStepScreenState extends State<PersonalInfoStepScreen> {
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<HealthProfileViewModel>(context, listen: false);
    _dobController = TextEditingController(text: viewModel.formattedDateOfBirth);
  }

  // It's important to listen to the viewModel here if the date can be cleared
  // or changed by other means and the TextField needs to reflect that.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<HealthProfileViewModel>(context, listen: true);
    if (_dobController.text != viewModel.formattedDateOfBirth) {
      // Update the controller if the ViewModel's formatted date changes.
      // This ensures the text field updates if the date is cleared or changed
      // by navigating back and forth.
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted) { // Check if the widget is still in the tree
          _dobController.text = viewModel.formattedDateOfBirth;
         }
      });
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, HealthProfileViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.healthProfileModel.dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != viewModel.healthProfileModel.dateOfBirth) {
      viewModel.updateDateOfBirth(picked);
      // The didChangeDependencies or a direct listen will update the controller
    }
  }

  @override
  Widget build(BuildContext context) {
    // We generally don't need to listen:false here if didChangeDependencies handles updates.
    // However, for direct calls to viewModel methods, false is fine.
    final viewModel = Provider.of<HealthProfileViewModel>(context, listen: false);
    final user = viewModel.healthProfileModel;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1C2A3A)),
          ),
          const SizedBox(height: 8),
          Text(
            "Let's start with your basic information",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 30),
          CustomFormField(
            labelText: 'First Name',
            hintText: 'John',
            initialValue: user.firstName, // Controller will take precedence if provided
            onChanged: viewModel.updateFirstName,
            onSaved: (value) => viewModel.updateFirstName(value ?? ''), // Ensure onSaved updates too
            validator: (value) => value == null || value.trim().isEmpty ? 'First name is required' : null,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            labelText: 'Last Name',
            hintText: 'Doe',
            initialValue: user.lastName,
            onChanged: viewModel.updateLastName,
            onSaved: (value) => viewModel.updateLastName(value ?? ''),
            validator: (value) => value == null || value.trim().isEmpty ? 'Last name is required' : null,
          ),
          const SizedBox(height: 20),
          CustomFormField(
            labelText: 'Date of Birth',
            hintText: 'MM/DD/YYYY',
            readOnly: true,
            controller: _dobController,
            onTap: () => _selectDate(context, viewModel),
            suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500, size: 20),
            validator: (value) => viewModel.healthProfileModel.dateOfBirth == null ? 'Date of birth is required' : null,
          ),
          // REMOVED NAVIGATION BUTTONS FROM HERE
          // const SizedBox(height: 30), // Original spacing for buttons
          // Now the ProfileSetupContainerScreen handles the buttons
        ],
      ),
    );
  }
}