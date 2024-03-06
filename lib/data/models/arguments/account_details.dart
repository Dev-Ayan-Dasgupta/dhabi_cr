// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AccountDetailsArgumentModel {
  final String flagImgUrl;
  final String accountNumber;
  final String currency;
  final String accountType;
  final String balance;
  final String iban;
  final List displayStatementList;
  final bool isRetail;
  final bool canDeactivateAccount;

  AccountDetailsArgumentModel({
    required this.flagImgUrl,
    required this.accountNumber,
    required this.currency,
    required this.accountType,
    required this.balance,
    required this.iban,
    required this.displayStatementList,
    required this.isRetail,
    required this.canDeactivateAccount,
  });

  AccountDetailsArgumentModel copyWith({
    String? flagImgUrl,
    String? accountNumber,
    String? currency,
    String? accountType,
    String? balance,
    String? iban,
    List? displayStatementList,
    bool? isRetail,
    bool? canDeactivateAccount,
  }) {
    return AccountDetailsArgumentModel(
      flagImgUrl: flagImgUrl ?? this.flagImgUrl,
      accountNumber: accountNumber ?? this.accountNumber,
      currency: currency ?? this.currency,
      accountType: accountType ?? this.accountType,
      balance: balance ?? this.balance,
      iban: iban ?? this.iban,
      displayStatementList: displayStatementList ?? this.displayStatementList,
      isRetail: isRetail ?? this.isRetail,
      canDeactivateAccount: canDeactivateAccount ?? this.canDeactivateAccount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flagImgUrl': flagImgUrl,
      'accountNumber': accountNumber,
      'currency': currency,
      'accountType': accountType,
      'balance': balance,
      'iban': iban,
      'displayStatementList': displayStatementList,
      'isRetail': isRetail,
      'canDeactivateAccount': canDeactivateAccount,
    };
  }

  factory AccountDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return AccountDetailsArgumentModel(
      flagImgUrl: map['flagImgUrl'] as String,
      accountNumber: map['accountNumber'] as String,
      currency: map['currency'] as String,
      accountType: map['accountType'] as String,
      balance: map['balance'] as String,
      iban: map['iban'] as String,
      displayStatementList: (map['displayStatementList'] as List),
      isRetail: map['isRetail'] as bool,
      canDeactivateAccount: map['canDeactivateAccount'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountDetailsArgumentModel.fromJson(String source) =>
      AccountDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccountDetailsArgumentModel(flagImgUrl: $flagImgUrl, accountNumber: $accountNumber, currency: $currency, accountType: $accountType, balance: $balance, iban: $iban, displayStatementList: $displayStatementList, isRetail: $isRetail, canDeactivateAccount: $canDeactivateAccount)';
  }

  @override
  bool operator ==(covariant AccountDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.flagImgUrl == flagImgUrl &&
        other.accountNumber == accountNumber &&
        other.currency == currency &&
        other.accountType == accountType &&
        other.balance == balance &&
        other.iban == iban &&
        listEquals(other.displayStatementList, displayStatementList) &&
        other.isRetail == isRetail &&
        other.canDeactivateAccount == canDeactivateAccount;
  }

  @override
  int get hashCode {
    return flagImgUrl.hashCode ^
        accountNumber.hashCode ^
        currency.hashCode ^
        accountType.hashCode ^
        balance.hashCode ^
        iban.hashCode ^
        displayStatementList.hashCode ^
        isRetail.hashCode ^
        canDeactivateAccount.hashCode;
  }
}
