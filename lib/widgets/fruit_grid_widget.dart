import 'package:flutter/material.dart';
import '../models/grocery_models.dart'; // Assuming FruitItem is defined here
import 'fruit_card_widget.dart';

class FruitGridWidget extends StatelessWidget {
  final List<FruitItem>? fruits;
  final Function(FruitItem)? onFruitTap;

  const FruitGridWidget({
    Key? key,
    this.fruits,
    this.onFruitTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FruitItem> fruitList = fruits ?? _getDefaultFruits();

    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4),
        itemCount: fruitList.length,
        itemBuilder: (context, index) {
          return FruitCard(
            fruit: fruitList[index],
            onTap: onFruitTap,
          );
        },
      ),
    );
  }

  List<FruitItem> _getDefaultFruits() {
    return [
      FruitItem(
          name: 'Tomato',
          image: '🍅',
          description: 'A versatile and juicy red fruit.', // Added
          price: 2.99, // Added
          rating: 4.5), // Added
      FruitItem(
          name: 'Orange',
          image: '🍊',
          description: 'A citrus fruit packed with Vitamin C.', // Added
          price: 1.50, // Added
          rating: 4.7), // Added
      FruitItem(
          name: 'Banana',
          image: '🍌',
          description: 'A potassium-rich and energy-boosting fruit.', // Added
          price: 0.79, // Added
          rating: 4.8), // Added
      FruitItem(
          name: 'Avocado',
          image: '🥑',
          description: 'A creamy fruit, great for healthy fats.', // Added
          price: 2.49, // Added
          rating: 4.6), // Added
      FruitItem(
          name: 'Apple',
          image: '🍎',
          description: 'A crisp and sweet fruit, perfect for snacking.', // Added
          price: 1.20, // Added
          rating: 4.9), // Added
      FruitItem(
          name: 'Grapes',
          image: '🍇',
          description: 'Sweet and juicy berries, great in bunches.', // Added
          price: 3.99, // Added
          rating: 4.7), // Added
    ];
  }
}