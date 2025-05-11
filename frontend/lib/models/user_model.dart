class User {
  final String id;
  final String email;
  final String userType;
  final bool profileCompleted;

  User({
    required this.id,
    required this.email,
    required this.userType,
    required this.profileCompleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      userType: json['userType'],
      profileCompleted: json['profileCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userType': userType,
      'profileCompleted': profileCompleted,
    };
  }
}
