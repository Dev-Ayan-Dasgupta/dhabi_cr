import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreateAccountArgumentModel {
  final String email;
  final bool isRetail;
  final int userTypeId;
  final int companyId;
  CreateAccountArgumentModel({
    required this.email,
    required this.isRetail,
    required this.userTypeId,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'isRetail': isRetail,
      'userTypeId': userTypeId,
      'companyId': companyId,
    };
  }

  factory CreateAccountArgumentModel.fromMap(Map<String, dynamic> map) {
    return CreateAccountArgumentModel(
      email: map['email'] as String,
      isRetail: map['isRetail'] as bool,
      userTypeId: map['userTypeId'] as int,
      companyId: map['companyId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAccountArgumentModel.fromJson(String source) =>
      CreateAccountArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  CreateAccountArgumentModel copyWith({
    String? email,
    bool? isRetail,
    int? userTypeId,
    int? companyId,
  }) {
    return CreateAccountArgumentModel(
      email: email ?? this.email,
      isRetail: isRetail ?? this.isRetail,
      userTypeId: userTypeId ?? this.userTypeId,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  String toString() {
    return 'CreateAccountArgumentModel(email: $email, isRetail: $isRetail, userTypeId: $userTypeId, companyId: $companyId)';
  }

  @override
  bool operator ==(covariant CreateAccountArgumentModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.isRetail == isRetail &&
        other.userTypeId == userTypeId &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        isRetail.hashCode ^
        userTypeId.hashCode ^
        companyId.hashCode;
  }
}
