import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'dart:convert'; // For jsonEncode/jsonDecode

import '../models/cart_item.dart';
import '../models/grocery_models.dart'; // Ensure this is imported for product types
import '../models/receipt_model.dart';
import '../models/address_model.dart'; // NEW: Import Address model

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  List<Receipt> _receipts = [];

  List<CartItem> get items => _items;
  List<Receipt> get receipts => _receipts;

  CartProvider() {
    _loadCartData(); // Load cart and receipts when the provider is created
  }

  // --- Local Storage Keys ---
  static const String _cartKey = 'cartItems';
  static const String _receiptsKey = 'receipts';

  // --- Local Storage Methods ---
  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load cart items
    final String? cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      try {
        final List<dynamic> itemMaps = jsonDecode(cartJson);
        _items = itemMaps.map((map) => CartItem.fromJson(map)).toList();
      } catch (e) {
        print('Error loading cart items from local storage: $e');
        _items = []; // Reset cart if loading fails
      }
    }

    // Load receipts
    final String? receiptsJson = prefs.getString(_receiptsKey);
    if (receiptsJson != null) {
      try {
        final List<dynamic> receiptMaps = jsonDecode(receiptsJson);
        _receipts = receiptMaps.map((map) => Receipt.fromJson(map)).toList();
        // Ensure receipts are sorted after loading
        _receipts.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
      } catch (e) {
        print('Error loading receipts from local storage: $e');
        _receipts = []; // Reset receipts if loading fails
      }
    }
    notifyListeners(); // Notify listeners after data is loaded
  }

  Future<void> _saveCartData() async {
    final prefs = await SharedPreferences.getInstance();
    // Save cart items
    final String cartJson = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);

    // Save receipts
    final String receiptsJson = jsonEncode(_receipts.map((receipt) => receipt.toJson()).toList());
    await prefs.setString(_receiptsKey, receiptsJson);
  }

  // --- Cart Management Methods ---

  void addItem(GroceryProduct product) {
    int existingIndex = _items.indexWhere((item) => item.product.name == product.name);

    if (existingIndex != -1) {
      _items[existingIndex].incrementQuantity();
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
    _saveCartData(); // Save changes
  }

  void removeItem(CartItem item) {
    _items.removeWhere((cartItem) => cartItem.product.name == item.product.name);
    notifyListeners();
    _saveCartData(); // Save changes
  }

  void incrementQuantity(CartItem item) {
    item.incrementQuantity();
    notifyListeners();
    _saveCartData(); // Save changes
  }

  void decrementQuantity(CartItem item) {
    item.decrementQuantity();
    if (item.quantity == 0) {
      removeItem(item); // Remove if quantity drops to 0
    } else {
      notifyListeners();
      _saveCartData(); // Save changes
    }
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void clearCart() {
    _items = [];
    notifyListeners();
    _saveCartData(); // Save changes
  }

  // --- Receipt Management Methods ---

  // UPDATED: Now accepts deliveryAddress
  void addReceipt(double totalAmount, List<CartItem> purchasedItems, Address? deliveryAddress) {
    final newReceipt = Receipt(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Use millisecondsSinceEpoch for unique ID
      purchaseDate: DateTime.now(),
      totalAmount: totalAmount,
      // Create a deep copy of the CartItem list and their quantities at the time of purchase
      purchasedItems: purchasedItems.map((item) => CartItem(product: item.product, quantity: item.quantity)).toList(),
      deliveryAddress: deliveryAddress, // NEW: Store the delivery address
    );
    _receipts.insert(0, newReceipt); // Add new receipt to the beginning
    // Sort receipts by date, most recent first
    _receipts.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    notifyListeners();
    _saveCartData(); // Save changes
  }

  void deleteReceipt(String receiptId) {
    _receipts.removeWhere((receipt) => receipt.id == receiptId);
    notifyListeners();
    _saveCartData(); // Save changes
  }
}
