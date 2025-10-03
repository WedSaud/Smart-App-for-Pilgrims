import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_and_umrah/Api%20Handler/ApiHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  List<Map<String, dynamic>> clinic = [];
  void initState() {
    super.initState();
    getAllclinics();
  }

  // void getAllclinics() async {
  //   clinic = await APiHelper().getAllClinic();
  //   setState(() {});
  // }
  void getAllclinics() async {
    clinic = await APiHelper().getNearestClinics();
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
      body: Stack(
        children: [
          Positioned(
            top: size.width * 0.3,
            left: 0,
            right: size.width * 0.14,
            child: Image.asset(
              'lib/assets/images/kaaba.png',
              width: size.width,
              height: size.height * 0.5,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
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
                        "Clinic Contacts",
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
                    itemCount: clinic.length,
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
                                    // Text(
                                    //   clinic[index]['name']!,
                                    //   style: TextStyle(
                                    //     fontSize: size.width * 0.045,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          clinic[index]['name']!,
                                          style: TextStyle(
                                            fontSize: size.width * 0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.005),
                                        GestureDetector(
                                          onTap: () {
                                            final lat =
                                                clinic[index]['latitude'];
                                            final lon =
                                                clinic[index]['longitude'];
                                            final mapsUrl =
                                                "https://www.google.com/maps/dir/?api=1&destination=$lat,$lon";
                                            launchUrl(Uri.parse(mapsUrl));
                                          },
                                          child: Text(
                                            "${clinic[index]['distance'].toStringAsFixed(2)} km away",
                                            style: TextStyle(
                                              fontSize: size.width * 0.035,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.005),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            clinic[index]['contact']!,
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
                                              text: clinic[index]['contact']!,
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
                                  final phone = clinic[index]['phone'];
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
        ],
      ),
    );
  }
}
