import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApplicationAccountArgumentModel {
  final bool isInitial;
  final bool isRetail;
  final int savingsAccountsCreated;
  final int currentAccountsCreated;
  ApplicationAccountArgumentModel({
    required this.isInitial,
    required this.isRetail,
    required this.savingsAccountsCreated,
    required this.currentAccountsCreated,
  });

  ApplicationAccountArgumentModel copyWith({
    bool? isInitial,
    bool? isRetail,
    int? savingsAccountsCreated,
    int? currentAccountsCreated,
  }) {
    return ApplicationAccountArgumentModel(
      isInitial: isInitial ?? this.isInitial,
      isRetail: isRetail ?? this.isRetail,
      savingsAccountsCreated:
          savingsAccountsCreated ?? this.savingsAccountsCreated,
      currentAccountsCreated:
          currentAccountsCreated ?? this.currentAccountsCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInitial': isInitial,
      'isRetail': isRetail,
      'savingsAccountsCreated': savingsAccountsCreated,
      'currentAccountsCreated': currentAccountsCreated,
    };
  }

  factory ApplicationAccountArgumentModel.fromMap(Map<String, dynamic> map) {
    return ApplicationAccountArgumentModel(
      isInitial: map['isInitial'] as bool,
      isRetail: map['isRetail'] as bool,
      savingsAccountsCreated: map['savingsAccountsCreated'] as int,
      currentAccountsCreated: map['currentAccountsCreated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationAccountArgumentModel.fromJson(String source) =>
      ApplicationAccountArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApplicationAccountArgumentModel(isInitial: $isInitial, isRetail: $isRetail, savingsAccountsCreated: $savingsAccountsCreated, currentAccountsCreated: $currentAccountsCreated)';
  }

  @override
  bool operator ==(covariant ApplicationAccountArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isInitial == isInitial &&
        other.isRetail == isRetail &&
        other.savingsAccountsCreated == savingsAccountsCreated &&
        other.currentAccountsCreated == currentAccountsCreated;
  }

  @override
  int get hashCode {
    return isInitial.hashCode ^
        isRetail.hashCode ^
        savingsAccountsCreated.hashCode ^
        currentAccountsCreated.hashCode;
  }
}
