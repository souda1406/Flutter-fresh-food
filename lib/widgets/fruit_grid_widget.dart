import 'package:flutter/material.dart';
import '../models/grocery_models.dart'; // Import FruitItem

class FruitGridWidget extends StatelessWidget {
  final List<FruitItem> fruits; // Accept a list of fruits
  final Function(FruitItem) onBuy; // Changed from onFruitTap to onBuy

  const FruitGridWidget({
    Key? key,
    required this.fruits, // Make it required
    required this.onBuy, // Updated property name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Fixed height for the slider, consistent with vegetable slider
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Changed from GridView to horizontal ListView
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return Container(
            width: 150, // Fixed width for each card, consistent with vegetable slider
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  // Removed mainAxisAlignment: MainAxisAlignment.center
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      fruit.image,
                      style: const TextStyle(fontSize: 48), // Larger emoji
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fruit.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Display Price per kilo
                    Text(
                      '₭${fruit.price.toStringAsFixed(0)} / kilo', // Display price with unit
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(), // NEW: Spacer to push button to the bottom
                    ElevatedButton(
                      onPressed: () => onBuy(fruit), // Call onBuy when button is pressed
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 35), // Full width button
                      ),
                      child: const Text('Add to Cart'), // Changed button text
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}