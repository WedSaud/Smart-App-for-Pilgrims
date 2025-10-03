import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

late List<CameraDescription> cameras;

class ARGuidance extends StatefulWidget {
  const ARGuidance({super.key});

  @override
  State<ARGuidance> createState() => _ARGuidanceState();
}

class _ARGuidanceState extends State<ARGuidance> {
  late CameraController _cameraController;
  late PoseDetector _poseDetector;
  bool _isDetecting = false;
  String _trafficGuide = "Loading...";
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    initEverything();
  }

  Future<void> initEverything() async {
    cameras = await availableCameras();
    initCamera();
    initPoseDetector();
  }

  void initPoseDetector() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(),
    );
  }

  void initCamera() async {
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    await _cameraController.initialize();

    setState(() {
      _isCameraReady = true; // <-- Now camera is ready
    });

    _cameraController.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;
        detectPose(image);
      }
    });
  }

  bool hasValidHumanParts(Pose pose) {
    try {
      final landmarks = pose.landmarks;

      final nose = landmarks[PoseLandmarkType.nose];
      final leftEye = landmarks[PoseLandmarkType.leftEye];
      final rightEye = landmarks[PoseLandmarkType.rightEye];
      final leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
      final rightShoulder = landmarks[PoseLandmarkType.rightShoulder];
      final leftWrist = landmarks[PoseLandmarkType.leftWrist];
      final rightWrist = landmarks[PoseLandmarkType.rightWrist];
      final leftElbow = landmarks[PoseLandmarkType.leftElbow];
      final rightElbow = landmarks[PoseLandmarkType.rightElbow];
      final leftChest = landmarks[PoseLandmarkType.leftShoulder];
      final rightChest = landmarks[PoseLandmarkType.rightShoulder];

      bool headDetected = false;
      bool chestDetected = false;
      bool shouldersDetected = false;
      bool handsDetected = false;

      // Head detection: nose + eyes
      if (nose != null && leftEye != null && rightEye != null) {
        if (nose.likelihood > 0.5 &&
            leftEye.likelihood > 0.5 &&
            rightEye.likelihood > 0.5) {
          headDetected = true;
        }
      }

      // Chest detection (approximate: using shoulders)
      if (leftChest != null && rightChest != null) {
        if (leftChest.likelihood > 0.5 && rightChest.likelihood > 0.5) {
          chestDetected = true;
        }
      }

      // Shoulders
      if (leftShoulder != null && rightShoulder != null) {
        if (leftShoulder.likelihood > 0.5 && rightShoulder.likelihood > 0.5) {
          shouldersDetected = true;
        }
      }

      // Hands (wrist or elbow)
      if ((leftWrist != null && leftWrist.likelihood > 0.5) ||
          (rightWrist != null && rightWrist.likelihood > 0.5) ||
          (leftElbow != null && leftElbow.likelihood > 0.5) ||
          (rightElbow != null && rightElbow.likelihood > 0.5)) {
        handsDetected = true;
      }

      // Decision: head+chest OR shoulders OR hands
      if (headDetected || chestDetected || shouldersDetected || handsDetected) {
        return true; // Human detected
      }
    } catch (e) {
      print('Error checking keypoints: $e');
    }
    return false;
  }

  List<Pose> generateFakePoses(int numberOfFakeHumans) {
    List<Pose> fakePoses = [];

    for (int i = 0; i < numberOfFakeHumans; i++) {
      final Map<PoseLandmarkType, PoseLandmark> landmarks = {
        PoseLandmarkType.nose: PoseLandmark(
            type: PoseLandmarkType.nose,
            x: 100 + i * 50.0,
            y: 200,
            z: 0,
            likelihood: 0.9),
        PoseLandmarkType.leftEye: PoseLandmark(
            type: PoseLandmarkType.leftEye,
            x: 90 + i * 50.0,
            y: 190,
            z: 0,
            likelihood: 0.9),
        PoseLandmarkType.rightEye: PoseLandmark(
            type: PoseLandmarkType.rightEye,
            x: 110 + i * 50.0,
            y: 190,
            z: 0,
            likelihood: 0.9),
        PoseLandmarkType.leftShoulder: PoseLandmark(
            type: PoseLandmarkType.leftShoulder,
            x: 80 + i * 50.0,
            y: 250,
            z: 0,
            likelihood: 0.9),
        PoseLandmarkType.rightShoulder: PoseLandmark(
            type: PoseLandmarkType.rightShoulder,
            x: 120 + i * 50.0,
            y: 250,
            z: 0,
            likelihood: 0.9),
      };

      fakePoses.add(Pose(landmarks: landmarks));
    }

    return fakePoses;
  }

  void detectPose(CameraImage image) async {
    try {
      final inputImage = _getInputImage(image);
      final List<Pose> poses = await _poseDetector.processImage(inputImage);
      // 🧪 Simulate 3 additional humans:
      final List<Pose> fakePoses = generateFakePoses(2);

      // Combine real poses + fake poses
      final List<Pose> allPoses = [...poses, ...fakePoses];

      int peopleCount = 0;
      for (Pose pose in allPoses) {
        if (hasValidHumanParts(pose)) {
          peopleCount++;
        }
      }

      String guide = decideTrafficGuide(peopleCount);

      print('Detected people count: $peopleCount');
      setState(() {
        _trafficGuide = guide;
      });
    } catch (e) {
      print("Pose detection error: $e");
    }
    _isDetecting = false;
  }

  InputImage _getInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation0deg,
      format: InputImageFormat.nv21,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: metadata,
    );
  }

  String decideTrafficGuide(int peopleCount) {
    if (peopleCount >= 3) {
      return "Crowded: Move Left or Right";
    } else {
      return "Move Forward";
    }
  }
  //   if (peopleCount > 9) {
  //     return "Heavy Traffic: Move Back";
  //   } else if (peopleCount >= 2 && peopleCount <= 6) {
  //     return "Medium Traffic: Turn Left or Right";
  //   } else {
  //     return "Low Traffic: Move Forward";
  //   }

  @override
  void dispose() {
    _cameraController.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController),
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _trafficGuide,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_trafficGuide == "Move Forward")
            Center(
              child: Icon(
                Icons.arrow_upward,
                color: Colors.green,
                size: 100,
              ),
            )
          else if (_trafficGuide == "Crowded: Move Left or Right")
            Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.4,
                  left: 32,
                  child: Transform.rotate(
                    angle: -0.5, // Rotate left arrow
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.red,
                      size: 80,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.4,
                  right: 32,
                  child: Transform.rotate(
                    angle: 0.5, // Rotate right arrow
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.red,
                      size: 80,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
