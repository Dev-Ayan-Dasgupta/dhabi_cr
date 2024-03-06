// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WorkflowArgumentModel {
  final String reference;
  final int workflowType;
  WorkflowArgumentModel({
    required this.reference,
    required this.workflowType,
  });

  WorkflowArgumentModel copyWith({
    String? reference,
    int? workflowType,
  }) {
    return WorkflowArgumentModel(
      reference: reference ?? this.reference,
      workflowType: workflowType ?? this.workflowType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reference': reference,
      'workflowType': workflowType,
    };
  }

  factory WorkflowArgumentModel.fromMap(Map<String, dynamic> map) {
    return WorkflowArgumentModel(
      reference: map['reference'] as String,
      workflowType: map['workflowType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkflowArgumentModel.fromJson(String source) =>
      WorkflowArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WorkflowArgumentModel(reference: $reference, workflowType: $workflowType)';

  @override
  bool operator ==(covariant WorkflowArgumentModel other) {
    if (identical(this, other)) return true;

    return other.reference == reference && other.workflowType == workflowType;
  }

  @override
  int get hashCode => reference.hashCode ^ workflowType.hashCode;
}
