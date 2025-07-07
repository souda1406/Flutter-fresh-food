import 'dart:convert'; // Import for jsonEncode/jsonDecode

class User {
  final String email;
  final String password; // In a real app, store a token, not raw password

  User({required this.email, required this.password});

  // Convert a User object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Create a User object from a Map (for JSON deserialization)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'User(email: $email, password: [hidden])';
  }
}