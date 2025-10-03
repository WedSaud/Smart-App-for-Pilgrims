import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/CustomWidgets/CutomTextFormField.dart';
import 'package:hajj_and_umrah/views/Quran/quran.dart';
import 'package:hajj_and_umrah/views/Ritual%20Guideline/hajj_ritual.dart';
import 'package:hajj_and_umrah/views/Ritual%20Guideline/umrah_ritual.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RitualGuidelineScreen extends StatefulWidget {
  const RitualGuidelineScreen({super.key});

  @override
  State<RitualGuidelineScreen> createState() => _RitualGuidelineScreenState();
}

class _RitualGuidelineScreenState extends State<RitualGuidelineScreen> {
  String? _languageCode;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    String? languageCode = await _getLanguage();
    setState(() {
      _languageCode = languageCode;
    });
  }

  Future<String?> _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(appLocalizations!.ritualhomeappbar),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Positioned(
          //   top: screensize.width * 0.3,
          //   left: 0,
          //   right: screensize.width * 0.14,
          //   child: Image.asset(
          //     'lib/assets/images/kaaba.png',
          //     width: screensize.width,
          //     height: screensize.height * 0.3,
          //     fit: BoxFit.contain,
          //   ),
          // ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.all(screensize.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                // Center content
                children: [
                  // SizedBox(
                  //   height: screensize.height * 0.09,
                  // ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: _languageCode == 'en'
                          ? MediaQuery.of(context).size.width * 0.12
                          : 0,
                      right: _languageCode != 'en'
                          ? MediaQuery.of(context).size.width * 0.12
                          : 0,
                    ),
                    child: Text(
                      appLocalizations.ritualhomeheading,
                      style: TextStyle(
                          fontSize: screensize.width * 0.07,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  _buildOption(
                    Icons.book,
                    appLocalizations.ritualhomebtn1,
                    context,
                    QuranScreen(),
                    screensize,
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  _buildOption(
                    Icons.mosque_sharp,
                    appLocalizations.ritualhomebtn2,
                    context,
                    UmrahRitual(),
                    screensize,
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  _buildOption(
                    Icons.mosque,
                    appLocalizations.ritualhomebtn3,
                    context,
                    HajjRitual(),
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
