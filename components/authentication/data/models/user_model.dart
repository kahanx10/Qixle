import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String uid;
  String name;
  String username;
  String password;
  String address;
  String type;
  String token;
  List<dynamic> cart;

  User({
    required this.uid,
    required this.name,
    required this.username,
    required this.password,
    this.cart = const [],
    this.address = '',
    this.type = 'customer',
    this.token = '',
  });

  User copyWith({
    String? uid,
    String? name,
    String? userName,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: userName ?? username,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': uid,
      'name': name,
      'username': username,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['_id'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
      token: map['token'] as String,
      cart: map['cart'] ?? const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
