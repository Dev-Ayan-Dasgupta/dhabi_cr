import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dialup_mobile_app/data/models/widgets/index.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CountryTileModel {
  final String flagImgUrl;
  final String country;
  final List<dynamic> supportedCurrencies;
  final bool isBank;
  final bool isWallet;
  final bool isTerraPaySupported;
  final bool isBusinessSupported;
  final double threshold;
  final String countryShortCode;
  final String currencyCode;
  final String currencyFlag;
  final List<String> currencies;
  final List<DropDownCountriesModel> currencyModelsBank;
  final List<DropDownCountriesModel> currencyModelsWallet;
  CountryTileModel({
    required this.flagImgUrl,
    required this.country,
    required this.supportedCurrencies,
    required this.isBank,
    required this.isWallet,
    required this.isTerraPaySupported,
    required this.isBusinessSupported,
    required this.threshold,
    required this.countryShortCode,
    required this.currencyCode,
    required this.currencyFlag,
    required this.currencies,
    required this.currencyModelsBank,
    required this.currencyModelsWallet,
  });

  CountryTileModel copyWith({
    String? flagImgUrl,
    String? country,
    List<dynamic>? supportedCurrencies,
    bool? isBank,
    bool? isWallet,
    bool? isTerraPaySupported,
    bool? isBusinessSupported,
    double? threshold,
    String? countryShortCode,
    String? currencyCode,
    String? currencyFlag,
    List<String>? currencies,
    List<DropDownCountriesModel>? currencyModelsBank,
    List<DropDownCountriesModel>? currencyModelsWallet,
  }) {
    return CountryTileModel(
      flagImgUrl: flagImgUrl ?? this.flagImgUrl,
      country: country ?? this.country,
      supportedCurrencies: supportedCurrencies ?? this.supportedCurrencies,
      isBank: isBank ?? this.isBank,
      isWallet: isWallet ?? this.isWallet,
      isTerraPaySupported: isTerraPaySupported ?? this.isTerraPaySupported,
      isBusinessSupported: isBusinessSupported ?? this.isBusinessSupported,
      threshold: threshold ?? this.threshold,
      countryShortCode: countryShortCode ?? this.countryShortCode,
      currencyCode: currencyCode ?? this.currencyCode,
      currencyFlag: currencyFlag ?? this.currencyFlag,
      currencies: currencies ?? this.currencies,
      currencyModelsBank: currencyModelsBank ?? this.currencyModelsBank,
      currencyModelsWallet: currencyModelsWallet ?? this.currencyModelsWallet,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flagImgUrl': flagImgUrl,
      'country': country,
      'supportedCurrencies': supportedCurrencies,
      'isBank': isBank,
      'isWallet': isWallet,
      'isTerraPaySupported': isTerraPaySupported,
      'isBusinessSupported': isBusinessSupported,
      'threshold': threshold,
      'countryShortCode': countryShortCode,
      'currencyCode': currencyCode,
      'currencyFlag': currencyFlag,
      'currencies': currencies,
      'currencyModelsBank': currencyModelsBank.map((x) => x.toMap()).toList(),
      'currencyModelsWallet':
          currencyModelsWallet.map((x) => x.toMap()).toList(),
    };
  }

  factory CountryTileModel.fromMap(Map<String, dynamic> map) {
    return CountryTileModel(
      flagImgUrl: map['flagImgUrl'] as String,
      country: map['country'] as String,
      supportedCurrencies: (map['supportedCurrencies'] as List<dynamic>),
      isBank: map['isBank'] as bool,
      isWallet: map['isWallet'] as bool,
      isTerraPaySupported: map['isTerraPaySupported'] as bool,
      isBusinessSupported: map['isBusinessSupported'] as bool,
      threshold: map['threshold'] as double,
      countryShortCode: map['countryShortCode'] as String,
      currencyCode: map['currencyCode'] as String,
      currencyFlag: map['currencyFlag'] as String,
      currencies: (map['currencies'] as List<String>),
      currencyModelsBank:
          (map['currencyModelsBank'] as List<DropDownCountriesModel>),
      currencyModelsWallet:
          (map['currencyModelsBank'] as List<DropDownCountriesModel>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryTileModel.fromJson(String source) =>
      CountryTileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CountryTileModel(flagImgUrl: $flagImgUrl, country: $country, supportedCurrencies: $supportedCurrencies, isBank: $isBank, isWallet: $isWallet, isTerraPaySupported: $isTerraPaySupported, isBusinessSupported: $isBusinessSupported, threshold: $threshold, countryShortCode: $countryShortCode, currencyCode: $currencyCode, currencyFlag: $currencyFlag, currencies: $currencies, currencyModelsBank: $currencyModelsBank, currencyModelsWallet: $currencyModelsWallet)';
  }

  @override
  bool operator ==(covariant CountryTileModel other) {
    if (identical(this, other)) return true;

    return other.flagImgUrl == flagImgUrl &&
        other.country == country &&
        listEquals(other.supportedCurrencies, supportedCurrencies) &&
        other.isBank == isBank &&
        other.isWallet == isWallet &&
        other.isTerraPaySupported == isTerraPaySupported &&
        other.isBusinessSupported == isBusinessSupported &&
        other.threshold == threshold &&
        other.countryShortCode == countryShortCode &&
        other.currencyCode == currencyCode &&
        other.currencyFlag == currencyFlag &&
        listEquals(other.currencies, currencies) &&
        listEquals(other.currencyModelsBank, currencyModelsBank) &&
        listEquals(other.currencyModelsWallet, currencyModelsWallet);
  }

  @override
  int get hashCode {
    return flagImgUrl.hashCode ^
        country.hashCode ^
        supportedCurrencies.hashCode ^
        isBank.hashCode ^
        isWallet.hashCode ^
        isTerraPaySupported.hashCode ^
        isBusinessSupported.hashCode ^
        threshold.hashCode ^
        countryShortCode.hashCode ^
        currencyCode.hashCode ^
        currencyFlag.hashCode ^
        currencies.hashCode ^
        currencyModelsBank.hashCode ^
        currencyModelsWallet.hashCode;
  }
}

class SupportedCurrenciesModel {
  final String currencyCode;
  final String currencyFlag;
  final bool isBank;
  final bool isWallet;
  SupportedCurrenciesModel({
    required this.currencyCode,
    required this.currencyFlag,
    required this.isBank,
    required this.isWallet,
  });

  SupportedCurrenciesModel copyWith({
    String? currencyCode,
    String? currencyFlag,
    bool? isBank,
    bool? isWallet,
  }) {
    return SupportedCurrenciesModel(
      currencyCode: currencyCode ?? this.currencyCode,
      currencyFlag: currencyFlag ?? this.currencyFlag,
      isBank: isBank ?? this.isBank,
      isWallet: isWallet ?? this.isWallet,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currencyCode': currencyCode,
      'currencyFlag': currencyFlag,
      'isBank': isBank,
      'isWallet': isWallet,
    };
  }

  factory SupportedCurrenciesModel.fromMap(Map<String, dynamic> map) {
    return SupportedCurrenciesModel(
      currencyCode: map['currencyCode'] as String,
      currencyFlag: map['currencyFlag'] as String,
      isBank: map['isBank'] as bool,
      isWallet: map['isWallet'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupportedCurrenciesModel.fromJson(String source) =>
      SupportedCurrenciesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SupportedCurrenciesModel(currencyCode: $currencyCode, currencyFlag: $currencyFlag, isBank: $isBank, isWallet: $isWallet)';
  }

  @override
  bool operator ==(covariant SupportedCurrenciesModel other) {
    if (identical(this, other)) return true;

    return other.currencyCode == currencyCode &&
        other.currencyFlag == currencyFlag &&
        other.isBank == isBank &&
        other.isWallet == isWallet;
  }

  @override
  int get hashCode {
    return currencyCode.hashCode ^
        currencyFlag.hashCode ^
        isBank.hashCode ^
        isWallet.hashCode;
  }
}
