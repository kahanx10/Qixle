import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Earning {
  String category;
  int earning;

  Earning({
    required this.category,
    required this.earning,
  });

  factory Earning.fromMap(Map<String, dynamic> map) {
    return Earning(
      category: map['category'] as String,
      earning: map['earnings'] as int,
    );
  }

  factory Earning.fromJson(String source) =>
      Earning.fromMap(json.decode(source) as Map<String, dynamic>);
}
