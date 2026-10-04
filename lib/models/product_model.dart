//TODO:: This class represents one product from the DummyJSON API.*
class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.images,
  });

  //TODO:: Convert DummyJSON data into a ProductModel object.*
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['thumbnail'] as String,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}