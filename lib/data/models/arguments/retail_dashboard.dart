import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RetailDashboardArgumentModel {
  final String imgUrl;
  final String name;
  final bool isFirst;
  RetailDashboardArgumentModel({
    required this.imgUrl,
    required this.name,
    required this.isFirst,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgUrl': imgUrl,
      'name': name,
      'isFirst': isFirst,
    };
  }

  factory RetailDashboardArgumentModel.fromMap(Map<String, dynamic> map) {
    return RetailDashboardArgumentModel(
      imgUrl: map['imgUrl'] as String,
      name: map['name'] as String,
      isFirst: map['isFirst'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RetailDashboardArgumentModel.fromJson(String source) =>
      RetailDashboardArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  RetailDashboardArgumentModel copyWith({
    String? imgUrl,
    String? name,
    bool? isFirst,
  }) {
    return RetailDashboardArgumentModel(
      imgUrl: imgUrl ?? this.imgUrl,
      name: name ?? this.name,
      isFirst: isFirst ?? this.isFirst,
    );
  }

  @override
  String toString() =>
      'RetailDashboardArgumentModel(imgUrl: $imgUrl, name: $name, isFirst: $isFirst)';

  @override
  bool operator ==(covariant RetailDashboardArgumentModel other) {
    if (identical(this, other)) return true;

    return other.imgUrl == imgUrl &&
        other.name == name &&
        other.isFirst == isFirst;
  }

  @override
  int get hashCode => imgUrl.hashCode ^ name.hashCode ^ isFirst.hashCode;
}
