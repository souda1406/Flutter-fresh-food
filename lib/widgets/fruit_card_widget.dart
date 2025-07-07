// widgets/fruit_card_widget.dart

import 'package:flutter/material.dart';
import '../models/grocery_models.dart';

class FruitCard extends StatelessWidget {
  final FruitItem fruit;
  final Function(FruitItem)? onTap;

  const FruitCard({
    Key? key,
    required this.fruit,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onFruitTapped(context),
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  fruit.image,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              fruit.name,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onFruitTapped(BuildContext context) {
    if (onTap != null) {
      onTap!(fruit);
    } else {
      // Default tap action if no callback provided
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${fruit.name} selected!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}