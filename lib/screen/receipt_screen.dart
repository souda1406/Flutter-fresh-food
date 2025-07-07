import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart'; // Your CartProvider
import '../models/receipt_model.dart'; // Your Receipt model
import '../models/address_model.dart'; // NEW: Import Address model

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  // Helper method to show receipt details in a dialog
  void _showReceiptDetailsDialog(BuildContext context, Receipt receipt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${receipt.id}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                'Purchase Date: ${DateFormat('dd MMM yyyy - hh:mm a').format(receipt.purchaseDate)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delivery Address:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              if (receipt.deliveryAddress != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(receipt.deliveryAddress!.streetAddress),
                    Text('${receipt.deliveryAddress!.city}, ${receipt.deliveryAddress!.state} ${receipt.deliveryAddress!.zipCode}'),
                    Text(receipt.deliveryAddress!.country),
                  ],
                )
              else
                const Text('Address not available', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
              const Divider(height: 24, thickness: 1),
              const Text(
                'Items:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...receipt.purchasedItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Text(item.product.image, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${item.product.name} x${item.quantity}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Text('₭${item.totalPrice.toStringAsFixed(0)}'),
                      ],
                    ),
                  )),
              const Divider(height: 24, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₭${receipt.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Dismiss dialog
              _showDeleteConfirmationDialog(context, receipt.id, Provider.of<CartProvider>(context, listen: false));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Order', style: TextStyle(color: Colors.white)),
          ),
        ],
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
                child: InkWell( // Use InkWell for tap effect
                  onTap: () => _showReceiptDetailsDialog(context, receipt), // Open details dialog on tap
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
                        // Display delivery address summary on the card
                        if (receipt.deliveryAddress != null)
                          Text(
                            'Deliver to: ${receipt.deliveryAddress!.streetAddress}, ${receipt.deliveryAddress!.city}',
                            style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                          )
                        else
                          const Text(
                            'Delivery address not specified',
                            style: TextStyle(fontSize: 14, color: Colors.redAccent),
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
                        // List the items within the receipt (showing first few or summary)
                        ...receipt.purchasedItems.take(2).map((item) => Padding( // Show first 2 items
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
                                      '${item.product.name} x${item.quantity}',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Text('₭${item.totalPrice.toStringAsFixed(0)}'),
                                ],
                              ),
                            )),
                        if (receipt.purchasedItems.length > 2)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text(
                              '+ ${receipt.purchasedItems.length - 2} more items',
                              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
