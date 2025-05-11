// File: lib/view_models/profile_view_model.dart

import 'package:flutter/material.dart';
import 'package:frontend/models/health_profile_model.dart';
import 'package:intl/intl.dart';
// Adjust the path to your user_model.dart if it's different
// Assuming it's in lib/models/user_model.dart
// import '../models/user_model.dart'; // Or 'package:user/models/user_model.dart'

class HealthProfileViewModel extends ChangeNotifier {
  HealthProfileModel _healthProfileModel = HealthProfileModel();

  HealthProfileModel get healthProfileModel => _healthProfileModel;

  // Data screen index (0 to 4 for PI1 to PI5)
  int _currentDataScreenIndex = 0;
  final int _totalDataScreens = 5;

  int get currentDataScreenIndex => _currentDataScreenIndex;
  int get totalDataScreens => _totalDataScreens;

  // Visual step index for the progress bar (0 to 3 for 4 visual steps)
  int get currentVisualStep {
    if (_currentDataScreenIndex == 0) return 0; // PI1 -> Visual Step 1
    if (_currentDataScreenIndex == 1) return 0; // PI2 -> Visual Step 1 (as per combined visual step)
    if (_currentDataScreenIndex == 2) return 1; // PI3 -> Visual Step 2
    if (_currentDataScreenIndex == 3) return 2; // PI4 -> Visual Step 3
    if (_currentDataScreenIndex == 4) return 3; // PI5 -> Visual Step 4
    return 0; // Default
  }
  final int totalVisualSteps = 4;


  // --- Update methods ---
  void updateFirstName(String value) {
    _healthProfileModel.firstName = value.trim();
    // notifyListeners(); // Usually notify after a group of changes or on field exit
  }

  void updateLastName(String value) {
    _healthProfileModel.lastName = value.trim();
  }

  void updateDateOfBirth(DateTime? dob) {
    _healthProfileModel.dateOfBirth = dob;
    notifyListeners(); // Notify immediately for UI update (e.g., displaying selected date)
  }

  void updatePhoneNumber(String value) {
    _healthProfileModel.phoneNumber = value.trim();
  }

  void updateAge(String value) {
    _healthProfileModel.age = value.trim();
  }

  void updateCountry(String? value) {
    _healthProfileModel.country = value;
    notifyListeners();
  }

  void updateCurrentDisease(String value) {
    _healthProfileModel.currentDisease = value.trim();
  }

  void addAllergy(String allergy) {
    final trimmedAllergy = allergy.trim();
    if (trimmedAllergy.isNotEmpty && !_healthProfileModel.allergies.contains(trimmedAllergy)) {
      _healthProfileModel.allergies = List.from(_healthProfileModel.allergies)..add(trimmedAllergy);
      notifyListeners();
    }
  }

  void removeAllergy(String allergy) {
    _healthProfileModel.allergies = List.from(_healthProfileModel.allergies)..remove(allergy);
    notifyListeners();
  }

  void updateMedicalHistoryForAlergies(String? value) {
    _healthProfileModel.medicalHistoryForAlergies = value;
    notifyListeners();
  }

  void updateHeight(String value) {
    _healthProfileModel.heightCm = value.trim();
  }

  void updateWeight(String value) {
    _healthProfileModel.weightKg = value.trim();
  }

  void updateGender(String? value) {
    if (_healthProfileModel.gender == value) {
      _healthProfileModel.gender = null;
    } else {
      _healthProfileModel.gender = value;
    }
    notifyListeners();
  }

  void updateBloodType(String? value) {
    _healthProfileModel.bloodType = value;
    notifyListeners();
  }

  void toggleLifestyleChoice(String choice) {
    final currentChoices = List<String>.from(_healthProfileModel.lifestyleChoices);
    if (currentChoices.contains(choice)) {
      currentChoices.remove(choice);
    } else {
      currentChoices.add(choice);
    }
    _healthProfileModel.lifestyleChoices = currentChoices;
    notifyListeners();
  }

  void updateExerciseFrequency(String? frequency) {
     if (_healthProfileModel.exerciseFrequency == frequency) {
      _healthProfileModel.exerciseFrequency = null;
    } else {
      _healthProfileModel.exerciseFrequency = frequency;
    }
    notifyListeners();
  }

  // --- Navigation ---
  void nextStep(BuildContext context, GlobalKey<FormState>? formKey) {
    if (formKey != null) {
      bool isValid = formKey.currentState!.validate();
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Please correct the errors above.'), backgroundColor: Colors.red),
        );
        return; // Don't proceed if validation fails
      }
      formKey.currentState!.save(); // IMPORTANT: Call save to trigger onSaved callbacks
    }

    if (_currentDataScreenIndex < _totalDataScreens - 1) {
      _currentDataScreenIndex++;
      notifyListeners();
    } else {
      completeProfile(context);
    }
  }

  // THIS IS THE METHOD THAT WAS LIKELY MISSING OR INCORRECT
  void previousStep() {
    print("Attempting previous step. Current index before: $_currentDataScreenIndex");
    if (_currentDataScreenIndex > 0) {
      _currentDataScreenIndex--;
      notifyListeners();
    } else {
      
    }
  }

  void completeProfile(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile created successfully!')),
    );
    resetProfileData(); // Reset after navigating and showing snackbar
  }

  // --- Helper ---
  String get formattedDateOfBirth {
    if (_healthProfileModel.dateOfBirth == null) return '';
    return DateFormat('MM/dd/yyyy').format(_healthProfileModel.dateOfBirth!);
  }

  void resetProfileData() {
    _healthProfileModel = HealthProfileModel();
    _currentDataScreenIndex = 0;
    notifyListeners(); // Notify to reset UI if needed, or if profile setup can be re-entered
  }

  void initiateProfileSetup() {
    _healthProfileModel = HealthProfileModel();
    _currentDataScreenIndex = 0;
    notifyListeners();
  }
}