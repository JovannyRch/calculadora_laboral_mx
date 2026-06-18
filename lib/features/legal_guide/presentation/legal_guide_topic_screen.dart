import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/data/legal_guide_repository.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LegalGuideTopicScreen extends ConsumerWidget {
  const LegalGuideTopicScreen({required this.topicId, super.key});

  static const routeName = 'legal-guide-topic';
  static const routeSegment = ':topicId';

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(legalGuideControllerProvider.notifier);
    ref.watch(legalGuideControllerProvider);
    final topic = controller.topicById(topicId);

    if (topic == null) {
      return AppScaffold(
        title: 'Guía laboral',
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: SectionCard(
            child: Text(
              'No encontramos este tema.',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    return AppScaffold(
      title: 'Guía laboral',
      actions: [
        IconButton(
          tooltip: topic.isFavorite ? 'Quitar favorito' : 'Guardar favorito',
          onPressed: () => controller.toggleFavorite(topic.id),
          icon: Icon(
            topic.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          SectionCard(
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
                const SizedBox(height: AppSizes.gapSmall),
                Text(
                  topic.title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSizes.gap),
                Text(
                  topic.summary,
                  style: TextStyle(
                    color: context.colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gapLarge),
          SectionCard(
            child: Text(
              topic.content,
              style: context.textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
          ),
          const SizedBox(height: AppSizes.gapLarge),
          Wrap(
            spacing: AppSizes.gapSmall,
            runSpacing: AppSizes.gapSmall,
            children: [for (final tag in topic.tags) Chip(label: Text(tag))],
          ),
          const SizedBox(height: AppSizes.gapLarge),
          const _GuideNotice(),
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
