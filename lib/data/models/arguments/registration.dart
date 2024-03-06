import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegistrationArgumentModel {
  final bool isInitial;
  final bool isUpdateCorpEmail;
  RegistrationArgumentModel({
    required this.isInitial,
    required this.isUpdateCorpEmail,
  });

  RegistrationArgumentModel copyWith({
    bool? isInitial,
    bool? isUpdateCorpEmail,
  }) {
    return RegistrationArgumentModel(
      isInitial: isInitial ?? this.isInitial,
      isUpdateCorpEmail: isUpdateCorpEmail ?? this.isUpdateCorpEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInitial': isInitial,
      'isUpdateCorpEmail': isUpdateCorpEmail,
    };
  }

  factory RegistrationArgumentModel.fromMap(Map<String, dynamic> map) {
    return RegistrationArgumentModel(
      isInitial: map['isInitial'] as bool,
      isUpdateCorpEmail: map['isUpdateCorpEmail'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistrationArgumentModel.fromJson(String source) =>
      RegistrationArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RegistrationArgumentModel(isInitial: $isInitial, isUpdateCorpEmail: $isUpdateCorpEmail)';

  @override
  bool operator ==(covariant RegistrationArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isInitial == isInitial &&
        other.isUpdateCorpEmail == isUpdateCorpEmail;
  }

  @override
  int get hashCode => isInitial.hashCode ^ isUpdateCorpEmail.hashCode;
}
