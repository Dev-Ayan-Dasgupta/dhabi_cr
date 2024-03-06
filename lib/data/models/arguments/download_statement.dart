import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DownloadStatementArgumentModel {
  final String accountNumber;
  final String accountType;
  final String ibanNumber;
  DownloadStatementArgumentModel({
    required this.accountNumber,
    required this.accountType,
    required this.ibanNumber,
  });

  DownloadStatementArgumentModel copyWith({
    String? accountNumber,
    String? accountType,
    String? ibanNumber,
  }) {
    return DownloadStatementArgumentModel(
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      ibanNumber: ibanNumber ?? this.ibanNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'accountType': accountType,
      'ibanNumber': ibanNumber,
    };
  }

  factory DownloadStatementArgumentModel.fromMap(Map<String, dynamic> map) {
    return DownloadStatementArgumentModel(
      accountNumber: map['accountNumber'] as String,
      accountType: map['accountType'] as String,
      ibanNumber: map['ibanNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadStatementArgumentModel.fromJson(String source) =>
      DownloadStatementArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DownloadStatementArgumentModel(accountNumber: $accountNumber, accountType: $accountType, ibanNumber: $ibanNumber)';

  @override
  bool operator ==(covariant DownloadStatementArgumentModel other) {
    if (identical(this, other)) return true;

    return other.accountNumber == accountNumber &&
        other.accountType == accountType &&
        other.ibanNumber == ibanNumber;
  }

  @override
  int get hashCode =>
      accountNumber.hashCode ^ accountType.hashCode ^ ibanNumber.hashCode;
}
