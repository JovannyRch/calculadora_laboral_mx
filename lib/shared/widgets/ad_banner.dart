import 'package:calculadora_laboral_mx/app/app_config.dart';
import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppAdBanner extends StatelessWidget {
  const AppAdBanner({required this.adUnitId, super.key});

  final String adUnitId;

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.showAds) return const SizedBox.shrink();

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.ads_click_rounded, color: context.colors.onSurfaceVariant),
          const SizedBox(width: AppSizes.gap),
          Expanded(
            child: Text(
              'Espacio publicitario',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Tooltip(
            message: adUnitId,
            child: Text(
              'Placeholder',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppInterstitialAds {
  const AppInterstitialAds._();

  static void maybeShowAfterResult(BuildContext context) {
    if (!AppConfig.showInterstitial) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Interstitial preparado para AdMob.')),
    );
  }
}
