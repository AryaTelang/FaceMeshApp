import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';

import 'detector_view.dart';
import 'face_mesh_detector_painter.dart';

class FaceMeshDetectorView extends StatefulWidget {
  const FaceMeshDetectorView({super.key});

  @override
  State<FaceMeshDetectorView> createState() => _FaceMeshDetectorViewState();
}

class _FaceMeshDetectorViewState extends State<FaceMeshDetectorView> {
  final FaceMeshDetector _meshDetector =
      FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  double leftEyeX = 0;
  late double leftEyeY = 0;
  late double rightEyeX = 0;
  late double rightEyeY = 0;
  late double lowerLipY=0;
  late double noseBridgeX=0;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _meshDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(title: const Text('Under construction')),
        body: const Center(
            child: Text(
          'Not implemented yet for iOS :(\nTry Android',
          textAlign: TextAlign.center,
        )),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            SizedBox(
              height: 550,
              child: DetectorView(
                title: 'Face Mesh Detector',
                customPaint: _customPaint,
                text: _text,
                onImage: _processImage,
                initialCameraLensDirection: _cameraLensDirection,
                onCameraLensDirectionChanged: (value) =>
                    _cameraLensDirection = value,
              ),
            ),
            Align(
                alignment: Alignment(-lowerLipY/screenHeight,noseBridgeX/screenWidth),
                child:
                    Image.asset("assets/images/necklace-removebg-preview.png")),
          ]),
          SizedBox(
            height: 100,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Card(
                      color: Colors.grey,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/necklace.png",
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });

    final meshes = await _meshDetector.processImage(inputImage);
    CustomPainter? painter;

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      painter = FaceMeshDetectorPainter(
        meshes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );

      for (final mesh in meshes) {
        final List<FaceMeshPoint> points = mesh.points;

        const int leftEyeIndex = 350;
        const int rightEyeIndex = 145;
        const int lowerLipIndex=16;
        const int noseBridgeIndex=16;
        final FaceMeshPoint leftEyePoint =
            points.firstWhere((point) => point.index == leftEyeIndex);
        final FaceMeshPoint rightEyePoint =
            points.firstWhere((point) => point.index == rightEyeIndex);
        final FaceMeshPoint lowerLipPoint= points.firstWhere((point) => point.index == lowerLipIndex);
        final FaceMeshPoint noseBridgePoint= points.firstWhere((point) => point.index == noseBridgeIndex);
      noseBridgeX=noseBridgePoint.x;
        lowerLipY=lowerLipPoint.y;
        leftEyeX = leftEyePoint.x;
        leftEyeY = leftEyePoint.y;
        rightEyeX = rightEyePoint.x;
        rightEyeY = rightEyePoint.y;
      }
    } else {
      String text = 'Face meshes found: ${meshes.length}\n\n';
      for (final mesh in meshes) {
        text += 'face: ${mesh.boundingBox}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      painter = null;
    }

    // Set the custom painter
    _customPaint = CustomPaint(painter: painter);

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
