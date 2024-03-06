import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotAvailableArgumentModel {
  final String country;
  NotAvailableArgumentModel({
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
    };
  }

  factory NotAvailableArgumentModel.fromMap(Map<String, dynamic> map) {
    return NotAvailableArgumentModel(
      country: map['country'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotAvailableArgumentModel.fromJson(String source) =>
      NotAvailableArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
