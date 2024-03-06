import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OnboardingArgumentModel {
  final bool isInitial;
  OnboardingArgumentModel({
    required this.isInitial,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInitial': isInitial,
    };
  }

  factory OnboardingArgumentModel.fromMap(Map<String, dynamic> map) {
    return OnboardingArgumentModel(
      isInitial: map['isInitial'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnboardingArgumentModel.fromJson(String source) =>
      OnboardingArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
