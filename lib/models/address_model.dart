import 'dart:convert';

class Address {
  final String id;
  String streetAddress;
  String city;
  String state;
  String zipCode;
  String country;
  bool isDefault;

  Address({
    required this.id,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  // Convert an Address object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  // Create an Address object from a Map (for JSON deserialization)
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      streetAddress: json['streetAddress'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      isDefault: json['isDefault'] ?? false, // Default to false if not present
    );
  }
}
