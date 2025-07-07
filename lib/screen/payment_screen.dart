import 'package:flutter/material.dart';
import 'package:flutter_app_food/screen/address_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/address_service.dart'; // Import AddressService
import '../models/address_model.dart'; // Import Address model
import 'receipt_screen.dart'; // Import ReceiptScreen for navigation after payment

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  String _paymentStatus = '';

  void _processPayment(BuildContext context) async {
    final addressService = Provider.of<AddressService>(context, listen: false);
    final selectedAddress = addressService.selectedAddress;

    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address before proceeding.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
        final cart = Provider.of<CartProvider>(context, listen: false);

        // Add the current cart items as a receipt BEFORE clearing the cart
        // UPDATED: Pass selectedAddress to addReceipt
        cart.addReceipt(widget.totalAmount, cart.items, selectedAddress);

        // Clear the cart on successful payment
        cart.clearCart();
      } else {
        _paymentStatus = 'Payment failed. Please try again.';
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_paymentStatus),
          backgroundColor: paymentSuccessful ? Colors.green : Colors.red,
        ),
      );
    }

    if (paymentSuccessful) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        // Navigate to ReceiptScreen after successful payment
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const ReceiptScreen()),
          (Route<dynamic> route) => false, // Clear all previous routes
        );
      }
    }
  }

  void _showAddressSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Consumer<AddressService>(
          builder: (context, addressService, child) {
            if (addressService.addresses.isEmpty) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      'No addresses found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please add an address in your profile.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Dismiss current sheet
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const AddressScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Address'),
                    ),
                  ],
                ),
              );
            }
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Delivery Address',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: addressService.addresses.length,
                      itemBuilder: (context, index) {
                        final address = addressService.addresses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: address.id == addressService.selectedAddress?.id ? 4 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: address.id == addressService.selectedAddress?.id
                                ? const BorderSide(color: Colors.green, width: 2)
                                : BorderSide.none,
                          ),
                          child: ListTile(
                            leading: Icon(
                              address.isDefault ? Icons.home : Icons.location_on,
                              color: address.isDefault ? Colors.green : Colors.grey,
                            ),
                            title: Text(address.streetAddress),
                            subtitle: Text('${address.city}, ${address.state} ${address.zipCode}'),
                            trailing: address.id == addressService.selectedAddress?.id
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : null,
                            onTap: () {
                              addressService.selectAddress(address);
                              Navigator.pop(context); // Dismiss sheet after selection
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Delivery address set to: ${address.streetAddress}')),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Dismiss current sheet
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const AddressScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Manage Addresses', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
            const SizedBox(height: 20),
            // Address Selection Section
            Consumer<AddressService>(
              builder: (context, addressService, child) {
                final selectedAddress = addressService.selectedAddress;
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery Address',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddressSelectionSheet(context),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Change'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedAddress != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedAddress.streetAddress,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${selectedAddress.city}, ${selectedAddress.state} ${selectedAddress.zipCode}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                selectedAddress.country,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              const Text(
                                'No address selected.',
                                style: TextStyle(fontSize: 16, color: Colors.red),
                              ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () => _showAddressSelectionSheet(context),
                                child: const Text('Select an Address'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
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
              onTap: _isLoading ? null : () => _processPayment(context), // Pass context
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.grey[100],
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.purple),
              title: const Text('Mobile Banking / Wallet'),
              subtitle: const Text('e.g., ABA, Wing, TrueMoney'),
              onTap: _isLoading ? null : () => _processPayment(context), // Pass context
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.grey[100],
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.orange),
              title: const Text('QR Code Payment'),
              subtitle: const Text('Scan to pay'),
              onTap: _isLoading ? null : () => _processPayment(context), // Pass context
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
                onPressed: _isLoading ? null : () => _processPayment(context), // Pass context
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
