import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RecipientModel {
  // final bool isWithinDhabi;
  final String beneficiaryId;
  final String flagImgUrl;
  final String flagImgUrl2;
  final String name;
  final String address;
  final int accountType;
  final String countryShortCode;
  final int swiftReference;
  final String accountNumber;
  final String currency;
  final String benBankCode;
  final String benMobileNo;
  final String benSubBankCode;
  final String benIdType;
  final String benIdNo;
  final String benIdExpiryDate;
  final String benBankName;
  final String benSwiftCode;
  final String benCity;
  final String remittancePurpose;
  final String sourceOfFunds;
  final String relation;
  final String providerName;
  final String beneficiaryStatus;

  RecipientModel({
    required this.beneficiaryId,
    required this.flagImgUrl,
    required this.flagImgUrl2,
    required this.name,
    required this.address,
    required this.accountType,
    required this.countryShortCode,
    required this.swiftReference,
    required this.accountNumber,
    required this.currency,
    required this.benBankCode,
    required this.benMobileNo,
    required this.benSubBankCode,
    required this.benIdType,
    required this.benIdNo,
    required this.benIdExpiryDate,
    required this.benBankName,
    required this.benSwiftCode,
    required this.benCity,
    required this.remittancePurpose,
    required this.sourceOfFunds,
    required this.relation,
    required this.providerName,
    required this.beneficiaryStatus,
  });

  RecipientModel copyWith({
    String? beneficiaryId,
    String? flagImgUrl,
    String? flagImgUrl2,
    String? name,
    String? address,
    int? accountType,
    String? countryShortCode,
    int? swiftReference,
    String? accountNumber,
    String? currency,
    String? benBankCode,
    String? benMobileNo,
    String? benSubBankCode,
    String? benIdType,
    String? benIdNo,
    String? benIdExpiryDate,
    String? benBankName,
    String? benSwiftCode,
    String? benCity,
    String? remittancePurpose,
    String? sourceOfFunds,
    String? relation,
    String? providerName,
    String? beneficiaryStatus,
  }) {
    return RecipientModel(
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      flagImgUrl: flagImgUrl ?? this.flagImgUrl,
      flagImgUrl2: flagImgUrl2 ?? this.flagImgUrl2,
      name: name ?? this.name,
      address: address ?? this.address,
      accountType: accountType ?? this.accountType,
      countryShortCode: countryShortCode ?? this.countryShortCode,
      swiftReference: swiftReference ?? this.swiftReference,
      accountNumber: accountNumber ?? this.accountNumber,
      currency: currency ?? this.currency,
      benBankCode: benBankCode ?? this.benBankCode,
      benMobileNo: benMobileNo ?? this.benMobileNo,
      benSubBankCode: benSubBankCode ?? this.benSubBankCode,
      benIdType: benIdType ?? this.benIdType,
      benIdNo: benIdNo ?? this.benIdNo,
      benIdExpiryDate: benIdExpiryDate ?? this.benIdExpiryDate,
      benBankName: benBankName ?? this.benBankName,
      benSwiftCode: benSwiftCode ?? this.benSwiftCode,
      benCity: benCity ?? this.benCity,
      remittancePurpose: remittancePurpose ?? this.remittancePurpose,
      sourceOfFunds: sourceOfFunds ?? this.sourceOfFunds,
      relation: relation ?? this.relation,
      providerName: providerName ?? this.providerName,
      beneficiaryStatus: beneficiaryStatus ?? this.beneficiaryStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'beneficiaryId': beneficiaryId,
      'flagImgUrl': flagImgUrl,
      'flagImgUrl2': flagImgUrl2,
      'name': name,
      'address': address,
      'accountType': accountType,
      'countryShortCode': countryShortCode,
      'swiftReference': swiftReference,
      'accountNumber': accountNumber,
      'currency': currency,
      'benBankCode': benBankCode,
      'benMobileNo': benMobileNo,
      'benSubBankCode': benSubBankCode,
      'benIdType': benIdType,
      'benIdNo': benIdNo,
      'benIdExpiryDate': benIdExpiryDate,
      'benBankName': benBankName,
      'benSwiftCode': benSwiftCode,
      'benCity': benCity,
      'remittancePurpose': remittancePurpose,
      'sourceOfFunds': sourceOfFunds,
      'relation': relation,
      'providerName': providerName,
      'beneficiaryStatus': beneficiaryStatus,
    };
  }

  factory RecipientModel.fromMap(Map<String, dynamic> map) {
    return RecipientModel(
      beneficiaryId: map['beneficiaryId'] as String,
      flagImgUrl: map['flagImgUrl'] as String,
      flagImgUrl2: map['flagImgUrl2'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      accountType: map['accountType'] as int,
      countryShortCode: map['countryShortCode'] as String,
      swiftReference: map['swiftReference'] as int,
      accountNumber: map['accountNumber'] as String,
      currency: map['currency'] as String,
      benBankCode: map['benBankCode'] as String,
      benMobileNo: map['benMobileNo'] as String,
      benSubBankCode: map['benSubBankCode'] as String,
      benIdType: map['benIdType'] as String,
      benIdNo: map['benIdNo'] as String,
      benIdExpiryDate: map['benIdExpiryDate'] as String,
      benBankName: map['benBankName'] as String,
      benSwiftCode: map['benSwiftCode'] as String,
      benCity: map['benCity'] as String,
      remittancePurpose: map['remittancePurpose'] as String,
      sourceOfFunds: map['sourceOfFunds'] as String,
      relation: map['relation'] as String,
      providerName: map['providerName'] as String,
      beneficiaryStatus: map['beneficiaryStatus'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipientModel.fromJson(String source) =>
      RecipientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipientModel(beneficiaryId: $beneficiaryId, flagImgUrl: $flagImgUrl, flagImgUrl2: $flagImgUrl2, name: $name, address: $address, accountType: $accountType, countryShortCode: $countryShortCode, swiftReference: $swiftReference, accountNumber: $accountNumber, currency: $currency, benBankCode: $benBankCode, benMobileNo: $benMobileNo, benSubBankCode: $benSubBankCode, benIdType: $benIdType, benIdNo: $benIdNo, benIdExpiryDate: $benIdExpiryDate, benBankName: $benBankName, benSwiftCode: $benSwiftCode, benCity: $benCity, remittancePurpose: $remittancePurpose, sourceOfFunds: $sourceOfFunds, relation: $relation, providerName: $providerName, beneficiaryStatus: $beneficiaryStatus)';
  }

  @override
  bool operator ==(covariant RecipientModel other) {
    if (identical(this, other)) return true;

    return other.beneficiaryId == beneficiaryId &&
        other.flagImgUrl == flagImgUrl &&
        other.flagImgUrl2 == flagImgUrl2 &&
        other.name == name &&
        other.address == address &&
        other.accountType == accountType &&
        other.countryShortCode == countryShortCode &&
        other.swiftReference == swiftReference &&
        other.accountNumber == accountNumber &&
        other.currency == currency &&
        other.benBankCode == benBankCode &&
        other.benMobileNo == benMobileNo &&
        other.benSubBankCode == benSubBankCode &&
        other.benIdType == benIdType &&
        other.benIdNo == benIdNo &&
        other.benIdExpiryDate == benIdExpiryDate &&
        other.benBankName == benBankName &&
        other.benSwiftCode == benSwiftCode &&
        other.benCity == benCity &&
        other.remittancePurpose == remittancePurpose &&
        other.sourceOfFunds == sourceOfFunds &&
        other.relation == relation &&
        other.providerName == providerName &&
        other.beneficiaryStatus == beneficiaryStatus;
  }

  @override
  int get hashCode {
    return beneficiaryId.hashCode ^
        flagImgUrl.hashCode ^
        flagImgUrl2.hashCode ^
        name.hashCode ^
        address.hashCode ^
        accountType.hashCode ^
        countryShortCode.hashCode ^
        swiftReference.hashCode ^
        accountNumber.hashCode ^
        currency.hashCode ^
        benBankCode.hashCode ^
        benMobileNo.hashCode ^
        benSubBankCode.hashCode ^
        benIdType.hashCode ^
        benIdNo.hashCode ^
        benIdExpiryDate.hashCode ^
        benBankName.hashCode ^
        benSwiftCode.hashCode ^
        benCity.hashCode ^
        remittancePurpose.hashCode ^
        sourceOfFunds.hashCode ^
        relation.hashCode ^
        providerName.hashCode ^
        beneficiaryStatus.hashCode;
  }
}
