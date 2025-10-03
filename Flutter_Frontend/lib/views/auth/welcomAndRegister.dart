import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/CustomWidgets/CustomButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hajj_and_umrah/views/auth/signin.dart';
import 'package:hajj_and_umrah/views/auth/signup.dart';
//import 'package:provider/provider.dart';
//import 'package:hajj_and_umrah/models/language_provider_model.dart';

class WelcomeAndRegisterScreen extends StatelessWidget {
  const WelcomeAndRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var appLocalizations = AppLocalizations.of(context);
   // var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenSize.width * 0.3,
            left: 0,
            right: screenSize.width * 0.14,
            child: Image.asset(
              'lib/assets/images/kaaba.png',
              width: screenSize.width,
              height: screenSize.height * 0.5,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: screenSize.height * 0.7,
            left: screenSize.width * 0.06,
            right: screenSize.width * 0.06,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: screenSize.width * 0.06,
                      right: screenSize.width * 0.06),
                  child: Text(
                    appLocalizations!.title,
                    style: TextStyle(
                        fontSize: screenSize.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenSize.width * 0.06,
                      right: screenSize.width * 0.06),
                  child: Text(
                    appLocalizations.subtitle,
                    style: TextStyle(
                        color: Colors.black, fontSize: screenSize.width * 0.03),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: appLocalizations.signinbutton,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: appLocalizations.signupbutton,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                // DropdownButton<Locale>(
                //   value: languageProvider.locale,
                //   onChanged: (Locale? newLocale) {
                //     if (newLocale != null) {
                //       languageProvider.changeLanguage(newLocale);
                //     }
                //   },
                //   items: AppLocalizations.supportedLocales.map((Locale locale) {
                //     return DropdownMenuItem(
                //       value: locale,
                //       child: Text(locale.languageCode == 'en' ? 'English' : 'العربية'),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
