import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerificationInitializationArgumentModel {
  final bool isReKyc;
  VerificationInitializationArgumentModel({
    required this.isReKyc,
  });

  VerificationInitializationArgumentModel copyWith({
    bool? isReKyc,
  }) {
    return VerificationInitializationArgumentModel(
      isReKyc: isReKyc ?? this.isReKyc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isReKyc': isReKyc,
    };
  }

  factory VerificationInitializationArgumentModel.fromMap(
      Map<String, dynamic> map) {
    return VerificationInitializationArgumentModel(
      isReKyc: map['isReKyc'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificationInitializationArgumentModel.fromJson(String source) =>
      VerificationInitializationArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'VerificationInitializationArgumentModel(isReKyc: $isReKyc)';

  @override
  bool operator ==(covariant VerificationInitializationArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isReKyc == isReKyc;
  }

  @override
  int get hashCode => isReKyc.hashCode;
}
