class HealthProfileModel {
  // Step 1: Personal Information
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;

  // Step 2: Basic Information
  String? phoneNumber;
  String? age; // Kept as String to allow flexible input, parse to int later
  String? country;
  String? currentDisease;

  // Step 3: Allergies
  List<String> allergies;
  String? medicalHistoryForAlergies; // As per dropdown on PI3

  // Step 4: Physical Information
  String? heightCm;
  String? weightKg;
  String? gender;
  String? bloodType;

  // Step 5: Health Profile
  List<String> lifestyleChoices; // e.g., ["smoking", "alcohol"]
  String? exerciseFrequency;

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

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'phoneNumber': phoneNumber,
        'age': age,
        'country': country,
        'currentDisease': currentDisease,
        'allergies': allergies,
        'medicalHistoryForAlergies': medicalHistoryForAlergies,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'gender': gender,
        'bloodType': bloodType,
        'lifestyleChoices': lifestyleChoices,
        'exerciseFrequency': exerciseFrequency,
      };
}