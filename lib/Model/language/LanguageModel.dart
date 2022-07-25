// ignore_for_file: file_names

class Language {
  final int id;
  final String name;
  final String languageCode;

  Language(this.id, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "English", "en"),
      Language(2, "Malayalam", "ml"),
      Language(3, "Hindi", "hi"),
      Language(4, "Marathi", "mr"),
      Language(5, "Tamil", "ta"),
    ];
  }
}
