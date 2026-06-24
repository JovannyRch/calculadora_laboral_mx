import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficialSourcesScreen extends StatelessWidget {
  const OfficialSourcesScreen({super.key});

  static const routeName = 'official-sources';
  static const routeSegment = 'fuentes-oficiales';

  static const _sources = <_OfficialSource>[
    _OfficialSource(
      title: 'Ley Federal del Trabajo',
      description:
          'Texto vigente publicado por la Camara de Diputados del H. Congreso de la Union.',
      url: 'https://www.diputados.gob.mx/LeyesBiblio/pdf/LFT.pdf',
      icon: Icons.menu_book_rounded,
    ),
    _OfficialSource(
      title: 'PROFEDET',
      description:
          'Procuraduria Federal de la Defensa del Trabajo. Asesoria y representacion laboral gratuita.',
      url: 'https://www.gob.mx/profedet',
      icon: Icons.gavel_rounded,
    ),
    _OfficialSource(
      title: 'Secretaria del Trabajo y Prevision Social (STPS)',
      description:
          'Dependencia del Gobierno de Mexico encargada de la politica laboral.',
      url: 'https://www.gob.mx/stps',
      icon: Icons.account_balance_rounded,
    ),
  ];

  Future<void> _open(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el enlace. Intentalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Fuentes oficiales',
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          const _Disclaimer(),
          const SizedBox(height: AppSizes.gap),
          Text(
            'Consulta directamente las fuentes oficiales del Gobierno de Mexico '
            'en las que se basa la informacion de esta app:',
            style: TextStyle(
              color: context.colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSizes.gap),
          for (final source in _sources) ...[
            _SourceCard(
              source: source,
              onTap: () => _open(context, source.url),
            ),
            const SizedBox(height: AppSizes.gap),
          ],
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

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
              'Esta aplicacion no representa ni esta asociada a ninguna entidad '
              'gubernamental ni autoridad laboral. La informacion se ofrece solo '
              'con fines orientativos. Para datos oficiales y vigentes consulta '
              'las fuentes listadas a continuacion.',
              style: TextStyle(
                color: context.colors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.source, required this.onTap});

  final _OfficialSource source;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: onTap,
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
            child: Icon(source.icon, color: context.colors.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  source.description,
                  style: TextStyle(
                    color: context.colors.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  source.url,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.open_in_new_rounded, color: context.colors.primary),
        ],
      ),
    );
  }
}

class _OfficialSource {
  const _OfficialSource({
    required this.title,
    required this.description,
    required this.url,
    required this.icon,
  });

  final String title;
  final String description;
  final String url;
  final IconData icon;
}
