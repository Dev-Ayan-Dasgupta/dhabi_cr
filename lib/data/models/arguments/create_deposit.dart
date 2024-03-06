import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreateDepositArgumentModel {
  final bool isRetail;
  CreateDepositArgumentModel({
    required this.isRetail,
  });

  CreateDepositArgumentModel copyWith({
    bool? isRetail,
  }) {
    return CreateDepositArgumentModel(
      isRetail: isRetail ?? this.isRetail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isRetail': isRetail,
    };
  }

  factory CreateDepositArgumentModel.fromMap(Map<String, dynamic> map) {
    return CreateDepositArgumentModel(
      isRetail: map['isRetail'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateDepositArgumentModel.fromJson(String source) =>
      CreateDepositArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CreateDepositArgumentModel(isRetail: $isRetail)';

  @override
  bool operator ==(covariant CreateDepositArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isRetail == isRetail;
  }

  @override
  int get hashCode => isRetail.hashCode;
}
