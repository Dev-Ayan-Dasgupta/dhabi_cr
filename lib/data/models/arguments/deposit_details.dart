import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DepositDetailsArgumentModel {
  final String accountNumber;
  DepositDetailsArgumentModel({
    required this.accountNumber,
  });

  DepositDetailsArgumentModel copyWith({
    String? accountNumber,
  }) {
    return DepositDetailsArgumentModel(
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
    };
  }

  factory DepositDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return DepositDetailsArgumentModel(
      accountNumber: map['accountNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DepositDetailsArgumentModel.fromJson(String source) =>
      DepositDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DepositDetailsArgumentModel(accountNumber: $accountNumber)';

  @override
  bool operator ==(covariant DepositDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.accountNumber == accountNumber;
  }

  @override
  int get hashCode => accountNumber.hashCode;
}
