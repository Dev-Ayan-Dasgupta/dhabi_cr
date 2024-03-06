// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProfileUpdatePasswordArgumentModel {
  final bool isRetail;
  final bool isEmailChange;
  final bool isMobileChange;
  final bool isPasswordChange;
  ProfileUpdatePasswordArgumentModel({
    required this.isRetail,
    required this.isEmailChange,
    required this.isMobileChange,
    required this.isPasswordChange,
  });

  ProfileUpdatePasswordArgumentModel copyWith({
    bool? isRetail,
    bool? isEmailChange,
    bool? isMobileChange,
    bool? isPasswordChange,
  }) {
    return ProfileUpdatePasswordArgumentModel(
      isRetail: isRetail ?? this.isRetail,
      isEmailChange: isEmailChange ?? this.isEmailChange,
      isMobileChange: isMobileChange ?? this.isMobileChange,
      isPasswordChange: isPasswordChange ?? this.isPasswordChange,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isRetail': isRetail,
      'isEmailChange': isEmailChange,
      'isMobileChange': isMobileChange,
      'isPasswordChange': isPasswordChange,
    };
  }

  factory ProfileUpdatePasswordArgumentModel.fromMap(Map<String, dynamic> map) {
    return ProfileUpdatePasswordArgumentModel(
      isRetail: map['isRetail'] as bool,
      isEmailChange: map['isEmailChange'] as bool,
      isMobileChange: map['isMobileChange'] as bool,
      isPasswordChange: map['isPasswordChange'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileUpdatePasswordArgumentModel.fromJson(String source) =>
      ProfileUpdatePasswordArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileUpdatePasswordArgumentModel(isRetail: $isRetail, isEmailChange: $isEmailChange, isMobileChange: $isMobileChange, isPasswordChange: $isPasswordChange)';
  }

  @override
  bool operator ==(covariant ProfileUpdatePasswordArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isRetail == isRetail &&
        other.isEmailChange == isEmailChange &&
        other.isMobileChange == isMobileChange &&
        other.isPasswordChange == isPasswordChange;
  }

  @override
  int get hashCode {
    return isRetail.hashCode ^
        isEmailChange.hashCode ^
        isMobileChange.hashCode ^
        isPasswordChange.hashCode;
  }
}
