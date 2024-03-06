import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SendMoneyArgumentModel {
  final bool isBetweenAccounts;
  final bool isWithinDhabi;
  final bool isRemittance;
  final bool isRetail;
  SendMoneyArgumentModel({
    required this.isBetweenAccounts,
    required this.isWithinDhabi,
    required this.isRemittance,
    required this.isRetail,
  });

  SendMoneyArgumentModel copyWith({
    bool? isBetweenAccounts,
    bool? isWithinDhabi,
    bool? isRemittance,
    bool? isRetail,
  }) {
    return SendMoneyArgumentModel(
      isBetweenAccounts: isBetweenAccounts ?? this.isBetweenAccounts,
      isWithinDhabi: isWithinDhabi ?? this.isWithinDhabi,
      isRemittance: isRemittance ?? this.isRemittance,
      isRetail: isRetail ?? this.isRetail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBetweenAccounts': isBetweenAccounts,
      'isWithinDhabi': isWithinDhabi,
      'isRemittance': isRemittance,
      'isRetail': isRetail,
    };
  }

  factory SendMoneyArgumentModel.fromMap(Map<String, dynamic> map) {
    return SendMoneyArgumentModel(
      isBetweenAccounts: map['isBetweenAccounts'] as bool,
      isWithinDhabi: map['isWithinDhabi'] as bool,
      isRemittance: map['isRemittance'] as bool,
      isRetail: map['isRetail'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendMoneyArgumentModel.fromJson(String source) =>
      SendMoneyArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SendMoneyArgumentModel(isBetweenAccounts: $isBetweenAccounts, isWithinDhabi: $isWithinDhabi, isRemittance: $isRemittance, isRetail: $isRetail)';
  }

  @override
  bool operator ==(covariant SendMoneyArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isBetweenAccounts == isBetweenAccounts &&
        other.isWithinDhabi == isWithinDhabi &&
        other.isRemittance == isRemittance &&
        other.isRetail == isRetail;
  }

  @override
  int get hashCode {
    return isBetweenAccounts.hashCode ^
        isWithinDhabi.hashCode ^
        isRemittance.hashCode ^
        isRetail.hashCode;
  }
}
