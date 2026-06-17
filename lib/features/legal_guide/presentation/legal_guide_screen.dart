import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/domain/legal_guide_topic.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';

class LegalGuideScreen extends StatelessWidget {
  const LegalGuideScreen({super.key});

  static const routeName = 'legal-guide';
  static const routeSegment = 'legal-guide';

  static const _topics = [
    LegalGuideTopic(
      title: 'Finiquito',
      summary:
          'Conceptos usuales al terminar una relacion laboral: dias trabajados, aguinaldo, vacaciones y prima vacacional.',
      iconName: 'receipt',
    ),
    LegalGuideTopic(
      title: 'Liquidacion',
      summary:
          'Aplica en escenarios especificos e incluye posibles indemnizaciones conforme al caso.',
      iconName: 'gavel',
    ),
    LegalGuideTopic(
      title: 'Aviso importante',
      summary:
          'La app entrega estimaciones informativas y no sustituye asesoria legal individual.',
      iconName: 'info',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Guia laboral',
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return SectionCard(
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
                  child: Icon(_iconFor(topic), color: context.colors.secondary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              ],
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSizes.gap),
        itemCount: _topics.length,
      ),
    );
  }

  IconData _iconFor(LegalGuideTopic topic) {
    return switch (topic.iconName) {
      'gavel' => Icons.gavel_rounded,
      'info' => Icons.info_rounded,
      _ => Icons.receipt_long_rounded,
    };
  }
}
