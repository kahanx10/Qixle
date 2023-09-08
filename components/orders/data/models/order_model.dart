import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Order {
  final String id;
  final List<dynamic> products; // products - [{product, quantity}]
  final double totalPrice;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;

  Order({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'products': products,
      'totalPrice': totalPrice,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      products: List<dynamic>.from((map['products'] as List<dynamic>)),
      totalPrice: double.parse(map['totalPrice'].toString()),
      address: map['address'] as String,
      userId: map['userId'] as String,
      orderedAt: map['orderedAt'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  Order copyWith({
    String? id,
    List<dynamic>? products,
    double? totalPrice,
    String? address,
    String? userId,
    int? orderedAt,
    int? status,
  }) {
    return Order(
      id: id ?? this.id,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      orderedAt: orderedAt ?? this.orderedAt,
      status: status ?? this.status,
    );
  }
}
