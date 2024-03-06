// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:camera/camera.dart';
// import 'package:dialup_mobile_app/main.dart';
// import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:google_ml_vision/google_ml_vision.dart';

// class CameraView extends StatefulWidget {
//   const CameraView({
//     Key? key,
//     required this.title,
//     this.customPaint,
//     this.text,
//     required this.onImage,
//     required this.initialDirection,
//   }) : super(key: key);

//   final String title;
//   final CustomPaint? customPaint;
//   final String? text;
//   final Function(InputImage inputImage) onImage;
//   final CameraLensDirection initialDirection;

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView> {
//   CameraController? _controller;
//   int _cameraIndex = 0;
//   double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
//   bool _changingCameraLens = false;

//   @override
//   void initState() {
//     super.initState();
//     initCameraLens();
//     startLive();
//   }

//   void initCameraLens() {
//     if (cameras.any(
//       (element) =>
//           element.lensDirection == widget.initialDirection &&
//           element.sensorOrientation == 90,
//     )) {
//       _cameraIndex = cameras.indexOf(
//         cameras.firstWhere((element) =>
//             element.lensDirection == widget.initialDirection &&
//             element.sensorOrientation == 90),
//       );
//     } else {
//       _cameraIndex = cameras.indexOf(
//         cameras.firstWhere(
//             (element) => element.lensDirection == widget.initialDirection),
//       );
//     }
//   }

//   Future<void> startLive() async {
//     final camera = cameras[_cameraIndex];
//     _controller = CameraController(
//       camera,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     _controller?.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       _controller?.getMaxZoomLevel().then((value) {
//         maxZoomLevel = value;
//         minZoomLevel = value;
//       });

//       _controller?.startImageStream(_processCameraImage);

//       setState(() {});
//     });
//   }

//   Future<void> _processCameraImage(CameraImage image) async {
//     final WriteBuffer allBytes = WriteBuffer();

//     for (Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }

//     final bytes = allBytes.done().buffer.asUint8List();

//     final Size imageSize = Size(
//       image.width.toDouble(),
//       image.height.toDouble(),
//     );

//     final camera = cameras[_cameraIndex];

//     final imageRotation =
//         InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
//             InputImageRotation.rotation0deg;

//     final inputImageFormat =
//         InputImageFormatValue.fromRawValue(image.format.raw) ??
//             InputImageFormat.nv21;

//     final planeData = image.planes.map((Plane plane) {
//       return InputImagePlaneMetadata(
//         bytesPerRow: plane.bytesPerRow,
//         height: plane.height,
//         width: plane.width,
//       );
//     }).toList();

//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: imageRotation,
//       inputImageFormat: inputImageFormat,
//       planeData: planeData,
//     );

//     final inputImage = InputImage.fromBytes(
//       bytes: bytes,
//       inputImageData: inputImageData,
//     );

//     widget.onImage(inputImage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var scale = (MediaQuery.of(context).size.aspectRatio *
//         _controller!.value.aspectRatio);
//     return Ternary(
//       condition: _controller?.value.isInitialized == false,
//       truthy: Container(),
//       falsy: Container(
//         color: Colors.black,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Transform.scale(
//               scale: (scale < 1) ? 1 / scale : scale,
//               child: Center(
//                 child: _changingCameraLens
//                     ? const Center(
//                         child: Text("Changing Camera Lens"),
//                       )
//                     : CameraPreview(_controller!),
//               ),
//             ),
//             if (widget.customPaint != null) widget.customPaint!,
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> stopLive() async {
//     await _controller?.stopImageStream();
//     await _controller?.dispose();
//     _controller = null;
//   }
// }
