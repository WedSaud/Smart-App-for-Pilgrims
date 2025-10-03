import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

class UmrahRitual extends StatefulWidget {
  const UmrahRitual({super.key});

  @override
  State<UmrahRitual> createState() => _UmrahRitualState();
}

class _UmrahRitualState extends State<UmrahRitual> {
  String? _languageCode;
  PDFDocument? _pdfDocument;

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
    _loadPdf();
  }

  Future<String?> _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  Future<void> _loadPdf() async {
    String pdfFile = 'lib/assets/pdf/umrah_english.pdf'; // Default to English
    if (_languageCode == 'en') {
      pdfFile = 'lib/assets/pdf/Umrah-En_final.pdf';
    } else if (_languageCode == 'ur') {
      pdfFile = 'lib/assets/pdf/Umrah-Ur_final.pdf';
    } else if (_languageCode == 'ar') {
      pdfFile = 'lib/assets/pdf/Umrah-Ar_final.pdf';
    }

    // Load the PDF document from asset
    PDFDocument.fromAsset(pdfFile).then((document) {
      setState(() {
        _pdfDocument = document;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context);
    var screensize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations!.ritualhomebtn2,
          style: TextStyle(
              fontSize: screensize.width * 0.04, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screensize.width * 0.03,
                      vertical: screensize.width * 0.01),
                  child: _pdfDocument != null
                      ? PDFViewer(
                          document: _pdfDocument!,
                          lazyLoad: false,
                          scrollDirection: Axis.vertical,
                          zoomSteps: 2,
                        )
                      : Center(
                          child:
                              CircularProgressIndicator()), // Show a loading indicator while the PDF is being loaded
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
