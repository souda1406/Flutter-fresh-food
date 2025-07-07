import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/vegetable_slider_widget.dart';
import '../widgets/fruit_grid_widget.dart'; // Import FruitGridWidget
import '../models/grocery_models.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import 'blog_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../data/grocery_data.dart'; // NEW: Import grocery_data for dummy data

class GroceryHomeScreen extends StatefulWidget {
  @override
  _GroceryHomeScreenState createState() => _GroceryHomeScreenState();
}

class _GroceryHomeScreenState extends State<GroceryHomeScreen> {
  String searchQuery = '';
  int _selectedIndex = 0; // Tracks the current selected tab index

  final AuthService _authService = AuthService();

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(
              onSearch: (query) {
                setState(() {
                  searchQuery = query;
                });
                _handleSearch(query);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Fresh Vegetables'),
            const SizedBox(height: 16),
            VegetableSliderWidget(
              onBuy: _handleVegetableBuy,
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Fresh Fruits'),
            const SizedBox(height: 16),
            FruitGridWidget(
              fruits: dummyFruits, // Pass the dummyFruits list to the widget
              onBuy: _handleFruitBuy, // Changed from onFruitTap to onBuy
            ),
            const SizedBox(height: 10), // REDUCED from 20 to 10 to prevent overflow
          ],
        ),
      ),
      const BlogScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Grocery Home',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: const [],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  void _handleSearch(String query) {
    print('Search query: $query');
  }

  void _handleVegetableBuy(VegetableItem vegetable) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Text(vegetable.image, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vegetable.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                vegetable.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Price: ₭${vegetable.price.toStringAsFixed(0)} / kilo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text('${vegetable.rating}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).addItem(vegetable);
                Navigator.of(context).pop();
                _showSuccessSnackBar('${vegetable.name} added to cart!');
              },
              child: const Text('Add to Cart'),
            ),
          ],
        );
      },
    );
  }

  // NEW: _handleFruitBuy method to show "Add to Cart" dialog for fruits
  void _handleFruitBuy(FruitItem fruit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Text(fruit.image, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fruit.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                fruit.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Price: ₭${fruit.price.toStringAsFixed(0)} / kilo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text('${fruit.rating}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).addItem(fruit);
                Navigator.of(context).pop();
                _showSuccessSnackBar('${fruit.name} added to cart!');
              },
              child: const Text('Add to Cart'),
            ),
          ],
        );
      },
    );
  }

  void _handleFilterTap() {
    _showSuccessSnackBar('Filter options coming soon!');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
