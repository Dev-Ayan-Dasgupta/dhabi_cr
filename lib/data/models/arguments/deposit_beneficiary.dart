import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DepositBeneficiaryModel {
  String accountNumber;
  String name;
  String address;
  int accountType;
  int swiftReference;
  String reasonForSending;
  bool saveBeneficiary;
  DepositBeneficiaryModel({
    required this.accountNumber,
    required this.name,
    required this.address,
    required this.accountType,
    required this.swiftReference,
    required this.reasonForSending,
    required this.saveBeneficiary,
  });

  DepositBeneficiaryModel copyWith({
    String? accountNumber,
    String? name,
    String? address,
    int? accountType,
    int? swiftReference,
    String? reasonForSending,
    bool? saveBeneficiary,
  }) {
    return DepositBeneficiaryModel(
      accountNumber: accountNumber ?? this.accountNumber,
      name: name ?? this.name,
      address: address ?? this.address,
      accountType: accountType ?? this.accountType,
      swiftReference: swiftReference ?? this.swiftReference,
      reasonForSending: reasonForSending ?? this.reasonForSending,
      saveBeneficiary: saveBeneficiary ?? this.saveBeneficiary,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'name': name,
      'address': address,
      'accountType': accountType,
      'swiftReference': swiftReference,
      'reasonForSending': reasonForSending,
      'saveBeneficiary': saveBeneficiary,
    };
  }

  factory DepositBeneficiaryModel.fromMap(Map<String, dynamic> map) {
    return DepositBeneficiaryModel(
      accountNumber: map['accountNumber'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      accountType: map['accountType'] as int,
      swiftReference: map['swiftReference'] as int,
      reasonForSending: map['reasonForSending'] as String,
      saveBeneficiary: map['saveBeneficiary'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DepositBeneficiaryModel.fromJson(String source) =>
      DepositBeneficiaryModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DepositBeneficiaryModel(accountNumber: $accountNumber, name: $name, address: $address, accountType: $accountType, swiftReference: $swiftReference, reasonForSending: $reasonForSending, saveBeneficiary: $saveBeneficiary)';
  }

  @override
  bool operator ==(covariant DepositBeneficiaryModel other) {
    if (identical(this, other)) return true;

    return other.accountNumber == accountNumber &&
        other.name == name &&
        other.address == address &&
        other.accountType == accountType &&
        other.swiftReference == swiftReference &&
        other.reasonForSending == reasonForSending &&
        other.saveBeneficiary == saveBeneficiary;
  }

  @override
  int get hashCode {
    return accountNumber.hashCode ^
        name.hashCode ^
        address.hashCode ^
        accountType.hashCode ^
        swiftReference.hashCode ^
        reasonForSending.hashCode ^
        saveBeneficiary.hashCode;
  }
}
