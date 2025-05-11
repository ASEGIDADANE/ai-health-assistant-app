import 'dart:convert';

class symptomeModel {
  final String symptoms;

  symptomeModel({
    required this.symptoms,
  });

  factory symptomeModel.fromJson(Map<String, dynamic> json) => symptomeModel(
        symptoms: json["symptoms"],
      );

  Map<String, dynamic> toJson() => {
        "symptoms": symptoms,
      };

  // String toJsonString() => json.encode(toJson());
}