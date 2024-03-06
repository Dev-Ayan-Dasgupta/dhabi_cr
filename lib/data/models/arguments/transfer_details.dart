// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransferDetailsArgumentModel {
  final String status;
  final String referenceNumber;
  final String beneficiaryName;
  final String beneficiaryAccountNo;
  final String transferAmount;
  final String transferDate;
  final String fee;
  final String exchangeRate;
  final String creditAmount;
  final String benBankName;
  final String benCountry;
  final String benWalletName;
  final String benWalletNo;
  final String reasonForSending;
  final String transactionType;
  TransferDetailsArgumentModel({
    required this.status,
    required this.referenceNumber,
    required this.beneficiaryName,
    required this.beneficiaryAccountNo,
    required this.transferAmount,
    required this.transferDate,
    required this.fee,
    required this.exchangeRate,
    required this.creditAmount,
    required this.benBankName,
    required this.benCountry,
    required this.benWalletName,
    required this.benWalletNo,
    required this.reasonForSending,
    required this.transactionType,
  });

  TransferDetailsArgumentModel copyWith({
    String? status,
    String? referenceNumber,
    String? beneficiaryName,
    String? beneficiaryAccountNo,
    String? transferAmount,
    String? transferDate,
    String? fee,
    String? exchangeRate,
    String? creditAmount,
    String? benBankName,
    String? benCountry,
    String? benWalletName,
    String? benWalletNo,
    String? reasonForSending,
    String? transactionType,
  }) {
    return TransferDetailsArgumentModel(
      status: status ?? this.status,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      beneficiaryAccountNo: beneficiaryAccountNo ?? this.beneficiaryAccountNo,
      transferAmount: transferAmount ?? this.transferAmount,
      transferDate: transferDate ?? this.transferDate,
      fee: fee ?? this.fee,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      creditAmount: creditAmount ?? this.creditAmount,
      benBankName: benBankName ?? this.benBankName,
      benCountry: benCountry ?? this.benCountry,
      benWalletName: benWalletName ?? this.benWalletName,
      benWalletNo: benWalletNo ?? this.benWalletNo,
      reasonForSending: reasonForSending ?? this.reasonForSending,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'referenceNumber': referenceNumber,
      'beneficiaryName': beneficiaryName,
      'beneficiaryAccountNo': beneficiaryAccountNo,
      'transferAmount': transferAmount,
      'transferDate': transferDate,
      'fee': fee,
      'exchangeRate': exchangeRate,
      'creditAmount': creditAmount,
      'benBankName': benBankName,
      'benCountry': benCountry,
      'benWalletName': benWalletName,
      'benWalletNo': benWalletNo,
      'reasonForSending': reasonForSending,
      'transactionType': transactionType,
    };
  }

  factory TransferDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return TransferDetailsArgumentModel(
      status: map['status'] as String,
      referenceNumber: map['referenceNumber'] as String,
      beneficiaryName: map['beneficiaryName'] as String,
      beneficiaryAccountNo: map['beneficiaryAccountNo'] as String,
      transferAmount: map['transferAmount'] as String,
      transferDate: map['transferDate'] as String,
      fee: map['fee'] as String,
      exchangeRate: map['exchangeRate'] as String,
      creditAmount: map['creditAmount'] as String,
      benBankName: map['benBankName'] as String,
      benCountry: map['benCountry'] as String,
      benWalletName: map['benWalletName'] as String,
      benWalletNo: map['benWalletNo'] as String,
      reasonForSending: map['reasonForSending'] as String,
      transactionType: map['transactionType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferDetailsArgumentModel.fromJson(String source) =>
      TransferDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransferDetailsArgumentModel(status: $status, referenceNumber: $referenceNumber, beneficiaryName: $beneficiaryName, beneficiaryAccountNo: $beneficiaryAccountNo, transferAmount: $transferAmount, transferDate: $transferDate, fee: $fee, exchangeRate: $exchangeRate, creditAmount: $creditAmount, benBankName: $benBankName, benCountry: $benCountry, benWalletName: $benWalletName, benWalletNo: $benWalletNo, reasonForSending: $reasonForSending, transactionType: $transactionType)';
  }

  @override
  bool operator ==(covariant TransferDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.referenceNumber == referenceNumber &&
        other.beneficiaryName == beneficiaryName &&
        other.beneficiaryAccountNo == beneficiaryAccountNo &&
        other.transferAmount == transferAmount &&
        other.transferDate == transferDate &&
        other.fee == fee &&
        other.exchangeRate == exchangeRate &&
        other.creditAmount == creditAmount &&
        other.benBankName == benBankName &&
        other.benCountry == benCountry &&
        other.benWalletName == benWalletName &&
        other.benWalletNo == benWalletNo &&
        other.reasonForSending == reasonForSending &&
        other.transactionType == transactionType;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        referenceNumber.hashCode ^
        beneficiaryName.hashCode ^
        beneficiaryAccountNo.hashCode ^
        transferAmount.hashCode ^
        transferDate.hashCode ^
        fee.hashCode ^
        exchangeRate.hashCode ^
        creditAmount.hashCode ^
        benBankName.hashCode ^
        benCountry.hashCode ^
        benWalletName.hashCode ^
        benWalletNo.hashCode ^
        reasonForSending.hashCode ^
        transactionType.hashCode;
  }
}
