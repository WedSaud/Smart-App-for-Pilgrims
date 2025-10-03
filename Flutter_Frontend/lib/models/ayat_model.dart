class Ayah {
  final int chapter;
  final int verse;
  final String text;

  Ayah({required this.chapter, required this.verse, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      chapter: json['chapter'],
      verse: json['verse'],
      text: json['text'],
    );
  }
}
