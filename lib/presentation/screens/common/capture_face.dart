// ! Deprecated file/screen

// import 'package:camera/camera.dart';
// import 'package:dialup_mobile_app/data/models/arguments/index.dart';
// import 'package:dialup_mobile_app/main.dart';
// import 'package:dialup_mobile_app/presentation/routers/routes.dart';
// import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
// import 'package:dialup_mobile_app/utils/constants/index.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:system_info_plus/system_info_plus.dart';

// class CaptureFaceScreen extends StatefulWidget {
//   const CaptureFaceScreen({Key? key}) : super(key: key);

//   @override
//   State<CaptureFaceScreen> createState() => _CaptureFaceScreenState();
// }

// class _CaptureFaceScreenState extends State<CaptureFaceScreen> {
//   ResolutionPreset resolutionPreset = ResolutionPreset.high;

//   CameraController _controller = CameraController(
//     const CameraDescription(
//       name: "",
//       lensDirection: CameraLensDirection.front,
//       sensorOrientation: 90,
//     ),
//     ResolutionPreset.high,
//     enableAudio: false,
//   );

//   int? deviceMemory;

//   int _cameraIndex = 0;

//   XFile? capturedImage;

//   bool hasSmiled = false;
//   bool hasBlinked = false;

//   String title = "Smile";
//   String message =
//       "Please place your face inside the oval and smile for us to detect your liveliness.";

//   // ? Create face detector object
//   final FaceDetector faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableContours: true,
//       enableClassification: true,
//       enableLandmarks: true,
//       enableTracking: true,
//       minFaceSize: 0.1,
//       performanceMode: FaceDetectorMode.accurate,
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await getDeviceMemory();
//       initCameraLens();
//       await startLive();
//     });
//   }

//   Future<void> getDeviceMemory() async {
//     deviceMemory = await SystemInfoPlus.physicalMemory; // returns in MB
//     debugPrint("deviceMemory -> $deviceMemory");
//     resolutionPreset = deviceMemory != null
//         ? deviceMemory! <= 3072
//             ? ResolutionPreset.low
//             : ResolutionPreset.high
//         : ResolutionPreset.high;
//   }

//   void initCameraLens() {
//     if (cameras.any(
//       (element) =>
//           element.lensDirection == CameraLensDirection.front &&
//           element.sensorOrientation == 90,
//     )) {
//       _cameraIndex = cameras.indexOf(
//         cameras.firstWhere((element) =>
//             element.lensDirection == CameraLensDirection.front &&
//             element.sensorOrientation == 90),
//       );
//     } else {
//       _cameraIndex = cameras.indexOf(
//         cameras.firstWhere(
//           (element) => element.lensDirection == CameraLensDirection.front,
//         ),
//       );
//     }
//   }

//   Future<void> startLive() async {
//     final camera = cameras[_cameraIndex];

//     // setup camera controller
//     _controller = CameraController(
//       camera,
//       resolutionPreset,
//       enableAudio: false,
//     );

//     // start streaming using camera
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }

//       // process camera image to get an instance of input image
//       _controller.startImageStream(_processCameraImage);

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

//     try {
//       // process the input image
//       final List<Face> faces = await faceDetector.processImage(inputImage);
//       debugPrint("No. of faces detected -> ${faces.length}");

//       debugPrint(
//           "Head turned up or down -> ${faces[0].headEulerAngleX} degrees");
//       debugPrint(
//           "Head turned left or right -> ${faces[0].headEulerAngleY} degrees");
//       debugPrint(
//           "Head turned clockwise or counter-clockwise -> ${faces[0].headEulerAngleZ} degrees");
//       debugPrint("Smiling probability -> ${faces[0].smilingProbability}");
//       debugPrint(
//           "Left eye open probability -> ${faces[0].leftEyeOpenProbability}");
//       debugPrint(
//           "Right eye open probability -> ${faces[0].rightEyeOpenProbability}");

