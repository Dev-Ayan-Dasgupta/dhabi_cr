import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileArgumentModel {
  final bool isRetail;
  ProfileArgumentModel({
    required this.isRetail,
  });

  ProfileArgumentModel copyWith({
    bool? isRetail,
  }) {
    return ProfileArgumentModel(
      isRetail: isRetail ?? this.isRetail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isRetail': isRetail,
    };
  }

  factory ProfileArgumentModel.fromMap(Map<String, dynamic> map) {
    return ProfileArgumentModel(
      isRetail: map['isRetail'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileArgumentModel.fromJson(String source) =>
      ProfileArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProfileArgumentModel(isRetail: $isRetail)';

  @override
  bool operator ==(covariant ProfileArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isRetail == isRetail;
  }

  @override
  int get hashCode => isRetail.hashCode;
}
