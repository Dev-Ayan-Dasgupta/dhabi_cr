import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TaxCrsArgumentModel {
  final bool isUSFATCA;
  final String ustin;
  TaxCrsArgumentModel({
    required this.isUSFATCA,
    required this.ustin,
  });

  TaxCrsArgumentModel copyWith({
    bool? isUSFATCA,
    String? ustin,
  }) {
    return TaxCrsArgumentModel(
      isUSFATCA: isUSFATCA ?? this.isUSFATCA,
      ustin: ustin ?? this.ustin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isUSFATCA': isUSFATCA,
      'ustin': ustin,
    };
  }

  factory TaxCrsArgumentModel.fromMap(Map<String, dynamic> map) {
    return TaxCrsArgumentModel(
      isUSFATCA: map['isUSFATCA'] as bool,
      ustin: map['ustin'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaxCrsArgumentModel.fromJson(String source) =>
      TaxCrsArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TaxCrsArgumentModel(isUSFATCA: $isUSFATCA, ustin: $ustin)';

  @override
  bool operator ==(covariant TaxCrsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isUSFATCA == isUSFATCA && other.ustin == ustin;
  }

  @override
  int get hashCode => isUSFATCA.hashCode ^ ustin.hashCode;
}
