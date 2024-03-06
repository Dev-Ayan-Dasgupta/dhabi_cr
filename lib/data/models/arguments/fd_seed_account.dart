import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SeedAccount {
  final String accountNumber;
  final double threshold;
  final String currency;
  final double bal;
  final int accountType;
  final String currencyFlag;
  SeedAccount({
    required this.accountNumber,
    required this.threshold,
    required this.currency,
    required this.bal,
    required this.accountType,
    required this.currencyFlag,
  });

  SeedAccount copyWith({
    String? accountNumber,
    double? threshold,
    String? currency,
    double? bal,
    int? accountType,
    String? currencyFlag,
  }) {
    return SeedAccount(
      accountNumber: accountNumber ?? this.accountNumber,
      threshold: threshold ?? this.threshold,
      currency: currency ?? this.currency,
      bal: bal ?? this.bal,
      accountType: accountType ?? this.accountType,
      currencyFlag: currencyFlag ?? this.currencyFlag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'threshold': threshold,
      'currency': currency,
      'bal': bal,
      'accountType': accountType,
      'currencyFlag': currencyFlag,
    };
  }

  factory SeedAccount.fromMap(Map<String, dynamic> map) {
    return SeedAccount(
      accountNumber: map['accountNumber'] as String,
      threshold: map['threshold'] as double,
      currency: map['currency'] as String,
      bal: map['bal'] as double,
      accountType: map['accountType'] as int,
      currencyFlag: map['currencyFlag'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeedAccount.fromJson(String source) =>
      SeedAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SeedAccount(accountNumber: $accountNumber, threshold: $threshold, currency: $currency, bal: $bal, accountType: $accountType, currencyFlag: $currencyFlag)';
  }

  @override
  bool operator ==(covariant SeedAccount other) {
    if (identical(this, other)) return true;

    return other.accountNumber == accountNumber &&
        other.threshold == threshold &&
        other.currency == currency &&
        other.bal == bal &&
        other.accountType == accountType &&
        other.currencyFlag == currencyFlag;
  }

  @override
  int get hashCode {
    return accountNumber.hashCode ^
        threshold.hashCode ^
        currency.hashCode ^
        bal.hashCode ^
        accountType.hashCode ^
        currencyFlag.hashCode;
  }
}
