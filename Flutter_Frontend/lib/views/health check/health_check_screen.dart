import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/views/health%20check/health_checkup_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthCheckScreen extends StatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  int? heartRate;
  bool isMeasuring = false;
  void _handleBPM(int bpm) {
    setState(() {
      heartRate = bpm; // Store the heart rate result
      isMeasuring = false; // Stop measuring after heart rate is captured
    });
  }

  // Method to start heart rate measurement with camera and flashlight
  Future<void> _startHeartRateMeasurement() async {
    // Request camera permission
    var status = await Permission.camera.request();

    if (status.isGranted) {
      setState(() {
        isMeasuring = true; // Indicate measurement is in progress
      });

      try {
        // Show the HeartBPMDialog to measure the heart rate
        await showDialog(
          context: context,
          builder: (context) => HeartBPMDialog(
            context: context,
            onBPM: _handleBPM, // Callback to handle BPM result
            sampleDelay: 1000 ~/ 30, // Optional: Customize the sample delay
          ),
        );
      } catch (e) {
        print("Error occurred during heart rate measurement: $e");
      } finally {
        // Ensure that we clean up resources
        setState(() {
          isMeasuring = false;
        });

        // Dispose or close any open resources here
        await _releaseCamera();
      }
    } else {
      print("Camera permission is required to measure heart rate.");
    }
  }

// Ensure camera resources are released
  Future<void> _releaseCamera() async {
    try {
      // Replace this with your camera release/close logic if available
      print("Releasing camera resources...");
      // Call any dispose/cleanup methods related to the camera here
    } catch (e) {
      print("Error while releasing camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    var appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations!.healthhomeappbar,
          // Responsive font size
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width * 0.05), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                appLocalizations.healthhomeheading1,
                style: TextStyle(
                  fontSize: width * 0.07, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.015), // Responsive spacing
              Padding(
                padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                child: Text(
                  "${appLocalizations.healthhomeheading2}   \n ${appLocalizations.healthhomeheading3}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: width * 0.045), // Responsive font size
                ),
              ),
              SizedBox(height: height * 0.05),
              Image.asset(
                'lib/assets/images/camera2.jpg',
                width: width * 1.9, // Responsive image size
                height: height * 0.3,
              ),
              SizedBox(height: height * 0.18),
              ElevatedButton(
                onPressed: () async {
                  await _startHeartRateMeasurement();
                  // if (heartRate != null) {
                  //   // Ensure heart rate is measured before navigation
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           HealthCheckupResult(heartrate: heartRate),
                  //     ),
                  //   );
                  // } else {
                  //   // Show an error or retry message if heart rate is still null
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(
                  //           "Heart rate measurement failed. Please try again."),
                  //     ),
                  //   );
                  // }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HealthCheckupResult(heartrate: heartRate)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),

                  padding:
                      EdgeInsets.all(width * 0.07), // Responsive button size
                  backgroundColor: Colors.grey[800],
                ),
                child: Text(
                  appLocalizations.healthhomebtn,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.05, // Responsive font size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
