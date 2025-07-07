import 'dart:convert';

// Base class for all grocery products
class GroceryProduct {
  final String name;
  final String description;
  final double price;
  final double rating;
  final String image; // Emoji or image path for the product

  GroceryProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.image,
  });

  // Convert a GroceryProduct object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'image': image,
      // Add a type field to distinguish between subclasses when deserializing
      'type': 'GroceryProduct',
    };
  }

  // Factory constructor to create a GroceryProduct from a Map
  factory GroceryProduct.fromJson(Map<String, dynamic> json) {
    // This factory is generic; subclasses will use their own specific factories.
    // However, it's useful if you ever need to deserialize a generic product.
    return GroceryProduct(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      rating: json['rating'],
      image: json['image'],
    );
  }
}

// Specific model for a Vegetable Item, inheriting from GroceryProduct.
class VegetableItem extends GroceryProduct {
  VegetableItem({
    required String name,
    required String description,
    required double price,
    required double rating,
    required String image,
  }) : super(
          name: name,
          description: description,
          price: price,
          rating: rating,
          image: image,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['type'] = 'VegetableItem'; // Override type for specific subclass
    return json;
  }

  factory VegetableItem.fromJson(Map<String, dynamic> json) {
    return VegetableItem(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      rating: json['rating'],
      image: json['image'],
    );
  }
}

// Specific model for a Fruit Item, inheriting from GroceryProduct.
class FruitItem extends GroceryProduct {
  FruitItem({
    required String name,
    required String description,
    required double price,
    required double rating,
    required String image,
  }) : super(
          name: name,
          description: description,
          price: price,
          rating: rating,
          image: image,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['type'] = 'FruitItem'; // Override type for specific subclass
    return json;
  }

  factory FruitItem.fromJson(Map<String, dynamic> json) {
    return FruitItem(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      rating: json['rating'],
      image: json['image'],
    );
  }
}
