// widgets/vegetable_slider_widget.dart

import 'package:flutter/material.dart';
import '../models/grocery_models.dart';
import 'vegetable_card_widget.dart';

class VegetableSliderWidget extends StatelessWidget {
  final List<VegetableItem>? vegetables;
  final Function(VegetableItem)? onBuy;

  const VegetableSliderWidget({
    Key? key,
    this.vegetables,
    this.onBuy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<VegetableItem> vegetableList = vegetables ?? _getDefaultVegetables();

    return Container(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4),
        itemCount: vegetableList.length,
        itemBuilder: (context, index) {
          return VegetableCard(
            vegetable: vegetableList[index],
            onBuy: onBuy,
          );
        },
      ),
    );
  }

  List<VegetableItem> _getDefaultVegetables() {
    return [
      VegetableItem(
        name: 'Fresh Pechay',
        description: 'Fresh vegetables from organic farms all over the world',
        price: 20000,
        rating: 5.0,
        image: '🥬',
      ),
      VegetableItem(
        name: 'Fresh Broccoli',
        description: 'Fresh vegetables from organic farms all over the world',
        price: 25000,
        rating: 4.8,
        image: '🥦',
      ),
      VegetableItem(
        name: 'Fresh Cabbage',
        description: 'Fresh vegetables from organic farms all over the world',
        price: 18000,
        rating: 4.9,
        image: '🥬',
      ),
      VegetableItem(
        name: 'Fresh Spinach',
        description: 'Fresh vegetables from organic farms all over the world',
        price: 15000,
        rating: 4.7,
        image: '🥬',
      ),
    ];
  }
}