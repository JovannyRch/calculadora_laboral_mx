import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/features/home/presentation/home_screen.dart';
import 'package:calculadora_laboral_mx/features/onboarding/data/onboarding_repository.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const routeName = 'onboarding';
  static const routePath = '/onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.fact_check_rounded,
                color: context.colors.primary,
                size: 38,
              ),
            ),
            const SizedBox(height: AppSizes.gapXLarge),
            Text(
              'Calcula con orden y respaldo',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.gap),
            Text(
              'Guarda escenarios, consulta conceptos clave y prepara una estimacion laboral clara antes de tomar decisiones.',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSizes.gapXLarge),
            const _OnboardingHighlights(),
            const Spacer(),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(onboardingRepositoryProvider).markCompleted();
                if (context.mounted) context.go(HomeScreen.routePath);
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingHighlights extends StatelessWidget {
  const _OnboardingHighlights();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.calculate_rounded, 'Calculadora guiada'),
      (Icons.history_rounded, 'Historial local'),
      (Icons.menu_book_rounded, 'Guia laboral'),
    ];

    return Column(
      children: [
        for (final item in items) ...[
          SectionCard(
            child: Row(
              children: [
                Icon(item.$1, color: context.colors.secondary),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.$2,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const Icon(Icons.check_circle_rounded, size: 20),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gap),
        ],
      ],
    );
  }
}
