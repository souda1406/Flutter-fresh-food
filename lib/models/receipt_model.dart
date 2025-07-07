

import 'cart_item.dart'; // Import CartItem for storing purchased items

class Receipt {
  final String id;
  final DateTime purchaseDate;
  final double totalAmount;
  final List<CartItem> purchasedItems; // Store the actual CartItems at time of purchase

  Receipt({
    required this.id,
    required this.purchaseDate,
    required this.totalAmount,
    required this.purchasedItems,
  });
}