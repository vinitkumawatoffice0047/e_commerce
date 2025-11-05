import 'package:flutter/material.dart';
// product_model.dart
class Product {
  final String id;
  final String name;
  final String weight;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      weight: json['weight'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
      category: json['category'],
    );
  }
}

// API Service example
class ApiService {
  static const baseUrl = 'https://your-api.com';

  // Future<List<Product>> getProducts() async {
  //   // Add your API call here
  //   // final response = await http.get('$baseUrl/products');
  //   // return products;
  // }
}