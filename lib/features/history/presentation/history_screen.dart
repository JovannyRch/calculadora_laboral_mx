import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/core/formatters/currency_formatter.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_screen.dart';
import 'package:calculadora_laboral_mx/features/history/data/history_repository.dart';
import 'package:calculadora_laboral_mx/features/history/domain/saved_labor_calculation.dart';
import 'package:calculadora_laboral_mx/features/history/presentation/saved_calculation_detail_screen.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  static const routeName = 'history';
  static const routeSegment = 'history';

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  var _query = '';
  CalculationType? _type;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyControllerProvider);
    final entries = _filter(state.calculations);

    return AppScaffold(
      title: 'Historial',
      body: state.calculations.isEmpty
          ? const _EmptyHistory()
          : ListView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              children: [
                _HistoryFilters(
                  query: _query,
                  type: _type,
                  onQueryChanged: (value) => setState(() => _query = value),
                  onTypeChanged: (value) => setState(() => _type = value),
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: AppSizes.gap),
                  _ErrorBanner(message: state.errorMessage!),
                ],
                const SizedBox(height: AppSizes.gapLarge),
                if (entries.isEmpty)
                  const _NoMatches()
                else
                  for (final entry in entries) ...[
                    _HistoryTile(entry: entry),
                    const SizedBox(height: AppSizes.gap),
                  ],
              ],
            ),
    );
  }

  List<SavedLaborCalculation> _filter(List<SavedLaborCalculation> entries) {
    final normalizedQuery = _query.trim().toLowerCase();
    return entries.where((entry) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          entry.title.toLowerCase().contains(normalizedQuery);
      final matchesType = _type == null || entry.calculationType == _type;
      return matchesQuery && matchesType;
    }).toList();
  }
}

class _HistoryFilters extends StatelessWidget {
  const _HistoryFilters({
    required this.query,
    required this.type,
    required this.onQueryChanged,
    required this.onTypeChanged,
  });

  final String query;
  final CalculationType? type;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CalculationType?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar por titulo',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: onQueryChanged,
          ),
          const SizedBox(height: AppSizes.gap),
          DropdownButtonFormField<CalculationType?>(
            initialValue: type,
            decoration: const InputDecoration(labelText: 'Tipo'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todos')),
              for (final type in CalculationType.values)
                DropdownMenuItem(value: type, child: Text(type.label)),
            ],
            onChanged: onTypeChanged,
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final SavedLaborCalculation entry;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: () {
        context.goNamed(
          SavedCalculationDetailScreen.routeName,
          pathParameters: {'calculationId': entry.id},
        );
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.description_rounded,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.calculationType.label} · ${_formatDate(entry.createdAt)}',
                  style: TextStyle(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.gap),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.mxn(entry.netTotal),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              Text(
                'Neto',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Center(
        child: SectionCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                size: 48,
                color: context.colors.primary,
              ),
              const SizedBox(height: AppSizes.gap),
              Text(
                'Aun no tienes calculos guardados',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSizes.gapSmall),
              Text(
                'Guarda una estimacion para consultarla despues.',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSizes.gapLarge),
              FilledButton.icon(
                onPressed: () => context.goNamed(CalculatorScreen.routeName),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Crear primer calculo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  const _NoMatches();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Text(
        'No hay calculos que coincidan con la busqueda.',
        style: TextStyle(color: context.colors.onSurfaceVariant),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: context.colors.error),
          const SizedBox(width: AppSizes.gap),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
