import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/presentation/official_sources_screen.dart';
import 'package:calculadora_laboral_mx/features/settings/presentation/legal_notice_screen.dart';
import 'package:calculadora_laboral_mx/features/settings/presentation/settings_controller.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = 'settings';
  static const routeSegment = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final controller = ref.read(themeModeControllerProvider.notifier);

    return AppScaffold(
      title: 'Configuracion',
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apariencia',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.gap),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_rounded),
                      label: Text('Sistema'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_rounded),
                      label: Text('Claro'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_rounded),
                      label: Text('Oscuro'),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) {
                    controller.setThemeMode(selection.first);
                  },
                ),
              ],
            ),
          ),
  /*         const SizedBox(height: AppSizes.gap),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monetizacion',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.gap),
                _SettingLine(
                  icon: Icons.ads_click_rounded,
                  title: 'Anuncios',
                  value: AppConfig.showAds ? 'Preparados' : 'Desactivados',
                ),
                _SettingLine(
                  icon: Icons.workspace_premium_rounded,
                  title: 'Premium',
                  value: AppConfig.premiumEnabled ? 'Activo' : 'Preparado',
                ),
              ],
            ),
          ), */
          const SizedBox(height: AppSizes.gap),
          SectionCard(
            child: Column(
              children: [
                _NavigationLine(
                  icon: Icons.verified_rounded,
                  title: 'Fuentes oficiales',
                  onTap: () =>
                      context.goNamed(OfficialSourcesScreen.routeName),
                ),
                const Divider(),
                _NavigationLine(
                  icon: Icons.balance_rounded,
                  title: 'Aviso legal',
                  onTap: () => context.goNamed(LegalNoticeScreen.routeName),
                ),
                const Divider(),
                _NavigationLine(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacidad',
                  onTap: () => context.goNamed(PrivacyScreen.routeName),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gap),
          SectionCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.privacy_tip_rounded, color: context.colors.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos locales',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'El historial se guarda en este dispositivo con Hive. No hay sincronizacion remota configurada.',
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
          ),
          const SizedBox(height: AppSizes.gap),
          SectionCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.balance_rounded, color: context.colors.secondary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Uso informativo',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Los resultados finales deberan validarse con la normativa aplicable y el caso concreto.',
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
          ),
        ],
      ),
    );
  }
}

class _NavigationLine extends StatelessWidget {
  const _NavigationLine({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: context.colors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
