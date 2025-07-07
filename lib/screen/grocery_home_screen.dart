// lib/screens/grocery_home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/vegetable_slider_widget.dart';
import '../widgets/fruit_grid_widget.dart';
import '../models/grocery_models.dart';
import '../widgets/bottom_nav_bar_widget.dart'; // Import your new bottom nav bar
import 'blog_screen.dart'; // Import the new blog screen
import 'cart_screen.dart'; // Import the new cart screen
import 'profile_screen.dart'; // Import the new profile screen
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class GroceryHomeScreen extends StatefulWidget {
  @override
  _GroceryHomeScreenState createState() => _GroceryHomeScreenState();
}

class _GroceryHomeScreenState extends State<GroceryHomeScreen> {
  String searchQuery = '';
  int _selectedIndex = 0; // Tracks the current selected tab index

  // This list will hold the actual widget content for each tab.
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      // --- Home Screen Content (Your original body) ---
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            SearchBarWidget(
              onSearch: (query) {
                setState(() {
                  searchQuery = query;
                });
                _handleSearch(query);
              },
            ),
            const SizedBox(height: 24),

            // Fresh Vegetables Section
            _buildSectionTitle('Fresh Vegetables'),
            const SizedBox(height: 16),
            VegetableSliderWidget(
              onBuy: _handleVegetableBuy,
            ),
            const SizedBox(height: 32),

            // Fresh Fruits Section
            _buildSectionTitle('Fresh Fruits'),
            const SizedBox(height: 16),
            FruitGridWidget(
              onFruitTap: _handleFruitTap,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // --- Other Tab Contents ---
      const BlogScreen(),    // Content for the Blog tab
      const CartScreen(),    // Content for the Cart tab
      const ProfileScreen(), // Content for the Profile tab
    ];
  }

  // Function to update the selected index when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Only show the app bar for the 'Home' screen,
      // other screens might have their own app bars or none.
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
      
      // Display the widget corresponding to the currently selected index
      body: _widgetOptions[_selectedIndex],
      
      // The shared bottom navigation bar
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // Default back button behavior, pops the current route.
          // In a multi-tab setup, you might want custom logic here
          // if you're on the root tab and hit back.
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            // This is the main screen and there's no previous route.
            // You might want to exit the app or do nothing.
            print("No more routes to pop. This is the root screen.");
          }
        },
      ),
      title: const Text( // Add a title to your AppBar
        'Grocery Home',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.black),
          onPressed: _handleFilterTap,
        ),
      ],
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
    // Implement search logic here.
    // You would typically filter your data source (e.g., lists of vegetables/fruits)
    // based on this query and update the widgets that display them.
    // For this example, it just prints the query.
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
            Expanded(
              child: Text(
                'Add to Cart',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  'Price: ₭${vegetable.price.toStringAsFixed(0)}',
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
              // Add the item to the cart using the CartProvider
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

  void _handleFruitTap(FruitItem fruit) {
    _showSuccessSnackBar('${fruit.name} selected!');
    // Logic for when a fruit item is tapped (e.g., navigate to a detail page)
  }

  void _handleFilterTap() {
    _showSuccessSnackBar('Filter options coming soon!');
    // Logic for filter functionality (e.g., show a bottom sheet with filters)
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