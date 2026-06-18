import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';

class LegalNoticeScreen extends StatelessWidget {
  const LegalNoticeScreen({super.key});

  static const routeName = 'legal-notice';
  static const routeSegment = 'aviso-legal';

  @override
  Widget build(BuildContext context) {
    return const _InfoPage(
      title: 'Aviso legal',
      icon: Icons.balance_rounded,
      paragraphs: [
        'Calculadora Laboral MX no es una entidad gubernamental, autoridad laboral ni despacho legal.',
        'Los calculos son estimaciones informativas basadas en los datos que captura el usuario.',
        'La app no sustituye asesoria legal, fiscal ni laboral profesional.',
        'Para casos especificos, consulta a PROFEDET, un abogado laboral o el Centro de Conciliacion correspondiente.',
      ],
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const routeName = 'privacy';
  static const routeSegment = 'privacidad';

  @override
  Widget build(BuildContext context) {
    return const _InfoPage(
      title: 'Privacidad',
      icon: Icons.privacy_tip_rounded,
      paragraphs: [
        'La informacion capturada para calculos e historial se guarda localmente en este dispositivo.',
        'No se envian datos laborales, salariales ni historiales a servidores de la app.',
        'Si se activan anuncios en una version futura, el proveedor de anuncios podria procesar datos tecnicos conforme a sus propias politicas.',
        'Puedes eliminar calculos guardados desde el historial cuando ya no los necesites.',
      ],
    );
  }
}

class _InfoPage extends StatelessWidget {
  const _InfoPage({
    required this.title,
    required this.icon,
    required this.paragraphs,
  });

  final String title;
  final IconData icon;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: context.colors.primary, size: 36),
                const SizedBox(height: AppSizes.gapLarge),
                Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSizes.gap),
                for (final paragraph in paragraphs) ...[
                  Text(
                    paragraph,
                    style: TextStyle(
                      color: context.colors.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSizes.gap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
