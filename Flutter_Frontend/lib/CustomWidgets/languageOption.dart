import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/models/language_provider_model.dart';

import 'package:provider/provider.dart';

class LanguageOptionWidget extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final String selectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguageOptionWidget({
    Key? key,
    required this.languageCode,
    required this.languageName,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.all(screensize.width * 0.03),
      child: InkWell(
        onTap: () {
          onLanguageSelected(languageCode);
          languageProvider.changeLanguage(Locale(languageCode));
        },
        child: Container(
          decoration: BoxDecoration(
            color: selectedLanguage == languageCode
                ? const Color.fromARGB(255, 218, 218, 218)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: screensize.width * 0.02,
              color: selectedLanguage == languageCode
                  ? const Color.fromARGB(255, 151, 145, 145)
                  : const Color.fromARGB(255, 191, 194, 193),
            ),
          ),
          child: ListTile(
            title: Text(
              languageName,
              style: TextStyle(
                fontSize: screensize.width * 0.05,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
