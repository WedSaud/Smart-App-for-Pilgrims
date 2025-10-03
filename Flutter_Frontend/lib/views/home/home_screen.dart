import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/CustomWidgets/CutomTextFormField.dart';
import 'package:hajj_and_umrah/views/Emergency_Contact/emergency_Screen.dart';
import 'package:hajj_and_umrah/views/Ar Guidance/GuideManagementScreen.dart';
import 'package:hajj_and_umrah/views/Ritual%20Guideline/ritual_guideline_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hajj_and_umrah/views/health%20check/health_check_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          // Positioned(
          //   // top: screensize.width * 0.3,
          //   // left: 0,
          //   // right: screensize.width * 0.14,
          //   child: Image.asset(
          //     'lib/assets/images/kaaba.png',
          //     width: screensize.width,
          //     height: screensize.height,
          //     fit: BoxFit.none,
          //   ),
          // ),
          // Main Content
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.all(screensize.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screensize.height * 0.09,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screensize.width * 0.02),
                    child: Text(
                      appLocalizations!.homeheading,
                      style: TextStyle(
                        fontSize: screensize.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.white, // Text color to contrast background
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screensize.height * 0.01,
                  ),
                  CustomTextField(
                    hint: appLocalizations.homesearch,
                    icon: Icons.search,
                    controller: searchcon,
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  _buildOption(
                    FontAwesomeIcons.usersRays,
                    appLocalizations.homebtn1,
                    context,
                    const ARGuidance(),
                    screensize,
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  _buildOption(
                    Icons.menu_book,
                    appLocalizations.homebtn2,
                    context,
                    const RitualGuidelineScreen(),
                    screensize,
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  _buildOption(
                    Icons.warning,
                    appLocalizations.homebtn3,
                    context,
                    const EmergencyScreen(),
                    screensize,
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  _buildOption(
                    Icons.health_and_safety,
                    appLocalizations.homebtn4,
                    context,
                    const HealthCheckScreen(),
                    screensize,
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

Widget _buildOption(IconData icon, String title, BuildContext context,
    Widget? screen, Size screensize) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: screensize.height * 0.01),
    child: GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        }
      },
      child: Card(
        elevation: 3,
        color: Color.fromARGB(255, 191, 194, 193),
        child: Padding(
          padding: EdgeInsets.all(screensize.width * 0.04),
          child: Row(
            children: [
              Icon(icon, size: screensize.width * 0.08, color: Colors.black),
              SizedBox(width: screensize.width * 0.03),
              Text(
                title,
                style: TextStyle(fontSize: screensize.width * 0.045),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
