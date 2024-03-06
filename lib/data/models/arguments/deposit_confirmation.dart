import 'dart:convert';

import 'package:dialup_mobile_app/data/models/arguments/deposit_beneficiary.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DepositConfirmationArgumentModel {
  String currency;
  String accountNumber;
  double depositAmount;
  int tenureDays;
  double interestRate;
  double interestAmount;
  String interestPayout;
  bool isAutoRenewal;
  bool isAutoTransfer;
  String creditAccountNumber;
  DateTime dateOfMaturity;
  DepositBeneficiaryModel depositBeneficiary;
  bool isRetail;

  DepositConfirmationArgumentModel({
    required this.currency,
    required this.accountNumber,
    required this.depositAmount,
    required this.tenureDays,
    required this.interestRate,
    required this.interestAmount,
    required this.interestPayout,
    required this.isAutoRenewal,
    required this.isAutoTransfer,
    required this.creditAccountNumber,
    required this.dateOfMaturity,
    required this.depositBeneficiary,
    required this.isRetail,
  });

  DepositConfirmationArgumentModel copyWith({
    String? currency,
    String? accountNumber,
    double? depositAmount,
    int? tenureDays,
    double? interestRate,
    double? interestAmount,
    String? interestPayout,
    bool? isAutoRenewal,
    bool? isAutoTransfer,
    String? creditAccountNumber,
    DateTime? dateOfMaturity,
    DepositBeneficiaryModel? depositBeneficiary,
    bool? isRetail,
  }) {
    return DepositConfirmationArgumentModel(
      currency: currency ?? this.currency,
      accountNumber: accountNumber ?? this.accountNumber,
      depositAmount: depositAmount ?? this.depositAmount,
      tenureDays: tenureDays ?? this.tenureDays,
      interestRate: interestRate ?? this.interestRate,
      interestAmount: interestAmount ?? this.interestAmount,
      interestPayout: interestPayout ?? this.interestPayout,
      isAutoRenewal: isAutoRenewal ?? this.isAutoRenewal,
      isAutoTransfer: isAutoTransfer ?? this.isAutoTransfer,
      creditAccountNumber: creditAccountNumber ?? this.creditAccountNumber,
      dateOfMaturity: dateOfMaturity ?? this.dateOfMaturity,
      depositBeneficiary: depositBeneficiary ?? this.depositBeneficiary,
      isRetail: isRetail ?? this.isRetail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currency': currency,
      'accountNumber': accountNumber,
      'depositAmount': depositAmount,
      'tenureDays': tenureDays,
      'interestRate': interestRate,
      'interestAmount': interestAmount,
      'interestPayout': interestPayout,
      'isAutoRenewal': isAutoRenewal,
      'isAutoTransfer': isAutoTransfer,
      'creditAccountNumber': creditAccountNumber,
      'dateOfMaturity': dateOfMaturity,
      'depositBeneficiary': depositBeneficiary,
      'isRetail': isRetail,
    };
  }

  factory DepositConfirmationArgumentModel.fromMap(Map<String, dynamic> map) {
    return DepositConfirmationArgumentModel(
      currency: map['currency'] as String,
      accountNumber: map['accountNumber'] as String,
      depositAmount: map['depositAmount'] as double,
      tenureDays: map['tenureDays'] as int,
      interestRate: map['interestRate'] as double,
      interestAmount: map['interestAmount'] as double,
      interestPayout: map['interestPayout'] as String,
      isAutoRenewal: map['isAutoRenewal'] as bool,
      isAutoTransfer: map['isAutoTransfer'] as bool,
      creditAccountNumber: map['creditAccountNumber'] as String,
      dateOfMaturity: (map['dateOfMaturity'] as DateTime),
      depositBeneficiary:
          (map['depositBeneficiary'] as DepositBeneficiaryModel),
      isRetail: map['isRetail'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DepositConfirmationArgumentModel.fromJson(String source) =>
      DepositConfirmationArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DepositConfirmationArgumentModel(currency: $currency, accountNumber: $accountNumber, depositAmount: $depositAmount, tenureDays: $tenureDays, interestRate: $interestRate, interestAmount: $interestAmount, interestPayout: $interestPayout, isAutoRenewal: $isAutoRenewal, isAutoTransfer: $isAutoTransfer, creditAccountNumber: $creditAccountNumber, dateOfMaturity: $dateOfMaturity, depositBeneficiary: $depositBeneficiary, isRetail: $isRetail)';
  }

  @override
  bool operator ==(covariant DepositConfirmationArgumentModel other) {
    if (identical(this, other)) return true;

    return other.currency == currency &&
        other.accountNumber == accountNumber &&
        other.depositAmount == depositAmount &&
        other.tenureDays == tenureDays &&
        other.interestRate == interestRate &&
        other.interestAmount == interestAmount &&
        other.interestPayout == interestPayout &&
        other.isAutoRenewal == isAutoRenewal &&
        other.isAutoTransfer == isAutoTransfer &&
        other.creditAccountNumber == creditAccountNumber &&
        other.dateOfMaturity == dateOfMaturity &&
        other.depositBeneficiary == depositBeneficiary &&
        other.isRetail == isRetail;
  }

  @override
  int get hashCode {
    return currency.hashCode ^
        accountNumber.hashCode ^
        depositAmount.hashCode ^
        tenureDays.hashCode ^
        interestRate.hashCode ^
        interestAmount.hashCode ^
        interestPayout.hashCode ^
        isAutoRenewal.hashCode ^
        isAutoTransfer.hashCode ^
        creditAccountNumber.hashCode ^
        dateOfMaturity.hashCode ^
        depositBeneficiary.hashCode ^
        isRetail.hashCode;
  }
}
