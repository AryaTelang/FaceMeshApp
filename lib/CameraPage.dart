// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
//
// import 'package:image/image.dart' as imglib;
// void main() => runApp(MaterialApp(home: HomePage()));
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late List<CameraDescription> cameras;
//   late CameraController cameraController;
//   int selectedCameraIndex = 0;
//  final late InputImage;
//   @override
//   void initState() {
//     super.initState();
//     availableCameras().then((availableCameras) {
//       cameras = availableCameras;
//       if (cameras.isEmpty) {
//         return;
//       }
//
//       // Create and initialize the CameraController
//       _initializeCameraController();
//
//     });
//   }
//
//   void _initializeCameraController() {
//     cameraController =
//         CameraController(cameras[selectedCameraIndex], ResolutionPreset.max);
//     cameraController.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }
//
//
//   @override
//   void dispose() {
//
//     cameraController.dispose();
//     super.dispose();
//   }
//
//   void _toggleCamera() {
//     final newCameraIndex = 1 - selectedCameraIndex;
//     selectedCameraIndex = newCameraIndex;
//     _initializeCameraController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!cameraController.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Jweltry'),
//         ),
//         body: Column(
//           children: [
//             Container(
//                 height: 500,
//                 width: 500,
//                 child: CameraPreview(cameraController)),
//             ElevatedButton(
//               onPressed: _toggleCamera,
//               child: Text('Toggle Camera'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
