import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_and_umrah/Api%20Handler/ApiHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  List<Map<String, dynamic>> hospitals = [];

  @override
  void initState() {
    super.initState();
    getAllHospitals();
  }

  void getAllHospitals() async {
    try {
      hospitals = await APiHelper().getNearestHospitals();
      setState(() {});
    } catch (e) {
      print("Error fetching hospitals: $e");
    }
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
          onPressed: () => Navigator.pop(context),
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                      horizontal: size.width * 0.05,
                    ),
                    child: Center(
                      child: Text(
                        "Hospital Contacts",
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
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = hospitals[index];
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
                              Icon(
                                Icons.local_hospital,
                                color: Colors.red.shade700,
                                size: size.width * 0.08,
                              ),
                              SizedBox(width: size.width * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hospital['name'],
                                      style: TextStyle(
                                        fontSize: size.width * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.005),
                                    if (hospital['distance'] != null)
                                      GestureDetector(
                                        onTap: () {
                                          final lat = hospital['latitude'];
                                          final lon = hospital['longitude'];
                                          final url =
                                              'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon';
                                          launchUrl(Uri.parse(url));
                                        },
                                        child: Text(
                                          "${hospital['distance'].toStringAsFixed(2)} km away",
                                          style: TextStyle(
                                            fontSize: size.width * 0.035,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            hospital['contact'],
                                            style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.copy,
                                            color: Colors.blue,
                                            size: size.width * 0.05,
                                          ),
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                  text: hospital['contact']),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text("Phone number copied"),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                  size: size.width * 0.06,
                                ),
                                onPressed: () async {
                                  final phone = hospital['contact'];
                                  final tel = 'tel:$phone';
                                  if (await canLaunchUrl(Uri.parse(tel))) {
                                    await launchUrl(Uri.parse(tel));
                                  } else {
                                    throw 'Could not launch $tel';
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

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hajj_and_umrah/Api%20Handler/ApiHelper.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HospitalScreen extends StatefulWidget {
//   const HospitalScreen({super.key});

//   @override
//   State<HospitalScreen> createState() => _HospitalScreenState();
// }

// class _HospitalScreenState extends State<HospitalScreen> {
//   List<Map<String, dynamic>> hospital = [];
//   void initState() {
//     super.initState();
//     getAllhospitals();
//   }

//   void getAllhospitals() async {
//     hospital = await APiHelper().getAllHospital();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Emergency",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
//           child: Column(
//             children: [
//               // Title container
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(
//                   vertical: size.height * 0.02,
//                   horizontal: size.width * 0.05,
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Hospital Contacts",
//                     style: TextStyle(
//                       fontSize: size.width * 0.08,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: hospital.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: size.height * 0.02),
//                     child: Container(
//                       padding: EdgeInsets.all(size.width * 0.04),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 5,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           // Icon for clinic
//                           Icon(
//                             Icons.local_hospital,
//                             color: Colors.blue.shade800,
//                             size: size.width * 0.08,
//                           ),
//                           SizedBox(width: size.width * 0.04),
//                           // Clinic details
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   hospital[index]['name']!,
//                                   style: TextStyle(
//                                     fontSize: size.width * 0.045,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: size.height * 0.005),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         hospital[index]['contact']!,
//                                         style: TextStyle(
//                                           fontSize: size.width * 0.04,
//                                           color: Colors.grey.shade600,
//                                         ),
//                                       ),
//                                     ),
//                                     // Copy icon
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.copy,
//                                         color: Colors.blue,
//                                         size: size.width * 0.05,
//                                       ),
//                                       onPressed: () {
//                                         Clipboard.setData(ClipboardData(
//                                           text: hospital[index]['contact']!,
//                                         ));
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                               "Phone number copied to clipboard",
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Call button
//                           IconButton(
//                             icon: Icon(
//                               Icons.phone,
//                               color: Colors.green,
//                               size: size.width * 0.06,
//                             ),
//                             onPressed: () async {
//                               final phone = hospital[index]['contact'];
//                               final url = 'tel:$phone';
//                               if (await canLaunch(url)) {
//                                 await launch(url);
//                               } else {
//                                 throw 'Could not launch $url';
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
