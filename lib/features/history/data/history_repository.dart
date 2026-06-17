import 'package:calculadora_laboral_mx/features/history/domain/saved_labor_calculation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(
    Hive.box<Map<dynamic, dynamic>>('calculation_history'),
  );
});

final historyControllerProvider =
    NotifierProvider<HistoryController, HistoryState>(HistoryController.new);

class HistoryRepository {
  const HistoryRepository(this._box);

  final Box<Map<dynamic, dynamic>> _box;

  List<SavedLaborCalculation> getAll() {
    try {
      final entries = _box.values.map(SavedLaborCalculation.fromMap).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    } catch (error) {
      throw HistoryRepositoryException('No se pudo leer el historial.');
    }
  }

  SavedLaborCalculation? getById(String id) {
    try {
      final map = _box.get(id);
      if (map == null) return null;
      return SavedLaborCalculation.fromMap(map);
    } catch (error) {
      throw HistoryRepositoryException('No se pudo abrir el calculo.');
    }
  }

  Future<void> save(SavedLaborCalculation calculation) async {
    try {
      await _box.put(calculation.id, calculation.toMap());
    } catch (error) {
      throw HistoryRepositoryException('No se pudo guardar el calculo.');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _box.delete(id);
    } catch (error) {
      throw HistoryRepositoryException('No se pudo eliminar el calculo.');
    }
  }
}

class HistoryController extends Notifier<HistoryState> {
  @override
  HistoryState build() {
    return _load();
  }

  Future<void> save(SavedLaborCalculation calculation) async {
    state = state.copyWith(errorMessage: null);
    try {
      await ref.read(historyRepositoryProvider).save(calculation);
      state = _load();
    } on HistoryRepositoryException catch (error) {
      state = state.copyWith(errorMessage: error.message);
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    state = state.copyWith(errorMessage: null);
    try {
      await ref.read(historyRepositoryProvider).delete(id);
      state = _load();
    } on HistoryRepositoryException catch (error) {
      state = state.copyWith(errorMessage: error.message);
      rethrow;
    }
  }

  void refresh() {
    state = _load();
  }

  HistoryState _load() {
    try {
      return HistoryState(
        calculations: ref.read(historyRepositoryProvider).getAll(),
      );
    } on HistoryRepositoryException catch (error) {
      return HistoryState(errorMessage: error.message);
    }
  }
}

class HistoryState {
  const HistoryState({this.calculations = const [], this.errorMessage});

  final List<SavedLaborCalculation> calculations;
  final String? errorMessage;

  HistoryState copyWith({
    List<SavedLaborCalculation>? calculations,
    String? errorMessage,
  }) {
    return HistoryState(
      calculations: calculations ?? this.calculations,
      errorMessage: errorMessage,
    );
  }
}

class HistoryRepositoryException implements Exception {
  const HistoryRepositoryException(this.message);

  final String message;
}
