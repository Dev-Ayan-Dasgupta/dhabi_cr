// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:camera/camera.dart';

class FaceImageArgumentModel {
  final XFile capturedImage;
  final ResolutionPreset resolutionPreset;
  FaceImageArgumentModel({
    required this.capturedImage,
    required this.resolutionPreset,
  });

  FaceImageArgumentModel copyWith({
    XFile? capturedImage,
    ResolutionPreset? resolutionPreset,
  }) {
    return FaceImageArgumentModel(
      capturedImage: capturedImage ?? this.capturedImage,
      resolutionPreset: resolutionPreset ?? this.resolutionPreset,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'capturedImage': capturedImage,
      'resolutionPreset': resolutionPreset,
    };
  }

  factory FaceImageArgumentModel.fromMap(Map<String, dynamic> map) {
    return FaceImageArgumentModel(
      capturedImage: (map['capturedImage'] as XFile),
      resolutionPreset: (map['resolutionPreset'] as ResolutionPreset),
    );
  }

  String toJson() => json.encode(toMap());

  factory FaceImageArgumentModel.fromJson(String source) =>
      FaceImageArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FaceImageArgumentModel(capturedImage: $capturedImage, resolutionPreset: $resolutionPreset)';

  @override
  bool operator ==(covariant FaceImageArgumentModel other) {
    if (identical(this, other)) return true;

    return other.capturedImage == capturedImage &&
        other.resolutionPreset == resolutionPreset;
  }

  @override
  int get hashCode => capturedImage.hashCode ^ resolutionPreset.hashCode;
}
