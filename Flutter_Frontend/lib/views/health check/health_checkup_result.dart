import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hajj_and_umrah/views/Emergency_Contact/hospital_Screen.dart';
import 'package:hajj_and_umrah/views/health%20check/emergency_contact_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HealthCheckupResult extends StatefulWidget {
  final int? heartrate; // kept for backward-compat (ignored if realtime works)
  const HealthCheckupResult({super.key, required this.heartrate});

  @override
  State<HealthCheckupResult> createState() => _HealthCheckupResultState();
}

class _HealthCheckupResultState extends State<HealthCheckupResult> {
  CameraController? _cam;
  StreamSubscription? _imageStreamSub;
  bool _torchOn = false;
  bool _initializing = true;
  int _bpm = 0; // live BPM shown
  String? _error;

  // --- PPG processing state
  final List<int> _timestampsMs = []; // detected beat times (ms)
  double _ema = 0; // exponential moving average
  double _emaAlpha = 0.2; // smoothing factor
  double _lastValue = 0;
  bool _wasAbove = false; // for zero-cross/peak detection
  int _lastPeakMs = 0;
  int _minBeatGapMs = 300; // 200 bpm max -> ~300ms min
  final List<double> _window = []; // rolling intensity window
  final int _windowLimit = 90; // ~1.5s at 60 fps

  @override
  void initState() {
    super.initState();
    _initCameraAndStream();
  }

  Future<void> _initCameraAndStream() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() {
          _initializing = false;
          _error = 'Camera permission denied';
          _bpm = widget.heartrate ?? 0;
        });
        return;
      }

      // Initialize camera
      final cams = await availableCameras();
      // prefer back camera
      final desc = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );

      _cam = CameraController(
        desc,
        ResolutionPreset.low, // low is enough, we only need brightness
        imageFormatGroup: ImageFormatGroup.yuv420,
        enableAudio: false,
      );

      await _cam!.initialize();

      // Try to turn torch on (helps PPG)
      try {
        await _cam!.setFlashMode(FlashMode.torch);
        _torchOn = true;
      } catch (_) {
        // Some devices don’t support torch during image stream. Ignore.
        _torchOn = false;
      }

      // Start frame stream
      await _cam!.startImageStream(_onCameraImage);
      setState(() => _initializing = false);
    } catch (e) {
      setState(() {
        _initializing = false;
        _error = 'Camera init error: $e';
        _bpm = widget.heartrate ?? 0;
      });
    }
  }

  // Compute average “red” intensity from YUV420 frame quickly
  // We approximate red using U/V and luminance Y. Fast and “good enough”.
  double _estimateRedFromYUV(CameraImage img) {
    // Use only the Y plane average as a proxy for intensity under finger.
    final yPlane = img.planes[0];
    final bytes = yPlane.bytes;
    int sum = 0;
    for (int i = 0; i < bytes.length; i += 20) {
      // sample ~5% to keep CPU low
      sum += bytes[i];
    }
    final avgY = sum / (bytes.length / 20);
    return avgY.toDouble(); // 0..255 approx
  }

  void _onCameraImage(CameraImage img) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    // 1) signal (proxy of blood volume via intensity changes)
    final signal = _estimateRedFromYUV(img);

    // 2) smooth via EMA
    if (_ema == 0) _ema = signal;
    _ema = _ema * (1 - _emaAlpha) + signal * _emaAlpha;

    // 3) detrend using rolling mean
    _window.add(_ema);
    if (_window.length > _windowLimit) _window.removeAt(0);
    final mean = _window.isEmpty
        ? _ema
        : _window.reduce((a, b) => a + b) / _window.length;
    final value = _ema - mean;

    // 4) Peak detection: look for rising edge crossing 0 with enough gap
    final isAbove = value > 0;
    if (!_wasAbove && isAbove) {
      // candidate peak around zero-cross; refine with “since last” gap
      if (nowMs - _lastPeakMs > _minBeatGapMs) {
        _lastPeakMs = nowMs;
        _timestampsMs.add(nowMs);
        // keep last ~12s worth of peaks
        while (
            _timestampsMs.isNotEmpty && nowMs - _timestampsMs.first > 12000) {
          _timestampsMs.removeAt(0);
        }
        _updateBpmFromPeaks();
      }
    }
    _wasAbove = isAbove;
    _lastValue = value;
  }

  void _updateBpmFromPeaks() {
    if (_timestampsMs.length < 2) return;
    // compute average IBI (inter-beat interval)
    double sum = 0;
    for (int i = 1; i < _timestampsMs.length; i++) {
      sum += (_timestampsMs[i] - _timestampsMs[i - 1]).toDouble();
    }
    final avgIbiMs = sum / (_timestampsMs.length - 1);
    if (avgIbiMs <= 0) return;
    final bpm = (60000.0 / avgIbiMs).clamp(35.0, 220.0).round();
    if (mounted) setState(() => _bpm = bpm);
  }

  @override
  void dispose() {
    _imageStreamSub?.cancel();
    if (_cam != null) {
      // Stop stream first
      if (_cam!.value.isStreamingImages) {
        _cam!.stopImageStream();
      }
      // Turn torch off if we turned it on
      if (_torchOn) {
        _cam!.setFlashMode(FlashMode.off).catchError((_) {});
      }
      _cam!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final screenWidth = screensize.width;
    final screenHeight = screensize.height;
    final textSize = screenWidth * 0.06;
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.healthresultappbar),
        backgroundColor: const Color.fromARGB(255, 213, 219, 216),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: screensize.width * 0.1,
            right: screensize.width * 0.14,
            child: Image.asset(
              'lib/assets/images/kaaba.png',
              width: screensize.width,
              height: screensize.height,
              fit: BoxFit.none,
            ),
          ),

          // Camera preview (small, optional). User should cover lens with finger.
          if (_cam != null && _cam!.value.isInitialized)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: SizedBox(
                  width: screenWidth * 0.35,
                  height: screenWidth * 0.35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Colors.black54, BlendMode.multiply),
                      child: CameraPreview(_cam!),
                    ),
                  ),
                ),
              ),
            ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.20),
                Text(
                  appLocalizations.healthresultheading1,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Status / error
                if (_initializing)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Initializing camera… Please cover the camera lens with your fingertip.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  )
                else if (_error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red, fontSize: screenWidth * 0.04),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.13,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 191, 194, 193),
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      border: Border.all(
                          color: const Color.fromARGB(255, 151, 145, 145)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite,
                            color: Colors.black, size: screenWidth * 0.08),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          "${appLocalizations.healthresultheading2} ${_bpm > 0 ? _bpm : (widget.heartrate ?? 0)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Icon(
                          _bpm >= 100
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: _bpm >= 100 ? Colors.red : Colors.green,
                          size: screenWidth * 0.08,
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: screenHeight * 0.26),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HospitalScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 191, 194, 193),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.03,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                  child: Text(
                    appLocalizations.healthresultbtn1,
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.04),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EmergencyContactScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 191, 194, 193),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.16,
                      vertical: screenHeight * 0.03,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                  child: Text(
                    appLocalizations.healthresultbtn2,
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.04),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Quick hint
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Text(
                    "Tip: Cover the rear camera and flash completely with your fingertip and stay still for 10–15 seconds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: screenWidth * 0.035, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
