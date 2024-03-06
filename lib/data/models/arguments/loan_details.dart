// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoanDetailsArgumentModel {
  final String accountNumber;
  final String currency;
  LoanDetailsArgumentModel({
    required this.accountNumber,
    required this.currency,
  });

  LoanDetailsArgumentModel copyWith({
    String? accountNumber,
    String? currency,
  }) {
    return LoanDetailsArgumentModel(
      accountNumber: accountNumber ?? this.accountNumber,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'currency': currency,
    };
  }

  factory LoanDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return LoanDetailsArgumentModel(
      accountNumber: map['accountNumber'] as String,
      currency: map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoanDetailsArgumentModel.fromJson(String source) =>
      LoanDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LoanDetailsArgumentModel(accountNumber: $accountNumber, currency: $currency)';

  @override
  bool operator ==(covariant LoanDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.accountNumber == accountNumber && other.currency == currency;
  }

  @override
  int get hashCode => accountNumber.hashCode ^ currency.hashCode;
}
