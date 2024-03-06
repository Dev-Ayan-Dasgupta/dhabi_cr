import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SetPasswordArgumentModel {
  final bool fromTempPassword;
  final int userTypeId;
  final int companyId;
  SetPasswordArgumentModel({
    required this.fromTempPassword,
    required this.userTypeId,
    required this.companyId,
  });

  SetPasswordArgumentModel copyWith({
    bool? fromTempPassword,
    int? userTypeId,
    int? companyId,
  }) {
    return SetPasswordArgumentModel(
      fromTempPassword: fromTempPassword ?? this.fromTempPassword,
      userTypeId: userTypeId ?? this.userTypeId,
      companyId: companyId ?? this.companyId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromTempPassword': fromTempPassword,
      'userTypeId': userTypeId,
      'companyId': companyId,
    };
  }

  factory SetPasswordArgumentModel.fromMap(Map<String, dynamic> map) {
    return SetPasswordArgumentModel(
      fromTempPassword: map['fromTempPassword'] as bool,
      userTypeId: map['userTypeId'] as int,
      companyId: map['companyId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SetPasswordArgumentModel.fromJson(String source) =>
      SetPasswordArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SetPasswordArgumentModel(fromTempPassword: $fromTempPassword, userTypeId: $userTypeId, companyId: $companyId)';

  @override
  bool operator ==(covariant SetPasswordArgumentModel other) {
    if (identical(this, other)) return true;

    return other.fromTempPassword == fromTempPassword &&
        other.userTypeId == userTypeId &&
        other.companyId == companyId;
  }

  @override
  int get hashCode =>
      fromTempPassword.hashCode ^ userTypeId.hashCode ^ companyId.hashCode;
}
