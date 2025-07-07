// providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/grocery_models.dart'; // Needed to reference GroceryProduct
import '../models/receipt_model.dart'; // Import the new Receipt model

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Receipt> _receipts = []; // List to store completed receipts

  List<CartItem> get items => _items;
  List<Receipt> get receipts => _receipts; // Getter for receipts

  void addItem(GroceryProduct product) {
    int existingIndex = _items.indexWhere((item) => item.product.name == product.name);

    if (existingIndex != -1) {
      _items[existingIndex].incrementQuantity();
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.incrementQuantity();
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.decrementQuantity();
    } else {
      _items.remove(cartItem);
    }
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // New method to add a receipt after a successful payment
  void addReceipt(double totalAmount, List<CartItem> purchasedItems) {
    final newReceipt = Receipt(
      id: DateTime.now().toIso8601String(), // Unique ID for the receipt
      purchaseDate: DateTime.now(),
      totalAmount: totalAmount,
      // Create a deep copy of the CartItem list and their quantities at the time of purchase
      purchasedItems: purchasedItems.map((item) => CartItem(product: item.product, quantity: item.quantity)).toList(),
    );
    _receipts.add(newReceipt);
    // Sort receipts by date, most recent first
    _receipts.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    notifyListeners();
  }

  // New method to delete a receipt
  void deleteReceipt(String receiptId) {
    _receipts.removeWhere((receipt) => receipt.id == receiptId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}