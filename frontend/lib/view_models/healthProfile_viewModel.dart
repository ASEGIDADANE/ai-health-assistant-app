// // File: lib/view_models/profile_view_model.dart

// import 'package:flutter/material.dart';
// import 'package:frontend/models/health_profile_model.dart';
// import 'package:intl/intl.dart';
// // Adjust the path to your user_model.dart if it's different
// // Assuming it's in lib/models/user_model.dart
// // import '../models/user_model.dart'; // Or 'package:user/models/user_model.dart'

// class HealthProfileViewModel extends ChangeNotifier {
//   HealthProfileModel _healthProfileModel = HealthProfileModel();

//   HealthProfileModel get healthProfileModel => _healthProfileModel;

//   // Data screen index (0 to 4 for PI1 to PI5)
//   int _currentDataScreenIndex = 0;
//   final int _totalDataScreens = 5;

//   int get currentDataScreenIndex => _currentDataScreenIndex;
//   int get totalDataScreens => _totalDataScreens;

//   // Visual step index for the progress bar (0 to 3 for 4 visual steps)
//   int get currentVisualStep {
//     if (_currentDataScreenIndex == 0) return 0; // PI1 -> Visual Step 1
//     if (_currentDataScreenIndex == 1) return 0; // PI2 -> Visual Step 1 (as per combined visual step)
//     if (_currentDataScreenIndex == 2) return 1; // PI3 -> Visual Step 2
//     if (_currentDataScreenIndex == 3) return 2; // PI4 -> Visual Step 3
//     if (_currentDataScreenIndex == 4) return 3; // PI5 -> Visual Step 4
//     return 0; // Default
//   }
//   final int totalVisualSteps = 4;


//   // --- Update methods ---
//   void updateFirstName(String value) {
//     _healthProfileModel.firstName = value.trim();
//     // notifyListeners(); // Usually notify after a group of changes or on field exit
//   }

//   void updateLastName(String value) {
//     _healthProfileModel.lastName = value.trim();
//   }

//   void updateDateOfBirth(DateTime? dob) {
//     _healthProfileModel.dateOfBirth = dob;
//     notifyListeners(); // Notify immediately for UI update (e.g., displaying selected date)
//   }

//   void updatePhoneNumber(String value) {
//     _healthProfileModel.phoneNumber = value.trim();
//   }

//   void updateAge(String value) {
//     _healthProfileModel.age = value.trim();
//   }

//   void updateCountry(String? value) {
//     _healthProfileModel.country = value;
//     notifyListeners();
//   }

//   void updateCurrentDisease(String value) {
//     _healthProfileModel.currentDisease = value.trim();
//   }

//   void addAllergy(String allergy) {
//     final trimmedAllergy = allergy.trim();
//     if (trimmedAllergy.isNotEmpty && !_healthProfileModel.allergies.contains(trimmedAllergy)) {
//       _healthProfileModel.allergies = List.from(_healthProfileModel.allergies)..add(trimmedAllergy);
//       notifyListeners();
//     }
//   }

//   void removeAllergy(String allergy) {
//     _healthProfileModel.allergies = List.from(_healthProfileModel.allergies)..remove(allergy);
//     notifyListeners();
//   }

//   void updateMedicalHistoryForAlergies(String? value) {
//     _healthProfileModel.medicalHistoryForAlergies = value;
//     notifyListeners();
//   }

//   void updateHeight(String value) {
//     _healthProfileModel.heightCm = value.trim();
//   }

//   void updateWeight(String value) {
//     _healthProfileModel.weightKg = value.trim();
//   }

//   void updateGender(String? value) {
//     if (_healthProfileModel.gender == value) {
//       _healthProfileModel.gender = null;
//     } else {
//       _healthProfileModel.gender = value;
//     }
//     notifyListeners();
//   }

//   void updateBloodType(String? value) {
//     _healthProfileModel.bloodType = value;
//     notifyListeners();
//   }

//   void toggleLifestyleChoice(String choice) {
//     final currentChoices = List<String>.from(_healthProfileModel.lifestyleChoices);
//     if (currentChoices.contains(choice)) {
//       currentChoices.remove(choice);
//     } else {
//       currentChoices.add(choice);
//     }
//     _healthProfileModel.lifestyleChoices = currentChoices;
//     notifyListeners();
//   }

