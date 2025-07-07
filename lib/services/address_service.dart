import 'package:flutter/foundation.dart'; // For @required and ChangeNotifier
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/address_model.dart';

class AddressService with ChangeNotifier {
  List<Address> _addresses = [];
  Address? _selectedAddress; // To keep track of the currently selected address

  List<Address> get addresses => _addresses;
  Address? get selectedAddress => _selectedAddress;

  AddressService() {
    _loadAddresses(); // Load addresses when the service is instantiated
  }

  static const String _addressesKey = 'userAddresses';
  static const String _selectedAddressIdKey = 'selectedAddressId';

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? addressesJson = prefs.getString(_addressesKey);
    if (addressesJson != null) {
      try {
        final List<dynamic> addressMaps = jsonDecode(addressesJson);
        _addresses = addressMaps.map((map) => Address.fromJson(map)).toList();
      } catch (e) {
        print('Error loading addresses from local storage: $e');
        _addresses = []; // Reset if loading fails
      }
    }

    // Load selected address ID and set selected address
    final String? selectedAddressId = prefs.getString(_selectedAddressIdKey);
    if (selectedAddressId != null) {
      _selectedAddress = _addresses.firstWhereOrNull((addr) => addr.id == selectedAddressId);
    }
    // If no selected address, try to set the first one as default
    if (_selectedAddress == null && _addresses.isNotEmpty) {
      _selectedAddress = _addresses.first;
    }
    notifyListeners();
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(_addresses.map((addr) => addr.toJson()).toList());
    await prefs.setString(_addressesKey, jsonString);

    // Save the ID of the selected address
    await prefs.setString(_selectedAddressIdKey, _selectedAddress?.id ?? '');
  }

  void addAddress(Address newAddress) {
    // If this is the first address or it's explicitly marked as default, set it as default
    if (_addresses.isEmpty || newAddress.isDefault) {
      _addresses.forEach((addr) => addr.isDefault = false); // Clear existing defaults
      newAddress.isDefault = true;
      _selectedAddress = newAddress;
    }
    _addresses.add(newAddress);
    notifyListeners();
    _saveAddresses();
  }

  void updateAddress(Address updatedAddress) {
    final index = _addresses.indexWhere((addr) => addr.id == updatedAddress.id);
    if (index != -1) {
      _addresses[index] = updatedAddress;
      // If the updated address is now default, clear others
      if (updatedAddress.isDefault) {
        _addresses.forEach((addr) {
          if (addr.id != updatedAddress.id) {
            addr.isDefault = false;
          }
        });
        _selectedAddress = updatedAddress;
      } else if (_selectedAddress?.id == updatedAddress.id && !updatedAddress.isDefault) {
        // If the previously selected address is no longer default, and no new default is set,
        // clear selected address or pick a new one.
        _selectedAddress = _addresses.firstWhereOrNull((addr) => addr.isDefault) ?? (_addresses.isNotEmpty ? _addresses.first : null);
      }
      notifyListeners();
      _saveAddresses();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((addr) => addr.id == id);
    // If the deleted address was the selected one, clear selected or find a new default
    if (_selectedAddress?.id == id) {
      _selectedAddress = null;
      if (_addresses.isNotEmpty) {
        _addresses.first.isDefault = true; // Set first available as new default
        _selectedAddress = _addresses.first;
      }
    }
    notifyListeners();
    _saveAddresses();
  }

  void selectAddress(Address address) {
    // Clear previous default
    _addresses.forEach((addr) => addr.isDefault = false);
    // Set new default
    address.isDefault = true;
    _selectedAddress = address;
    notifyListeners();
    _saveAddresses();
  }
}

// Extension to easily find firstWhereOrNull, similar to Dart 2.12+
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}