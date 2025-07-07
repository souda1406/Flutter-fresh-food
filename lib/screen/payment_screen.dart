// screens/payment_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart'; // Make sure this path is correct

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  String _paymentStatus = '';

  void _processPayment() async {
    setState(() {
      _isLoading = true;
      _paymentStatus = 'Processing payment...';
    });

    // Simulate a network request for payment
    await Future.delayed(const Duration(seconds: 2));

    // Randomly decide if payment is successful for demo purposes
    final bool paymentSuccessful = DateTime.now().millisecond % 2 == 0;

    setState(() {
      _isLoading = false;
      if (paymentSuccessful) {
        _paymentStatus = 'Payment successful! 🎉';
        // Get a reference to the CartProvider
        final cart = Provider.of<CartProvider>(context, listen: false);

        // Add the current cart items as a receipt BEFORE clearing the cart
        cart.addReceipt(widget.totalAmount, cart.items); // Pass the current cart items

        // Clear the cart on successful payment
        cart.clearCart();
      } else {
        _paymentStatus = 'Payment failed. Please try again.';
      }
    });

    // Show a SnackBar with the payment status
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_paymentStatus),
          backgroundColor: paymentSuccessful ? Colors.green : Colors.red,
        ),
      );
    }

    // Optionally navigate back after a short delay
    if (paymentSuccessful) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        // Go back to the initial screen (e.g., home or product list)
        Navigator.of(context).popUntil((route) => route.isFirst); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '₭${widget.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select Payment Method (Demo)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blueAccent),
              title: const Text('Credit/Debit Card'),
              subtitle: const Text('Visa, Mastercard, etc.'),
              trailing: _isLoading
                  ? const CircularProgressIndicator()
                  : (_paymentStatus.contains('successful')
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : (_paymentStatus.contains('failed')
                          ? const Icon(Icons.cancel, color: Colors.red)
                          : null)),
              onTap: _isLoading ? null : _processPayment, // Disable tap during loading
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.grey[100],
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.purple),
              title: const Text('Mobile Banking / Wallet'),
              subtitle: const Text('e.g., ABA, Wing, TrueMoney'),
              onTap: _isLoading ? null : _processPayment,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.grey[100],
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.orange),
              title: const Text('QR Code Payment'),
              subtitle: const Text('Scan to pay'),
              onTap: _isLoading ? null : _processPayment,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.grey[100],
            ),
            const Spacer(),
            if (_paymentStatus.isNotEmpty && !_isLoading)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  _paymentStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _paymentStatus.contains('successful') ? Colors.green : Colors.red,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _processPayment,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.done_all, color: Colors.white),
                label: Text(
                  _isLoading ? 'Processing...' : 'Confirm Payment',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}