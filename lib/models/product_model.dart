import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final String ingredients;
  final bool isAvailable;
  final bool isPopular;
  final bool isRecommended;
  final int orderCount;
  final double price;
  final DateTime? recommendedAt;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.isAvailable,
    required this.isPopular,
    required this.isRecommended,
    required this.orderCount,
    required this.price,
    this.recommendedAt,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ingredients: json['ingredients'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      isPopular: json['isPopular'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
      orderCount: json['orderCount'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      recommendedAt: json['recommendedAt'] != null
          ? (json['recommendedAt'] as Timestamp).toDate()
          : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