//   void updateExerciseFrequency(String? frequency) {
//      if (_healthProfileModel.exerciseFrequency == frequency) {
//       _healthProfileModel.exerciseFrequency = null;
//     } else {
//       _healthProfileModel.exerciseFrequency = frequency;
//     }
//     notifyListeners();
//   }

//   // --- Navigation ---
//   void nextStep(BuildContext context, GlobalKey<FormState>? formKey) {
//     if (formKey != null) {
//       bool isValid = formKey.currentState!.validate();
//       if (!isValid) {
//         ScaffoldMessenger.of(context).showSnackBar(
//            const SnackBar(content: Text('Please correct the errors above.'), backgroundColor: Colors.red),
//         );
//         return; // Don't proceed if validation fails
//       }
//       formKey.currentState!.save(); // IMPORTANT: Call save to trigger onSaved callbacks
//     }

//     if (_currentDataScreenIndex < _totalDataScreens - 1) {
//       _currentDataScreenIndex++;
//       notifyListeners();
//     } else {
//       completeProfile(context);
//     }
//   }

//   // THIS IS THE METHOD THAT WAS LIKELY MISSING OR INCORRECT
//   void previousStep() {
//     print("Attempting previous step. Current index before: $_currentDataScreenIndex");
//     if (_currentDataScreenIndex > 0) {
//       _currentDataScreenIndex--;
//       notifyListeners();
//     } else {
      
//     }
//   }

//   void completeProfile(BuildContext context) {
//     Navigator.of(context).popUntil((route) => route.isFirst);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile created successfully!')),
//     );
//     resetProfileData(); // Reset after navigating and showing snackbar
//   }

//   // --- Helper ---
//   String get formattedDateOfBirth {
//     if (_healthProfileModel.dateOfBirth == null) return '';
//     return DateFormat('MM/dd/yyyy').format(_healthProfileModel.dateOfBirth!);
//   }

//   void resetProfileData() {
//     _healthProfileModel = HealthProfileModel();
//     _currentDataScreenIndex = 0;
//     notifyListeners(); // Notify to reset UI if needed, or if profile setup can be re-entered
//   }

//   void initiateProfileSetup() {
//     _healthProfileModel = HealthProfileModel();
//     _currentDataScreenIndex = 0;
//     notifyListeners();
//   }
// }



import 'package:flutter/material.dart';
import 'package:frontend/common/navigation/app_navigation.dart';
import 'package:frontend/models/health_profile_model.dart';
import 'package:frontend/services/healthProfileServices.dart'; // Import the service
import 'package:frontend/views/chat_with_ai_page.dart';
import 'package:frontend/views/homeScreen.dart';
import 'package:intl/intl.dart';

class HealthProfileViewModel extends ChangeNotifier {
  HealthProfileModel _healthProfileModel = HealthProfileModel();
  final HealthProfileService _profileService = HealthProfileService(); // Instantiate the service

  HealthProfileModel get healthProfileModel => _healthProfileModel;

  // Data screen index (0 to 4 for PI1 to PI5)
  int _currentDataScreenIndex = 0;
  final int _totalDataScreens = 5; // Assuming 5 distinct data collection screens

  int get currentDataScreenIndex => _currentDataScreenIndex;
  int get totalDataScreens => _totalDataScreens;

  // Visual step index for the progress bar (0 to 3 for 4 visual steps)
  int get currentVisualStep {
    // This logic might need adjustment based on your exact UI for progress steps
    if (_currentDataScreenIndex == 0) return 0; // Step 1: Personal Info
    if (_currentDataScreenIndex == 1) return 0; // Step 1: Basic Info (Visually part of step 1)
    if (_currentDataScreenIndex == 2) return 1; // Step 2: Allergies
    if (_currentDataScreenIndex == 3) return 2; // Step 3: Physical Info
    if (_currentDataScreenIndex == 4) return 3; // Step 4: Health Profile/Lifestyle
    return 0;
  }

  final int totalVisualSteps = 4; // Total number of visual steps in the progress bar

