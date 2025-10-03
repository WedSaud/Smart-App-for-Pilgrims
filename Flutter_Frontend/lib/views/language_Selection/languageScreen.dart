import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/CustomWidgets/CustomButton.dart';
import 'package:hajj_and_umrah/CustomWidgets/languageOption.dart';
import 'package:hajj_and_umrah/views/auth/welcomAndRegister.dart';
import 'package:provider/provider.dart';
import '../../models/language_provider_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hajj_and_umrah/theme/colors/colors.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'en'; // Default language

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        if (languageProvider == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.12),

                // Title
                Align(
                  alignment: selectedLanguage == 'en'
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenSize.width * 0.04,
                        right: screenSize.width * 0.04),
                    child: Text(
                      AppLocalizations.of(context)!.selectAppLanguage,
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.015),

                // Subtitle
                Align(
                  alignment: selectedLanguage == 'en'
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenSize.width * 0.04,
                        right: screenSize.width * 0.04),
                    child: Text(
                      AppLocalizations.of(context)!.choosePreferredLanguage,
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.05),

                // Language Selection Options
                LanguageOptionWidget(
                  languageCode: 'en',
                  languageName: AppLocalizations.of(context)!.english,
                  selectedLanguage: selectedLanguage,
                  onLanguageSelected: (lang) {
                    setState(() {
                      selectedLanguage = lang;
                      languageProvider.changeLanguage(Locale(lang));
                    });
                  },
                ),
                SizedBox(height: height * 0.03),
                LanguageOptionWidget(
                  languageCode: 'ar',
                  languageName: AppLocalizations.of(context)!.arabic,
                  selectedLanguage: selectedLanguage,
                  onLanguageSelected: (lang) {
                    setState(() {
                      selectedLanguage = lang;
                      languageProvider.changeLanguage(Locale(lang));
                    });
                  },
                ),
                SizedBox(height: height * 0.03),
                LanguageOptionWidget(
                  languageCode: 'ur',
                  languageName: AppLocalizations.of(context)!.urdu,
                  selectedLanguage: selectedLanguage,
                  onLanguageSelected: (lang) {
                    setState(() {
                      selectedLanguage = lang;
                      languageProvider.changeLanguage(Locale(lang));
                    });
                  },
                ),

                Spacer(),

                // Continue Button
                SizedBox(
                    width: double.infinity,
                    height: height * 0.079,
                    child: CustomButton(
                        text: AppLocalizations.of(context)!.continueButton,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const WelcomeAndRegisterScreen(),
                            ),
                            (route) => false,
                          );
                        })),

                SizedBox(height: height * 0.04),
              ],
            ),
          ),
        );
      },
    );
  }
}
