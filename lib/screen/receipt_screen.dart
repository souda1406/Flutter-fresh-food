// screens/receipt_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart'; // Your CartProvider
import '../models/receipt_model.dart'; // Your Receipt model

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Orders',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.receipts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.receipt_long, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No past orders yet!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Complete a purchase to see your receipts here.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cartProvider.receipts.length,
            itemBuilder: (context, index) {
              final receipt = cartProvider.receipts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order ID: ${receipt.id.substring(0, 8)}...', // Display a truncated ID
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, receipt.id, cartProvider);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Purchase Date: ${DateFormat('dd MMM yyyy - hh:mm a').format(receipt.purchaseDate)}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Amount: ₭${receipt.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const Divider(height: 20, thickness: 1),
                      const Text(
                        'Items Purchased:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      // List the items within the receipt
                      ...receipt.purchasedItems.map((item) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  item.product.image,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${item.product.name} x${item.quantity} (₭${item.product.price.toStringAsFixed(0)} each)',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                Text('₭${item.totalPrice.toStringAsFixed(0)}'),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper method to show a confirmation dialog for deleting a receipt
  void _showDeleteConfirmationDialog(BuildContext context, String receiptId, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Receipt?'),
        content: const Text('Are you sure you want to remove this order receipt? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Dismiss dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.deleteReceipt(receiptId);
              Navigator.of(ctx).pop(); // Dismiss dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receipt deleted!'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}