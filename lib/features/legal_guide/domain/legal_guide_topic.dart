enum LegalGuideCategory {
  basics,
  laborRights,
  calculations,
  whatToDo,
  institutions;

  String get label {
    return switch (this) {
      LegalGuideCategory.basics => 'Conceptos básicos',
      LegalGuideCategory.laborRights => 'Derechos laborales',
      LegalGuideCategory.calculations => 'Cálculos',
      LegalGuideCategory.whatToDo => 'Qué hacer',
      LegalGuideCategory.institutions => 'Instituciones',
    };
  }
}

class LegalGuideTopic {
  const LegalGuideTopic({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.tags,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final LegalGuideCategory category;
  final List<String> tags;
  final bool isFavorite;

  LegalGuideTopic copyWith({bool? isFavorite}) {
    return LegalGuideTopic(
      id: id,
      title: title,
      summary: summary,
      content: content,
      category: category,
      tags: tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
