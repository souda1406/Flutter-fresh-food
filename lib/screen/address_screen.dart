import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

import '../models/address_model.dart';
import '../services/address_service.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isDefault = false;

  Address? _editingAddress; // Holds the address being edited

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _showAddressForm({Address? address}) {
    setState(() {
      _editingAddress = address;
      if (address != null) {
        _streetController.text = address.streetAddress;
        _cityController.text = address.city;
        _stateController.text = address.state;
        _zipCodeController.text = address.zipCode;
        _countryController.text = address.country;
        _isDefault = address.isDefault;
      } else {
        _streetController.clear();
        _cityController.clear();
        _stateController.clear();
        _zipCodeController.clear();
        _countryController.clear();
        _isDefault = false;
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _editingAddress == null ? 'Add New Address' : 'Edit Address',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter street address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(
                          labelText: 'State/Province',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.map),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter state';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _zipCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Zip Code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_post_office),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter zip code';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.public),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Consumer<AddressService>(
                  builder: (context, addressService, child) {
                    // Only show "Set as Default" if there's more than one address
                    // or if it's a new address being added.
                    bool canSetDefault = addressService.addresses.isNotEmpty || _editingAddress == null;
                    if (_editingAddress != null && _editingAddress!.isDefault) {
                      canSetDefault = false; // Cannot unset default from here if it's already default
                    }

                    return CheckboxListTile(
                      title: const Text('Set as Default Address'),
                      value: _isDefault,
                      onChanged: canSetDefault
                          ? (bool? value) {
                              setState(() {
                                _isDefault = value ?? false;
                              });
                            }
                          : null, // Disable if it's already the default
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_editingAddress == null ? 'Add Address' : 'Save Changes'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final addressService = Provider.of<AddressService>(context, listen: false);
      final newAddress = Address(
        id: _editingAddress?.id ?? const Uuid().v4(), // Use existing ID or generate new
        streetAddress: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        zipCode: _zipCodeController.text,
        country: _countryController.text,
        isDefault: _isDefault,
      );

      if (_editingAddress == null) {
        addressService.addAddress(newAddress);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added successfully!'), backgroundColor: Colors.green),
        );
      } else {
        addressService.updateAddress(newAddress);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address updated successfully!'), backgroundColor: Colors.green),
        );
      }
      Navigator.pop(context); // Dismiss the bottom sheet
    }
  }

  void _confirmDeleteAddress(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AddressService>(context, listen: false).deleteAddress(id);
              Navigator.pop(context); // Dismiss dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address deleted!'), backgroundColor: Colors.red),
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
          'My Addresses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AddressService>(
        builder: (context, addressService, child) {
          if (addressService.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No addresses saved yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first delivery address.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _showAddressForm(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add New Address', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addressService.addresses.length,
            itemBuilder: (context, index) {
              final address = addressService.addresses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: address.isDefault ? const BorderSide(color: Colors.green, width: 2) : BorderSide.none,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(
                    address.isDefault ? Icons.home : Icons.location_on,
                    color: address.isDefault ? Colors.green : Colors.grey,
                    size: 30,
                  ),
                  title: Text(
                    address.streetAddress,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '${address.city}, ${address.state} ${address.zipCode}\n${address.country}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showAddressForm(address: address);
                      } else if (value == 'delete') {
                        _confirmDeleteAddress(address.id);
                      } else if (value == 'set_default') {
                        addressService.selectAddress(address);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"${address.streetAddress}" set as default!'), backgroundColor: Colors.green),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      if (!address.isDefault) // Only show "Set as Default" if it's not already default
                        const PopupMenuItem<String>(
                          value: 'set_default',
                          child: Text('Set as Default'),
                        ),
                    ],
                  ),
                  onTap: () {
                    // When an address is tapped, set it as the selected address (which also makes it default)
                    addressService.selectAddress(address);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('"${address.streetAddress}" selected for delivery!'), backgroundColor: Colors.blue),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<AddressService>(
        builder: (context, addressService, child) {
          // Only show FAB if there are existing addresses, otherwise the empty state has a button
          if (addressService.addresses.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () => _showAddressForm(),
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
          return const SizedBox.shrink(); // Hide FAB if list is empty
        },
      ),
    );
  }
}