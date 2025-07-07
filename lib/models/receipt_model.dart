import 'dart:convert'; // For jsonEncode/jsonDecode
import 'cart_item.dart'; // Import CartItem for storing purchased items
import 'address_model.dart'; // Import Address model

class Receipt {
  final String id;
  final DateTime purchaseDate;
  final double totalAmount;
  final List<CartItem> purchasedItems; // Store the actual CartItems at time of purchase
  final Address? deliveryAddress; // NEW: Store the delivery address

  Receipt({
    required this.id,
    required this.purchaseDate,
    required this.totalAmount,
    required this.purchasedItems,
    this.deliveryAddress, // Make it optional for backward compatibility if needed, but we'll always pass it.
  });

  // Convert a Receipt object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseDate': purchaseDate.toIso8601String(), // Convert DateTime to String
      'totalAmount': totalAmount,
      'purchasedItems': purchasedItems.map((item) => item.toJson()).toList(), // Serialize list of CartItems
      'deliveryAddress': deliveryAddress?.toJson(), // Serialize the delivery address if not null
    };
  }

  // Create a Receipt object from a Map (for JSON deserialization)
  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      purchaseDate: DateTime.parse(json['purchaseDate']), // Convert String back to DateTime
      totalAmount: json['totalAmount'],
      purchasedItems: (json['purchasedItems'] as List)
          .map((itemJson) => CartItem.fromJson(itemJson))
          .toList(), // Deserialize list of CartItems
      deliveryAddress: json['deliveryAddress'] != null
          ? Address.fromJson(json['deliveryAddress'])
          : null, // Deserialize delivery address if present
    );
  }
}