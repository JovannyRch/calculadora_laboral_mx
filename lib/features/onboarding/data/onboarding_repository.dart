import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(Hive.box<dynamic>('app_settings'));
});

class OnboardingRepository {
  const OnboardingRepository(this._box);

  static const _completedKey = 'onboarding_completed';

  final Box<dynamic> _box;

  bool get isCompleted => _box.get(_completedKey, defaultValue: false) as bool;

  Future<void> markCompleted() async {
    await _box.put(_completedKey, true);
  }
}
