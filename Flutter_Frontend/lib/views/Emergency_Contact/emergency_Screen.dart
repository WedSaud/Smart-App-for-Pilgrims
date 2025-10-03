import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_and_umrah/Api%20Handler/ApiHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<Map<String, dynamic>> emergency = [];
  void initState() {
    super.initState();
    getAllemergencys();
  }

  void getAllemergencys() async {
    emergency = await APiHelper().getAllEmergency();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emergency",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              // Title container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                  horizontal: size.width * 0.05,
                ),
                child: Center(
                  child: Text(
                    "Emergency Contacts",
                    style: TextStyle(
                      fontSize: size.width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: emergency.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.02),
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon for clinic
                          Icon(
                            Icons.local_hospital,
                            color: Colors.blue.shade800,
                            size: size.width * 0.08,
                          ),
                          SizedBox(width: size.width * 0.04),
                          // Clinic details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  emergency[index]['name']!,
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.005),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        emergency[index]['contact']!,
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    // Copy icon
                                    IconButton(
                                      icon: Icon(
                                        Icons.copy,
                                        color: Colors.blue,
                                        size: size.width * 0.05,
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                          text: emergency[index]['contact']!,
                                        ));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Phone number copied to clipboard",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Call button
                          IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: Colors.green,
                              size: size.width * 0.06,
                            ),
                            onPressed: () async {
                              final phone = emergency[index]['contact'];
                              final url = 'tel:$phone';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
