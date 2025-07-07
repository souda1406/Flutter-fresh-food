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
}
