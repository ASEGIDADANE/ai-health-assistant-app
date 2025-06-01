
class HealthSnippet {
  final int id;
  final String text;

  HealthSnippet({required this.id, required this.text});

  factory HealthSnippet.fromJson(Map<String, dynamic> json) {
    return HealthSnippet(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}