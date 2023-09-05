// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String name;
  final String description;
  final num price;
  final num quantity;
  final String? id;
  final String category;
  final List<String> images;
  final num avgRating;
  // rating

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.id,
    required this.category,
    required this.images,
    required this.avgRating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      '_id': id,
      'category': category,
      'images': images,
      'avgRating': avgRating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as num,
      quantity: map['quantity'] as num,
      id: map['_id'] != null ? map['_id'] as String : null,
      category: map['category'] as String,
      images: List<String>.from(
        (map['images'] as List<dynamic>),
      ),
      avgRating: map['avgRating'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
