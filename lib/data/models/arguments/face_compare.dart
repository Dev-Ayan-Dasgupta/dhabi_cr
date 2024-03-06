// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart' as regula;

class FaceCompareArgumentModel {
  final regula.MatchFacesImage image1;
  final Image img1;
  final regula.MatchFacesImage image2;
  final Image img2;
  FaceCompareArgumentModel({
    required this.image1,
    required this.img1,
    required this.image2,
    required this.img2,
  });

  FaceCompareArgumentModel copyWith({
    regula.MatchFacesImage? image1,
    Image? img1,
    regula.MatchFacesImage? image2,
    Image? img2,
  }) {
    return FaceCompareArgumentModel(
      image1: image1 ?? this.image1,
      img1: img1 ?? this.img1,
      image2: image2 ?? this.image2,
      img2: img2 ?? this.img2,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image1': image1,
      'img1': img1,
      'image2': image2,
      'img2': img2,
    };
  }

  factory FaceCompareArgumentModel.fromMap(Map<String, dynamic> map) {
    return FaceCompareArgumentModel(
      image1: (map['image1'] as regula.MatchFacesImage),
      img1: (map['img1'] as Image),
      image2: (map['image2'] as regula.MatchFacesImage),
      img2: (map['img2'] as Image),
    );
  }

  String toJson() => json.encode(toMap());

  factory FaceCompareArgumentModel.fromJson(String source) =>
      FaceCompareArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FaceCompareArgumentModel(image1: $image1, img1: $img1, image2: $image2, img2: $img2)';
  }

  @override
  bool operator ==(covariant FaceCompareArgumentModel other) {
    if (identical(this, other)) return true;

    return other.image1 == image1 &&
        other.img1 == img1 &&
        other.image2 == image2 &&
        other.img2 == img2;
  }

  @override
  int get hashCode {
    return image1.hashCode ^ img1.hashCode ^ image2.hashCode ^ img2.hashCode;
  }
}