//       if (!hasSmiled) {
//         if (faces[0].smilingProbability != null) {
//           if (faces[0].smilingProbability! >= 0.80) {
//             hasSmiled = true;
//             title = "Blink";
//             message = "Please blink your eyes for us to detect liveliness";
//             setState(() {});
//           }
//         }
//       } else {
//         if ((faces[0].leftEyeOpenProbability != null) &&
//             (faces[0].rightEyeOpenProbability != null)) {
//           if ((faces[0].leftEyeOpenProbability! <= 0.20) ||
//               (faces[0].rightEyeOpenProbability! <= 0.20)) {
//             hasBlinked = true;
//             await Future.delayed(const Duration(milliseconds: 250));

//             if (_controller.value.isInitialized) {
//               await _controller.stopImageStream();
//               if (!_controller.value.isTakingPicture) {
//                 capturedImage = await _controller.takePicture();
//               }
//             }

//             if (capturedImage != null) {
//               if (context.mounted) {
//                 Navigator.pushNamed(
//                   context,
//                   Routes.finalImage,
//                   arguments: FaceImageArgumentModel(
//                     capturedImage: capturedImage!,
//                     resolutionPreset: resolutionPreset,
//                   ).toMap(),
//                 );
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Face Detector Exception -> $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: AppBarLeading(onTap: promptUser),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           CameraPreview(_controller),
//           // Ternary(
//           //   condition: _controller != null,
//           //   truthy:
//           //   falsy: Container(
//           //     width: 100.w,
//           //     height: 100.h,
//           //     color: Colors.black,
//           //   ),
//           // ),
//           ColorFiltered(
//             colorFilter: const ColorFilter.mode(
//               Colors.white,
//               BlendMode.srcOut,
//             ),
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.black,
//                     backgroundBlendMode: BlendMode.dstOut,
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     margin:
//                         EdgeInsets.only(top: (50 / Dimensions.designWidth).w),
//                     height: (500 / Dimensions.designWidth).w,
//                     width: (350 / Dimensions.designWidth).w,
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.all(
//                         Radius.elliptical((200 / Dimensions.designWidth).w,
//                             (300 / Dimensions.designWidth).w),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               const SizeBox(height: 600),
//               Text(
//                 title,
//                 style: TextStyles.primary.copyWith(
//                   color: AppColors.black25,
//                   fontSize: (24 / Dimensions.designWidth).w,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizeBox(height: 7),
//               SizedBox(
//                 width: (300 / Dimensions.designWidth).w,
//                 child: Text(
//                   message,
//                   style: TextStyles.primaryMedium.copyWith(
//                     color: AppColors.black63,
//                     fontSize: (18 / Dimensions.designWidth).w,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizeBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: ((330 / Dimensions.designWidth).w -
//                             (2 - 1) * (5 / Dimensions.designWidth).w) /
//                         2,
//                     height: (3 / Dimensions.designWidth).w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular((5 / Dimensions.designWidth).w),
//                       ),
//                       color: (hasSmiled) ? AppColors.primary : AppColors.dark30,
//                     ),
//                   ),
//                   const SizeBox(
//                     width: 5,
//                   ),
//                   Container(
//                     width: ((330 / Dimensions.designWidth).w -
//                             (2 - 1) * (5 / Dimensions.designWidth).w) /
//                         2,
//                     height: (3 / Dimensions.designWidth).w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular((5 / Dimensions.designWidth).w),
//                       ),
//                       color:
//                           (hasBlinked) ? AppColors.primary : AppColors.dark30,
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void promptUser() {
//     showDialog(
  // barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return CustomDialog(
//           svgAssetPath: ImageConstants.warning,
//           title: labels[250]["labelText"],
//           message:
//               "Going to the previous screen will make you repeat this step.",
//           actionWidget: Column(
//             children: [
//               GradientButton(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//                 text: "Go Back",
//               ),
//               const SizeBox(height: 22),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> stopLive() async {
//     await _controller.stopImageStream();
//     await _controller.dispose();
//     // _controller = null;
//     faceDetector.close();
//   }

//   @override
//   void dispose() {
//     stopLive();
//     super.dispose();
//   }
// }
