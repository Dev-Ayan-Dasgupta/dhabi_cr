// // ignore_for_file: public_member_api_docs, sort_constructors_first

// ! Deprecated file/screen

// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:dialup_mobile_app/presentation/routers/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';

// import 'package:dialup_mobile_app/data/models/index.dart';
// import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
// import 'package:dialup_mobile_app/utils/constants/index.dart';

// class FinalFaceImageScreen extends StatefulWidget {
//   const FinalFaceImageScreen({
//     Key? key,
//     this.argument,
//   }) : super(key: key);

//   final Object? argument;

//   @override
//   State<FinalFaceImageScreen> createState() => _FinalFaceImageScreenState();
// }

// class _FinalFaceImageScreenState extends State<FinalFaceImageScreen> {
//   XFile? image;

//   late FaceImageArgumentModel faceImageArgument;

//   @override
//   void initState() {
//     super.initState();
//     faceImageArgument = FaceImageArgumentModel.fromMap(
//       widget.argument as dynamic ?? {},
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const AppBarLeading(),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Positioned(
//             top: faceImageArgument.resolutionPreset == ResolutionPreset.low
//                 ? -((167 / Dimensions.designWidth).w)
//                 : -((90 / Dimensions.designWidth).w),
//             child: Transform.scale(
//               scale: 1,
//               child: SizedBox(
//                 width: 100.w,
//                 height: 100.h,
//                 child: Transform.scale(
//                   scaleX: 0.7,
//                   scaleY:
//                       faceImageArgument.resolutionPreset == ResolutionPreset.low
//                           ? 0.45
//                           : 0.625,
//                   child: Image.file(
//                     File(faceImageArgument.capturedImage.path),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//             ),
//           ),
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
//                 Transform.scale(
//                   scale: 0.8,
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Container(
//                       margin:
//                           EdgeInsets.only(top: (0 / Dimensions.designWidth).w),
//                       height: (500 / Dimensions.designWidth).w,
//                       width: (350 / Dimensions.designWidth).w,
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.all(
//                           Radius.elliptical((200 / Dimensions.designWidth).w,
//                               (270 / Dimensions.designWidth).w),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     const SizeBox(height: 510),
//                     Text(
//                       "You look great!",
//                       style: TextStyles.primary.copyWith(
//                         color: AppColors.black25,
//                         fontSize: (24 / Dimensions.designWidth).w,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizeBox(height: 7),
//                     SizedBox(
//                       width: (300 / Dimensions.designWidth).w,
//                       child: Text(
//                         "You can always retake the picture.",
//                         style: TextStyles.primaryMedium.copyWith(
//                           color: AppColors.black63,
//                           fontSize: (18 / Dimensions.designWidth).w,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: (22 / Dimensions.designWidth).w),
//                 child: Column(
//                   children: [
//                     GradientButton(
//                       onTap: () {
//                         Navigator.pushNamed(
//                           context,
//                           Routes.retailOnboardingStatus,
//                           arguments: OnboardingStatusArgumentModel(
//                             stepsCompleted: 2,
//                             isFatca: false,
//                             isPassport: false,
//                             isRetail: true,
//                           ).toMap(),
//                         );
//                       },
//                       text: "Submit",
//                     ),
//                     const SizeBox(height: 10),
//                     SolidButton(
//                       onTap: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, Routes.captureFace, (route) => false);
//                       },
//                       text: "Retake Selfie",
//                       color: AppColors.primaryBright17,
//                       fontColor: AppColors.primary,
//                     ),
//                     const SizeBox(height: 20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
