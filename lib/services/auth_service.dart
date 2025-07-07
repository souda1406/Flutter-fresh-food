import 'package:shared_preferences/shared_preferences.dart'; // THIS LINE IS CRITICAL
import 'dart:convert'; // For jsonEncode/jsonDecode

import '../models/user.dart';

class AuthService {
  // Key for storing user data in shared_preferences
  static const String _userKey = 'loggedInUser';
  static const String _registeredUsersKey = 'registeredUsers';

  // In-memory list for current session (will be loaded from/saved to preferences)
  static List<User> _registeredUsers = [];

  // Current logged-in user (for demonstration)
  static User? _currentUser;

  User? get currentUser => _currentUser;

  // Initialize AuthService by loading data from local storage
  Future<void> init() async {
    // This is where SharedPreferences is used.
    // If the import above is missing, this line will cause the error.
    final prefs = await SharedPreferences.getInstance(); 
    final String? registeredUsersJson = prefs.getString(_registeredUsersKey);
    if (registeredUsersJson != null) {
      final List<dynamic> userMaps = jsonDecode(registeredUsersJson);
      _registeredUsers = userMaps.map((map) => User.fromJson(map)).toList();
    }

    // Attempt to load previously logged-in user
    final String? currentUserJson = prefs.getString(_userKey);
    if (currentUserJson != null) {
      _currentUser = User.fromJson(jsonDecode(currentUserJson));
    }
    AuthService.printRegisteredUsers(); // For debugging
  }

  /// Registers a new user.
  /// Returns true if registration is successful (email is not already taken), false otherwise.
  Future<bool> registerUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (_registeredUsers.any((user) => user.email == email)) {
      return false; // Email already registered
    }

    final newUser = User(email: email, password: password);
    _registeredUsers.add(newUser);
    await _saveRegisteredUsers(); // Save updated list to local storage
    print('User registered: $email');
    return true;
  }

  /// Authenticates a user.
  /// Returns true if credentials match a registered user, false otherwise.
  Future<bool> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final user = _registeredUsers.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => User(email: '', password: ''), // Return a dummy user if not found
    );

    if (user.email.isNotEmpty) {
      _currentUser = user;
      await _saveCurrentUser(); // Save logged-in user to local storage
      print('User logged in: $email');
      return true;
    } else {
      print('Login failed for: $email');
      return false;
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey); // Remove logged-in user from local storage
    print('User logged out.');
  }

  // Save the list of registered users to shared_preferences
  Future<void> _saveRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(_registeredUsers.map((user) => user.toJson()).toList());
    await prefs.setString(_registeredUsersKey, jsonString);
  }

  // Save the current logged-in user to shared_preferences
  Future<void> _saveCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
    } else {
      await prefs.remove(_userKey);
    }
  }

  // For debugging: print all registered users
  static void printRegisteredUsers() {
    print('--- Registered Users (In-Memory & Local Storage) ---');
    if (_registeredUsers.isEmpty) {
      print('No users registered yet.');
    } else {
      for (var user in _registeredUsers) {
        print(' - ${user.email}');
      }
    }
    print('-----------------------------------');
  }
}
