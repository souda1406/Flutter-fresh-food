import 'dart:convert'; // For jsonEncode/jsonDecode
import 'grocery_models.dart'; // Import GroceryProduct and its subclasses

class CartItem {
  final GroceryProduct product; // The actual grocery product (vegetable or fruit)
  int quantity; // The quantity of this product in the cart

  // Constructor for CartItem, defaults quantity to 1
  CartItem({required this.product, this.quantity = 1});

  // Method to increase the quantity of the item
  void incrementQuantity() {
    quantity++;
  }

  // Method to decrease the quantity of the item, ensuring it doesn't go below 1
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  // Getter to calculate the total price for this specific cart item (price * quantity)
  double get totalPrice => product.price * quantity;

  // Convert a CartItem object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(), // Serialize the nested product
      'quantity': quantity,
    };
  }

  // Create a CartItem object from a Map (for JSON deserialization)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Determine the correct product type based on the 'type' field in product JSON
    GroceryProduct product;
    final productJson = json['product'];
    switch (productJson['type']) {
      case 'VegetableItem':
        product = VegetableItem.fromJson(productJson);
        break;
      case 'FruitItem':
        product = FruitItem.fromJson(productJson);
        break;
      default:
        // Fallback or throw error if type is unknown
        product = GroceryProduct.fromJson(productJson);
        break;
    }

    return CartItem(
      product: product,
      quantity: json['quantity'],
    );
  }
}