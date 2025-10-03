import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import Timer class for periodic fetching

// Main Widget
class GuideManagementScreen extends StatefulWidget {
  @override
  _GuideManagementScreenState createState() => _GuideManagementScreenState();
}

class _GuideManagementScreenState extends State<GuideManagementScreen> {
  late ArCoreController arCoreController;
  String trafficCondition = 'loading...';

  @override
  void initState() {
    super.initState();
    getTrafficCondition(); // Initial fetch
    // Set up periodic fetching every 5 seconds
    Timer.periodic(Duration(seconds: 5), (timer) {
      getTrafficCondition();
    });
  }

  // Fetch traffic condition from the backend
  getTrafficCondition() async {
    final response =
        await http.get(Uri.parse('http://192.168.9.170:5000/traffic'));
    if (response.statusCode == 200) {
      setState(() {
        trafficCondition = json.decode(response.body)['traffic'];
      });
    } else {
      throw Exception('Failed to load traffic condition');
    }
  }

  // Handle AR view creation (just display camera)
  _onARViewCreated(ArCoreController controller) {
    arCoreController = controller;
    // No need to create AR objects here, just showing the camera feed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guide Management'),
      ),
      body: Column(
        children: [
          // Show AR camera feed (no AR objects)
          Expanded(
            child: ArCoreView(
              onArCoreViewCreated: (controller) {
                _onARViewCreated(controller);
              },
            ),
          ),
          // Traffic condition indicator
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Traffic Condition: $trafficCondition',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          // Show green/red arrow for traffic
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              trafficCondition == 'high'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 50,
              color: trafficCondition == 'high' ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
