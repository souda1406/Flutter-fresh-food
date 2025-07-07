import 'package:flutter_app_food/models/grocery_models.dart';



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
    // Note: If quantity becomes 0, the item should be removed from the cart
    // This logic will be handled by the CartProvider when calling this.
  }

  // Getter to calculate the total price for this specific cart item (price * quantity)
  double get totalPrice => product.price * quantity;
}
