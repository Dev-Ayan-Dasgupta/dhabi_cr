// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart' as regula;

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';

class FaceCompareScreen extends StatefulWidget {
  const FaceCompareScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<FaceCompareScreen> createState() => _FaceCompareScreenState();
}

class _FaceCompareScreenState extends State<FaceCompareScreen> {
  String similarity = "Processing";

  late regula.MatchFacesImage image1;
  late regula.MatchFacesImage image2;

  late Image img1;
  late Image img2;

  late FaceCompareArgumentModel faceCompareArgument;

  int seconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializeArgument();
      await matchfaces();
    });
  }

  void initializeArgument() {
    faceCompareArgument =
        FaceCompareArgumentModel.fromMap(widget.argument as dynamic ?? {});

    image1 = faceCompareArgument.image1;
    img1 = faceCompareArgument.img1;
    image2 = faceCompareArgument.image2;
    img2 = faceCompareArgument.img2;
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
        if (similarity != "Processing") {
          timer.cancel();
        }
      });
    });
  }

  matchfaces() async {
    setState(() {
      similarity = "Processing";
    });
    regula.MatchFacesRequest request = regula.MatchFacesRequest();
    request.images = [image1, image2];
    var value = await regula.FaceSDK.matchFaces(jsonEncode(request));
    var response = regula.MatchFacesResponse.fromJson(json.decode(value));
    var str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
        jsonEncode(response!.results), 0.75);
    regula.MatchFacesSimilarityThresholdSplit? split =
        regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
    setState(() {
      similarity = split!.matchedFaces.isNotEmpty
          ? ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)} %")
          : "error";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 160, width: 100, child: img1),
                  const SizedBox(width: 20),
                  SizedBox(height: 160, width: 100, child: img2),
                ],
              ),
              const SizedBox(height: 20),
              Text("Similarity: $similarity"),
              const SizedBox(height: 20),
              Text("Time taken: ${seconds / 60}:${seconds % 60}"),
            ],
          ),
        ),
      ),
    );
  }
}
