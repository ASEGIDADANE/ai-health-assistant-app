

import 'dart:convert'; // Not strictly needed for toJson map, but good practice if model grows.

class HealthProfileModel {
  // Step 1: Personal Information
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;

  // Step 2: Basic Information
  String? phoneNumber;
  String? age; // Kept as String to allow flexible input, parse to int in toJson
  String? country;
  String? currentDisease;

  // Step 3: Allergies
  List<String> allergies;
  String? medicalHistoryForAlergies; // As per dropdown on PI3, e.g., "Pollen", "Dust Mites"

  // Step 4: Physical Information
  String? heightCm; // e.g., "175"
  String? weightKg; // e.g., "70"
  String? gender;   // e.g., "Male", "Female", "Other"
  String? bloodType; // e.g., "A+", "O-", "Unknown"

  // Step 5: Health Profile
  List<String> lifestyleChoices; // e.g., ["smoking", "alcohol"]
  String? exerciseFrequency;    // e.g., "Rarely", "Sometimes", "Regularly", "Daily"

  HealthProfileModel({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.phoneNumber,
    this.age,
    this.country,
    this.currentDisease,
    this.allergies = const [],
    this.medicalHistoryForAlergies,
    this.heightCm,
    this.weightKg,
    this.gender,
    this.bloodType,
    this.lifestyleChoices = const [],
    this.exerciseFrequency,
  });

  Map<String, dynamic> toJson() {
    // Helper function to map exercise frequency to backend enum
    String? mapExerciseFrequency(String? frontendFrequency) {
      if (frontendFrequency == null) return null;
      switch (frontendFrequency.toLowerCase()) {
        case 'rarely':
          return 'rarely';
        case 'sometimes': // Assuming 'sometimes' maps to 'rarely' for the backend
          return 'rarely';
        case 'regularly':
          return 'regularly';
        case 'daily': // Assuming 'daily' maps to 'regularly' for the backend
          return 'regularly';
        case 'none': // If "None" is an option in UI
            return 'none';
        default:
          // Handle unmapped values: either return null, a default, or throw an error
          // For now, returning null if not explicitly mapped.
          // Consider logging this during development: print('Unmapped exercise frequency: $frontendFrequency');
          return null;
      }
    }

    // Construct the medicalHistory list for the backend
    // Backend expects: medicalHistory: [String] (Array of strings)
    List<String> medicalHistoryStringList = [];
    if (medicalHistoryForAlergies != null && medicalHistoryForAlergies!.toLowerCase() != 'none' && medicalHistoryForAlergies!.isNotEmpty) {
      medicalHistoryStringList.add(medicalHistoryForAlergies!);
    }
    for (String allergy in allergies) {
      if (allergy.isNotEmpty) { // Ensure no empty strings are added
          medicalHistoryStringList.add(allergy);
      }
    }
    // Remove duplicates
    if (medicalHistoryStringList.isNotEmpty) {
        medicalHistoryStringList = medicalHistoryStringList.toSet().toList();
    }


    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String().split('T')[0], // Send only YYYY-MM-DD
      'phoneNumber': phoneNumber,
      'age': age != null && age!.isNotEmpty ? int.tryParse(age!) : null,
      'country': country,
      'currentDisease': currentDisease, // Assuming this is a string for a primary current condition

      // Backend expects 'medicalHistory' as an array of strings
      'medicalHistory': medicalHistoryStringList.isEmpty ? null : medicalHistoryStringList, // Send List<String>

      'height': heightCm != null && heightCm!.isNotEmpty ? double.tryParse(heightCm!) : null,
      'weight': weightKg != null && weightKg!.isNotEmpty ? double.tryParse(weightKg!) : null,
      'gender': gender?.toLowerCase(), // Ensure lowercase as per backend enum

      'bloodType': bloodType, // Assuming backend accepts this as is

      'lifestyle': {
        'smoking': lifestyleChoices.any((choice) => choice.toLowerCase() == 'smoking'),
        'alcohol': lifestyleChoices.any((choice) => choice.toLowerCase() == 'alcohol'),
        'exerciseFrequency': mapExerciseFrequency(exerciseFrequency),
      },
      // The following fields are now part of the nested 'lifestyle' object or 'medicalHistory'
      // and should not be sent at the top level if the backend doesn't expect them there.
      // 'allergies': allergies, // Handled by 'medicalHistory'
      // 'medicalHistoryForAlergies': medicalHistoryForAlergies, // Handled by 'medicalHistory'
      // 'lifestyleChoices': lifestyleChoices, // Handled by 'lifestyle.smoking' and 'lifestyle.alcohol'
      // 'exerciseFrequency': exerciseFrequency, // Handled by 'lifestyle.exerciseFrequency'
    };
  }
}