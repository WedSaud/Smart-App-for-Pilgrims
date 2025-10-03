import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  PDFDocument? _pdfDocument;
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
    await loadDocument();
  }

  Future<String?> _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  Future<void> loadDocument() async {
    String pdfFile =
        'lib/assets/pdf/Quran_En_compressed.pdf'; // Default to English
    if (_languageCode == 'en') {
      pdfFile = 'lib/assets/pdf/Quran_En_compressed.pdf';
    } else if (_languageCode == 'ur') {
      pdfFile = 'lib/assets/pdf/Quran_ur.pdf';
    } else if (_languageCode == 'ar') {
      pdfFile = 'lib/assets/pdf/Quran_Ar.pdf';
    }

    try {
      PDFDocument document = await PDFDocument.fromAsset(pdfFile);
      setState(() {
        _pdfDocument = document;
      });
    } catch (e) {
      print("Error loading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📖 القرآن الكريم")),
      body: _pdfDocument == null
          ? const Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: _pdfDocument!,
              lazyLoad: true, // Enable lazy loading for better performance
              scrollDirection: Axis.vertical, // Vertical scrolling
              zoomSteps: 2, // Enable zoom functionality
            ),
    );
  }
}