  bool _isSavingProfile = false; // To manage loading state for saving
  bool get isSavingProfile => _isSavingProfile;

  // --- Update methods for HealthProfileModel fields ---
  void updateFirstName(String value) {
    _healthProfileModel.firstName = value.trim();
    // notifyListeners(); // Consider if immediate notification is needed or batch with others
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
    if (trimmedAllergy.isNotEmpty &&
        !_healthProfileModel.allergies.contains(trimmedAllergy)) {
      _healthProfileModel.allergies = List.from(_healthProfileModel.allergies)
        ..add(trimmedAllergy);
      notifyListeners();
    }
  }

  void removeAllergy(String allergy) {
    _healthProfileModel.allergies = List.from(_healthProfileModel.allergies)
      ..remove(allergy);
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
      // If tapping the same selected gender, deselect it (optional behavior)
      // _healthProfileModel.gender = null;
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
    final currentChoices =
        List<String>.from(_healthProfileModel.lifestyleChoices);
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
      // If tapping the same selected frequency, deselect it (optional behavior)
      // _healthProfileModel.exerciseFrequency = null;
    } else {
      _healthProfileModel.exerciseFrequency = frequency;
    }
    notifyListeners();
  }

  // --- Navigation & Profile Completion ---
  void nextStep(BuildContext context, GlobalKey<FormState>? formKey) {
    if (formKey != null) {
      bool isValid = formKey.currentState!.validate();
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please correct the errors above.'),
              backgroundColor: Colors.red),
        );
        return; // Don't proceed if validation fails
      }
      formKey.currentState!.save(); // IMPORTANT: Call save to trigger onSaved callbacks
    }

    if (_currentDataScreenIndex < _totalDataScreens - 1) {
      _currentDataScreenIndex++;
      notifyListeners();
    } else {
      // Last step, attempt to complete and save the profile
      completeProfile(context);
    }
  }

  void previousStep() {
    if (_currentDataScreenIndex > 0) {
      _currentDataScreenIndex--;
      notifyListeners();
    }
    // Optionally, handle navigation if on the first step and back is pressed (e.g., pop the container screen)
  }

  Future<void> completeProfile(BuildContext context) async {
    _isSavingProfile = true;
    notifyListeners(); // Update UI to show loading indicator

    try {
      // Here we use the service to save the profile data
      await _profileService.saveOrUpdateHealthProfile(_healthProfileModel);

      // Navigate after successful save
      // Consider the appropriate navigation. PopUntil might be too aggressive if this screen
      // was pushed on top of a dashboard. Maybe just Navigator.pop(context);
      // Or navigate to a specific "Profile Saved" confirmation or back to a main profile view.
      if (Navigator.canPop(context)) { // Check if we can pop
         Navigator.of(context).pop(); // Pop the profile setup container
      }
      // If you want to go all the way back to the first screen of the app:
      // Navigator.of(context).popUntil((route) => route.isFirst);


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Profile created/updated successfully!'),
            backgroundColor: Colors.green),
      );
      AppNavigator.pushReplacement(context, const homeScreen());
      resetProfileData(); // Reset local model and state for next time
    } catch (e) {
      // Handle error from the service
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.red),
      );
    } finally {
      _isSavingProfile = false;
      notifyListeners(); // Update UI to hide loading indicator
    }
  }

  // --- Helper Methods ---
  String get formattedDateOfBirth {
    if (_healthProfileModel.dateOfBirth == null) return 'Select Date'; // Placeholder
    return DateFormat('MM/dd/yyyy').format(_healthProfileModel.dateOfBirth!);
  }

  void resetProfileData() {
    _healthProfileModel = HealthProfileModel();
    _currentDataScreenIndex = 0;
    // _isSavingProfile should already be false from the finally block, but good to be explicit if needed.
    notifyListeners(); // Notify to reset UI if needed, or if profile setup can be re-entered
  }

  // Call this if the user enters the profile setup flow again to ensure fresh state
  void initiateProfileSetup() {
    _healthProfileModel = HealthProfileModel();
    _currentDataScreenIndex = 0;
    _isSavingProfile = false;
    notifyListeners();
  }
}