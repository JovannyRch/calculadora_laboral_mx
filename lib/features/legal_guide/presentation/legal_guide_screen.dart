import 'package:calculadora_laboral_mx/app/app_config.dart';
import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/data/legal_guide_repository.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/domain/legal_guide_topic.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/presentation/legal_guide_topic_screen.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/presentation/official_sources_screen.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/ad_banner.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LegalGuideScreen extends ConsumerWidget {
  const LegalGuideScreen({super.key});

  static const routeName = 'legal-guide';
  static const routeSegment = 'legal-guide';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(legalGuideControllerProvider);
    final controller = ref.read(legalGuideControllerProvider.notifier);
    final topics = controller.filteredTopics();

    return AppScaffold(
      title: 'Guía laboral',
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          const _GuideNotice(),
          const SizedBox(height: AppSizes.gap),
          const _OfficialSourcesButton(),
          const SizedBox(height: AppSizes.gap),
          const AppAdBanner(adUnitId: AppConfig.bannerGuideAdUnitId),
          const SizedBox(height: AppSizes.gap),
          _SearchBox(onChanged: controller.setQuery),
          const SizedBox(height: AppSizes.gap),
          _Filters(
            state: state,
            onFavoritesChanged: controller.setOnlyFavorites,
            onCategoryChanged: (category) {
              if (category == null) {
                controller.setCategory(null);
              } else {
                controller.setCategory(category);
              }
            },
          ),
          const SizedBox(height: AppSizes.gapLarge),
          if (topics.isEmpty)
            const _EmptyResults()
          else
            for (final topic in topics) ...[
              _TopicCard(topic: topic),
              const SizedBox(height: AppSizes.gap),
            ],
        ],
      ),
    );
  }
}

class _GuideNotice extends StatelessWidget {
  const _GuideNotice();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: context.colors.primary),
          const SizedBox(width: AppSizes.gap),
          Expanded(
            child: Text(
              'Información con fines orientativos. Esta app no es autoridad '
              'oficial ni sustituye asesoria laboral individual.',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialSourcesButton extends StatelessWidget {
  const _OfficialSourcesButton();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: () => context.goNamed(OfficialSourcesScreen.routeName),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, color: context.colors.primary),
          const SizedBox(width: AppSizes.gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ver fuentes oficiales',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ley Federal del Trabajo, PROFEDET y STPS.',
                  style: TextStyle(
                    color: context.colors.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Buscar temas',
        prefixIcon: Icon(Icons.search_rounded),
      ),
      onChanged: onChanged,
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.state,
    required this.onFavoritesChanged,
    required this.onCategoryChanged,
  });

  final LegalGuideState state;
  final ValueChanged<bool> onFavoritesChanged;
  final ValueChanged<LegalGuideCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.gapSmall,
      runSpacing: AppSizes.gapSmall,
      children: [
        FilterChip(
          selected: state.onlyFavorites,
          avatar: const Icon(Icons.star_rounded),
          label: const Text('Favoritos'),
          onSelected: onFavoritesChanged,
        ),
        ChoiceChip(
          selected: state.category == null,
          label: const Text('Todos'),
          onSelected: (_) => onCategoryChanged(null),
        ),
        for (final category in LegalGuideCategory.values)
          ChoiceChip(
            selected: state.category == category,
            label: Text(category.label),
            onSelected: (_) => onCategoryChanged(category),
          ),
      ],
    );
  }
}

class _TopicCard extends ConsumerWidget {
  const _TopicCard({required this.topic});

  final LegalGuideTopic topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      onTap: () {
        context.goNamed(
          LegalGuideTopicScreen.routeName,
          pathParameters: {'topicId': topic.id},
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _iconFor(topic.category),
              color: context.colors.secondary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.category.label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topic.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  topic.summary,
                  style: TextStyle(
                    color: context.colors.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: topic.isFavorite ? 'Quitar favorito' : 'Guardar favorito',
            onPressed: () {
              ref
                  .read(legalGuideControllerProvider.notifier)
                  .toggleFavorite(topic.id);
            },
            icon: Icon(
              topic.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Text(
        'No encontramos temas con esos filtros.',
        style: TextStyle(color: context.colors.onSurfaceVariant),
      ),
    );
  }
}

IconData _iconFor(LegalGuideCategory category) {
  return switch (category) {
    LegalGuideCategory.basics => Icons.menu_book_rounded,
    LegalGuideCategory.laborRights => Icons.verified_user_rounded,
    LegalGuideCategory.calculations => Icons.calculate_rounded,
    LegalGuideCategory.whatToDo => Icons.task_alt_rounded,
    LegalGuideCategory.institutions => Icons.account_balance_rounded,
  };
}
