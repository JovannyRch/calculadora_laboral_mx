import 'package:calculadora_laboral_mx/features/legal_guide/data/legal_guide_topics.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/domain/legal_guide_topic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final legalGuideRepositoryProvider = Provider<LegalGuideRepository>((ref) {
  return LegalGuideRepository(Hive.box<dynamic>('app_settings'));
});

final legalGuideControllerProvider =
    NotifierProvider<LegalGuideController, LegalGuideState>(
      LegalGuideController.new,
    );

class LegalGuideRepository {
  const LegalGuideRepository(this._box);

  static const _favoritesKey = 'legal_guide_favorites';

  final Box<dynamic> _box;

  Set<String> favoriteIds() {
    final saved = _box.get(_favoritesKey);
    if (saved is! List) return {};
    return saved.whereType<String>().toSet();
  }

  Future<void> saveFavoriteIds(Set<String> ids) async {
    await _box.put(_favoritesKey, ids.toList());
  }
}

class LegalGuideController extends Notifier<LegalGuideState> {
  @override
  LegalGuideState build() {
    return LegalGuideState(
      favoriteIds: ref.read(legalGuideRepositoryProvider).favoriteIds(),
    );
  }

  List<LegalGuideTopic> topics() {
    return legalGuideTopics
        .map((topic) => topic.copyWith(isFavorite: state.isFavorite(topic.id)))
        .toList();
  }

  List<LegalGuideTopic> filteredTopics() {
    final query = state.query.trim().toLowerCase();
    return topics().where((topic) {
      final matchesQuery =
          query.isEmpty ||
          topic.title.toLowerCase().contains(query) ||
          topic.summary.toLowerCase().contains(query) ||
          topic.tags.any((tag) => tag.toLowerCase().contains(query));
      final matchesCategory =
          state.category == null || topic.category == state.category;
      final matchesFavorite = !state.onlyFavorites || topic.isFavorite;
      return matchesQuery && matchesCategory && matchesFavorite;
    }).toList();
  }

  LegalGuideTopic? topicById(String id) {
    for (final topic in topics()) {
      if (topic.id == id) return topic;
    }
    return null;
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCategory(LegalGuideCategory? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void setOnlyFavorites(bool onlyFavorites) {
    state = state.copyWith(onlyFavorites: onlyFavorites);
  }

  Future<void> toggleFavorite(String topicId) async {
    final ids = {...state.favoriteIds};
    if (!ids.remove(topicId)) ids.add(topicId);
    state = state.copyWith(favoriteIds: ids);
    await ref.read(legalGuideRepositoryProvider).saveFavoriteIds(ids);
  }
}

class LegalGuideState {
  const LegalGuideState({
    this.favoriteIds = const {},
    this.query = '',
    this.category,
    this.onlyFavorites = false,
  });

  final Set<String> favoriteIds;
  final String query;
  final LegalGuideCategory? category;
  final bool onlyFavorites;

  bool isFavorite(String topicId) => favoriteIds.contains(topicId);

  LegalGuideState copyWith({
    Set<String>? favoriteIds,
    String? query,
    LegalGuideCategory? category,
    bool clearCategory = false,
    bool? onlyFavorites,
  }) {
    return LegalGuideState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      query: query ?? this.query,
      category: clearCategory ? null : category ?? this.category,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}
