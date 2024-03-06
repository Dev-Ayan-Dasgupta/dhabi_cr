import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerifyMobileArgumentModel {
  final bool isBusiness;
  final bool isUpdate;
  final bool isReKyc;
  VerifyMobileArgumentModel({
    required this.isBusiness,
    required this.isUpdate,
    required this.isReKyc,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBusiness': isBusiness,
      'isUpdate': isUpdate,
      'isReKyc': isReKyc,
    };
  }

  factory VerifyMobileArgumentModel.fromMap(Map<String, dynamic> map) {
    return VerifyMobileArgumentModel(
      isBusiness: map['isBusiness'] as bool,
      isUpdate: map['isUpdate'] as bool,
      isReKyc: map['isReKyc'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyMobileArgumentModel.fromJson(String source) =>
      VerifyMobileArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  VerifyMobileArgumentModel copyWith({
    bool? isBusiness,
    bool? isUpdate,
    bool? isReKyc,
  }) {
    return VerifyMobileArgumentModel(
      isBusiness: isBusiness ?? this.isBusiness,
      isUpdate: isUpdate ?? this.isUpdate,
      isReKyc: isReKyc ?? this.isReKyc,
    );
  }

  @override
  String toString() =>
      'VerifyMobileArgumentModel(isBusiness: $isBusiness, isUpdate: $isUpdate, isReKyc: $isReKyc)';

  @override
  bool operator ==(covariant VerifyMobileArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isBusiness == isBusiness &&
        other.isUpdate == isUpdate &&
        other.isReKyc == isReKyc;
  }

  @override
  int get hashCode =>
      isBusiness.hashCode ^ isUpdate.hashCode ^ isReKyc.hashCode;
}
