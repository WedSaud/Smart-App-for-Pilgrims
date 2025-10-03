import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/views/Emergency_Contact/clinic_Screen.dart';
import 'package:hajj_and_umrah/views/Emergency_Contact/doctor_Screen.dart';
import 'package:hajj_and_umrah/views/Emergency_Contact/emergency_Screen.dart';
import 'package:hajj_and_umrah/views/Emergency_Contact/hospital_Screen.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white, // Set AppBar color to match the theme
        //elevation: 4, // Slight shadow for depth
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screensize.width * 0.2,
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
          Padding(
            padding:
                EdgeInsets.all(screensize.width * 0.03), // Padding for spacing
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align the content to the left
              children: [
                // Header Title
                SizedBox(
                    height: screensize.height *
                        0.01), // Spacing between title and containers

                Text(
                  'Emergency Contacts',
                  style: TextStyle(
                      fontSize: screensize.width *
                          0.08, // Adjust title size for responsiveness
                      fontWeight: FontWeight.bold,
                      color: Colors.black), // Color for title
                ),
                SizedBox(
                    height: screensize.height *
                        0.08), // Spacing between title and containers

                // First Row: Clinic and Doctor
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Equal space between elements
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ClinicScreen()),
                        );
                      },
                      child: _buildContactCard(
                        screensize,
                        color: const Color.fromARGB(255, 211, 214, 214),
                        label: 'Clinic',
                        icon: Icons.home,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DoctorScreen()),
                        );
                      },
                      child: _buildContactCard(
                        screensize,
                        color: const Color.fromARGB(255, 211, 214, 214),
                        label: 'Doctor',
                        icon: Icons.person,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: screensize.height * 0.34), // Spacing between rows

                // Second Row: Hospital and Emergency
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Equal space between elements
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HospitalScreen()),
                        );
                      },
                      child: _buildContactCard(
                        screensize,
                        color: const Color.fromARGB(255, 211, 214, 214),
                        label: 'Hospital',
                        icon: Icons.home,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmergencyScreen()),
                        );
                      },
                      child: _buildContactCard(
                        screensize,
                        color: const Color.fromARGB(255, 211, 214, 214),
                        label: 'Emergency',
                        icon: Icons.emergency,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create contact cards with consistent styling
  Widget _buildContactCard(
    Size screensize, {
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(
          screensize.width * 0.03), // Padding inside the container
      decoration: BoxDecoration(
        color: color, // Background color for the container
        borderRadius:
            BorderRadius.circular(screensize.width * 0.05), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Subtle shadow for depth
            blurRadius: 6,
            offset: const Offset(0, 2), // Position of shadow
          ),
        ],
      ),
      width: screensize.width * 0.4, // 40% width of the screen
      height: screensize.height * 0.15, // 15% height of the screen
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center content horizontally
        children: [
          Icon(
            icon,
            color: Colors.black, // White icon for contrast
            size: screensize.width * 0.1, // Adjust icon size responsively
          ),
          SizedBox(
              height:
                  screensize.height * 0.01), // Spacing between icon and label
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:
                  screensize.width * 0.05, // Adjust font size responsively
              fontWeight: FontWeight.bold,
              color: Colors.black, // White text for contrast
            ),
          ),
        ],
      ),
    );
  }
}
