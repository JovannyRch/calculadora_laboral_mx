import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final toolsRepositoryProvider = Provider<ToolsRepository>((ref) {
  return ToolsRepository(Hive.box<dynamic>('app_settings'));
});

final recentToolsProvider =
    NotifierProvider<RecentToolsController, List<String>>(
      RecentToolsController.new,
    );

class ToolsRepository {
  const ToolsRepository(this._box);

  static const _recentToolsKey = 'recent_tools';

  final Box<dynamic> _box;

  List<String> recentTools() {
    final saved = _box.get(_recentToolsKey);
    if (saved is! List) return [];
    return saved.whereType<String>().toList();
  }

  Future<void> saveRecentTools(List<String> ids) async {
    await _box.put(_recentToolsKey, ids);
  }
}

class RecentToolsController extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.read(toolsRepositoryProvider).recentTools();
  }

  Future<void> markUsed(String id) async {
    final next = [id, ...state.where((item) => item != id)].take(3).toList();
    state = next;
    await ref.read(toolsRepositoryProvider).saveRecentTools(next);
  }
}
