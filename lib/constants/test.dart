import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/grocery_models.dart'; // Needed to reference GroceryProduct

class CartProvider extends ChangeNotifier {
  // Private list to store all items currently in the cart
  final List<CartItem> _items = [];

  // Public getter to access the cart items (read-only)
  List<CartItem> get items => _items;

  // Method to add a product to the cart.
  // If the product already exists, its quantity is incremented.
  // Otherwise, a new CartItem is added.
  void addItem(GroceryProduct product) {
    // Check if an item with the same name already exists in the cart
    int existingIndex = _items.indexWhere((item) => item.product.name == product.name);

    if (existingIndex != -1) {
      // If found, increment its quantity
      _items[existingIndex].incrementQuantity();
    } else {
      // If not found, add a new CartItem with quantity 1
      _items.add(CartItem(product: product));
    }
    notifyListeners(); // Notify listeners (UI) about the change
  }

  // Method to remove a specific CartItem entirely from the cart.
  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners(); // Notify listeners (UI) about the change
  }

  // Method to increment the quantity of an existing CartItem.
  void incrementQuantity(CartItem cartItem) {
    cartItem.incrementQuantity();
    notifyListeners(); // Notify listeners (UI) about the change
  }

  // Method to decrement the quantity of an existing CartItem.
  // If quantity drops to 0 or less, the item is removed from the cart.
  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.decrementQuantity();
    } else {
      // If quantity is 1 and decremented, remove the item from the list
      _items.remove(cartItem);
    }
    notifyListeners(); // Notify listeners (UI) about the change
  }

  // Getter to calculate the total price of all items in the cart.
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Getter to calculate the total number of individual items (sum of quantities).
  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Method to clear all items from the cart.
  void clearCart() {
    _items.clear();
    notifyListeners(); // Notify listeners (UI) about the change
  }
}