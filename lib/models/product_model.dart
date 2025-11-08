// import 'package:flutter/material.dart';
// // product_model.dart
// class Product {
//   final String id;
//   final String name;
//   final String weight;
//   final double price;
//   final String imageUrl;
//   final String category;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.weight,
//     required this.price,
//     required this.imageUrl,
//     required this.category,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       weight: json['weight'],
//       price: json['price'].toDouble(),
//       imageUrl: json['image_url'],
//       category: json['category'],
//     );
//   }
// }
//
// // API Service example
// class ApiService {
//   static const baseUrl = 'https://your-api.com';
//
//   // Future<List<Product>> getProducts() async {
//   //   // Add your API call here
//   //   // final response = await http.get('$baseUrl/products');
//   //   // return products;
//   // }
// }

class ProductItem {
  final String productId;
  final String image;
  final String title;
  final List<String>? images;
  final String discription;
  final dynamic price;
  final dynamic sellPrice;
  int qty;

  ProductItem({
    required this.productId,
    required this.image,
    required this.images,
    required this.title,
    required this.discription,
    required this.price,
    required this.sellPrice,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "image": image,
    "title": title,
    "images": images,
    "discription": discription,
    "price": price,
    "sell_price": sellPrice,
    "qty": qty,
  };

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
    productId: json["product_id"],
    image: json["image"],
    images: json['images'] != null ? List<String>.from(json['images']) : null,
    title: json["title"],
    discription: json["discription"],
    price: _parseDouble(json["price"]),
    sellPrice: _parseDouble(json["sell_price"]),

    qty: json["qty"],
  );
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }}


