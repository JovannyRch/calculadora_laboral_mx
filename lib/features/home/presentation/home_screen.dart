import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_screen.dart';
import 'package:calculadora_laboral_mx/features/history/presentation/history_screen.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/presentation/legal_guide_screen.dart';
import 'package:calculadora_laboral_mx/features/settings/presentation/settings_screen.dart';
import 'package:calculadora_laboral_mx/features/tools/data/tools_repository.dart';
import 'package:calculadora_laboral_mx/features/tools/presentation/extra_tools_screens.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:calculadora_laboral_mx/shared/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';
  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTools = ref.watch(recentToolsProvider);

    return AppScaffold(
      title: 'Calculadora Laboral MX',
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          _HeroCard(onStart: () => context.goNamed(CalculatorScreen.routeName)),
          const SizedBox(height: AppSizes.gapLarge),
          Text(
            'Herramientas',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.gap),
          _ActionTile(
            icon: Icons.calculate_rounded,
            title: 'Calculadora guiada',
            subtitle: 'Captura salario, fechas y tipo de salida.',
            onTap: () => context.goNamed(CalculatorScreen.routeName),
          ),
          if (recentTools.isNotEmpty) ...[
            const SizedBox(height: AppSizes.gap),
            Text(
              'Recientes',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.gap),
            for (final id in recentTools) _ToolTile(tool: _toolFor(id)),
          ],
          const SizedBox(height: AppSizes.gap),
          Text(
            'Calculadoras rapidas',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.gap),
          for (final tool in _tools) _ToolTile(tool: tool),
          _ActionTile(
            icon: Icons.history_rounded,
            title: 'Historial',
            subtitle: 'Consulta estimaciones guardadas en este dispositivo.',
            onTap: () => context.goNamed(HistoryScreen.routeName),
          ),
          _ActionTile(
            icon: Icons.menu_book_rounded,
            title: 'Guia laboral',
            subtitle: 'Conceptos base para finiquito y liquidacion.',
            onTap: () => context.goNamed(LegalGuideScreen.routeName),
          ),
          _ActionTile(
            icon: Icons.settings_rounded,
            title: 'Configuracion',
            subtitle: 'Tema, preferencias y avisos de uso.',
            onTap: () => context.goNamed(SettingsScreen.routeName),
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.tool});

  final _ToolLink tool;

  @override
  Widget build(BuildContext context) {
    return _ActionTile(
      icon: tool.icon,
      title: tool.title,
      subtitle: tool.subtitle,
      onTap: () => context.goNamed(tool.routeName),
    );
  }
}

const _tools = [
  _ToolLink(
    id: AguinaldoToolScreen.toolId,
    icon: Icons.card_giftcard_rounded,
    title: 'Aguinaldo',
    subtitle: 'Calcula aguinaldo proporcional.',
    routeName: AguinaldoToolScreen.routeName,
  ),
  _ToolLink(
    id: VacationsToolScreen.toolId,
    icon: Icons.beach_access_rounded,
    title: 'Vacaciones',
    subtitle: 'Antiguedad, dias y prima vacacional.',
    routeName: VacationsToolScreen.routeName,
  ),
  _ToolLink(
    id: DailySalaryToolScreen.toolId,
    icon: Icons.payments_rounded,
    title: 'Sueldo diario',
    subtitle: 'Convierte mensual, diario y SDI.',
    routeName: DailySalaryToolScreen.routeName,
  ),
  _ToolLink(
    id: OfferComparatorToolScreen.toolId,
    icon: Icons.compare_arrows_rounded,
    title: 'Comparador de oferta',
    subtitle: 'Compara estimado contra oferta.',
    routeName: OfferComparatorToolScreen.routeName,
  ),
  _ToolLink(
    id: ExitChecklistToolScreen.toolId,
    icon: Icons.checklist_rounded,
    title: 'Checklist de salida',
    subtitle: 'Documentos a revisar antes de firmar.',
    routeName: ExitChecklistToolScreen.routeName,
  ),
];

_ToolLink _toolFor(String id) {
  return _tools.firstWhere((tool) => tool.id == id, orElse: () => _tools.first);
}

class _ToolLink {
  const _ToolLink({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusChip(
            label: 'Estimacion informativa',
            icon: Icons.verified_user_rounded,
          ),
          const SizedBox(height: AppSizes.gapLarge),
          Text(
            'Prepara un calculo laboral claro',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSizes.gap),
          Text(
            'La base ya esta lista para capturar datos, guardar escenarios y mostrar resultados de forma confiable.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSizes.gapLarge),
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Nueva estimacion'),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.gap),
      child: SectionCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: context.colors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: context.colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
