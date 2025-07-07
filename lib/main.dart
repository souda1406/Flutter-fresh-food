import 'package:flutter/material.dart';
import 'package:flutter_app_food/screen/grocery_home_screen.dart';
import 'package:flutter_app_food/screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_food/providers/cart_provider.dart';

import 'package:flutter_app_food/services/auth_service.dart';
import 'package:flutter_app_food/services/address_service.dart'; // Import AddressService

void main() async {
  // Ensure that Flutter widgets are initialized before using plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AuthService and load any persisted user data
  final AuthService authService = AuthService();
  await authService.init();

  // Initialize AddressService here
  final AddressService addressService = AddressService();

  // Determine the initial screen based on whether a user is logged in
  Widget initialScreen;
  if (authService.currentUser != null) {
    initialScreen = GroceryHomeScreen();
  } else {
    initialScreen = LoginScreen();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => addressService), // <--- ADDED THIS LINE
      ],
      child: MyApp(initialScreen: initialScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresh Food App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: initialScreen, // Use the determined initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}
