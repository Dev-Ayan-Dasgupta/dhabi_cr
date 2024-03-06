import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginPasswordArgumentModel {
  final String emailId;
  final int userId;
  final int userTypeId;
  final int companyId;
  final bool isSwitching;
  LoginPasswordArgumentModel({
    required this.emailId,
    required this.userId,
    required this.userTypeId,
    required this.companyId,
    required this.isSwitching,
  });

  LoginPasswordArgumentModel copyWith({
    String? emailId,
    int? userId,
    int? userTypeId,
    int? companyId,
    bool? isSwitching,
  }) {
    return LoginPasswordArgumentModel(
      emailId: emailId ?? this.emailId,
      userId: userId ?? this.userId,
      userTypeId: userTypeId ?? this.userTypeId,
      companyId: companyId ?? this.companyId,
      isSwitching: isSwitching ?? this.isSwitching,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailId': emailId,
      'userId': userId,
      'userTypeId': userTypeId,
      'companyId': companyId,
      'isSwitching': isSwitching,
    };
  }

  factory LoginPasswordArgumentModel.fromMap(Map<String, dynamic> map) {
    return LoginPasswordArgumentModel(
      emailId: map['emailId'] as String,
      userId: map['userId'] as int,
      userTypeId: map['userTypeId'] as int,
      companyId: map['companyId'] as int,
      isSwitching: map['isSwitching'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginPasswordArgumentModel.fromJson(String source) =>
      LoginPasswordArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LoginPasswordArgumentModel(emailId: $emailId, userId: $userId, userTypeId: $userTypeId, companyId: $companyId, isSwitching: $isSwitching)';
  }

  @override
  bool operator ==(covariant LoginPasswordArgumentModel other) {
    if (identical(this, other)) return true;

    return other.emailId == emailId &&
        other.userId == userId &&
        other.userTypeId == userTypeId &&
        other.companyId == companyId &&
        other.isSwitching == isSwitching;
  }

  @override
  int get hashCode {
    return emailId.hashCode ^
        userId.hashCode ^
        userTypeId.hashCode ^
        companyId.hashCode ^
        isSwitching.hashCode;
  }
}
