// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class ErrorArgumentModel {
  final bool hasSecondaryButton;
  final String iconPath;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onTap;
  final String buttonTextSecondary;
  final VoidCallback onTapSecondary;
  final Widget? auxWidget;
  ErrorArgumentModel({
    required this.hasSecondaryButton,
    required this.iconPath,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onTap,
    required this.buttonTextSecondary,
    required this.onTapSecondary,
    this.auxWidget,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hasSecondaryButton': hasSecondaryButton,
      'iconPath': iconPath,
      'title': title,
      'message': message,
      'buttonText': buttonText,
      'onTap': onTap,
      'buttonTextSecondary': buttonTextSecondary,
      'onTapSecondary': onTapSecondary,
      'auxWidget': auxWidget,
    };
  }

  factory ErrorArgumentModel.fromMap(Map<String, dynamic> map) {
    return ErrorArgumentModel(
      hasSecondaryButton: map['hasSecondaryButton'] as bool,
      iconPath: map['iconPath'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      buttonText: map['buttonText'] as String,
      onTap: (map['onTap'] as VoidCallback),
      buttonTextSecondary: map['buttonTextSecondary'] as String,
      onTapSecondary: (map['onTapSecondary'] as VoidCallback),
      auxWidget: (map['auxWidget'] as Widget?),
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorArgumentModel.fromJson(String source) =>
      ErrorArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ErrorArgumentModel copyWith({
    bool? hasSecondaryButton,
    String? iconPath,
    String? title,
    String? message,
    String? buttonText,
    VoidCallback? onTap,
    String? buttonTextSecondary,
    VoidCallback? onTapSecondary,
    Widget? auxWidget,
  }) {
    return ErrorArgumentModel(
      hasSecondaryButton: hasSecondaryButton ?? this.hasSecondaryButton,
      iconPath: iconPath ?? this.iconPath,
      title: title ?? this.title,
      message: message ?? this.message,
      buttonText: buttonText ?? this.buttonText,
      onTap: onTap ?? this.onTap,
      buttonTextSecondary: buttonTextSecondary ?? this.buttonTextSecondary,
      onTapSecondary: onTapSecondary ?? this.onTapSecondary,
      auxWidget: auxWidget ?? this.auxWidget,
    );
  }

  @override
  String toString() {
    return 'ErrorArgumentModel(hasSecondaryButton: $hasSecondaryButton, iconPath: $iconPath, title: $title, message: $message, buttonText: $buttonText, onTap: $onTap, buttonTextSecondary: $buttonTextSecondary, onTapSecondary: $onTapSecondary, auxWidget: $auxWidget)';
  }

  @override
  bool operator ==(covariant ErrorArgumentModel other) {
    if (identical(this, other)) return true;

    return other.hasSecondaryButton == hasSecondaryButton &&
        other.iconPath == iconPath &&
        other.title == title &&
        other.message == message &&
        other.buttonText == buttonText &&
        other.onTap == onTap &&
        other.buttonTextSecondary == buttonTextSecondary &&
        other.onTapSecondary == onTapSecondary &&
        other.auxWidget == auxWidget;
  }

  @override
  int get hashCode {
    return hasSecondaryButton.hashCode ^
        iconPath.hashCode ^
        title.hashCode ^
        message.hashCode ^
        buttonText.hashCode ^
        onTap.hashCode ^
        buttonTextSecondary.hashCode ^
        onTapSecondary.hashCode ^
        auxWidget.hashCode;
  }
}
