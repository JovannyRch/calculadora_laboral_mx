import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/core/formatters/currency_formatter.dart';
import 'package:calculadora_laboral_mx/features/calculator/data/pdf_report_service.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_result.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/labor_calculator_service.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_controller.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_screen.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/pdf_preview_screen.dart';
import 'package:calculadora_laboral_mx/features/history/data/history_repository.dart';
import 'package:calculadora_laboral_mx/features/history/domain/saved_labor_calculation.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  static const routeName = 'results';
  static const routeSegment = 'results';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(calculatorInputProvider);
    final result = const LaborCalculatorService().calculate(input);

    return AppScaffold(
      title: 'Resultados',
      body: ResultDashboard(
        input: input,
        result: result,
        actions: _ResultActions(input: input, result: result),
      ),
    );
  }
}

class ResultDashboard extends StatelessWidget {
  const ResultDashboard({
    required this.input,
    required this.result,
    required this.actions,
    super.key,
  });

  final LaborCalculationInput input;
  final LaborCalculationResult result;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      children: [
        _ResultHeader(result: result),
        const SizedBox(height: AppSizes.gapLarge),
        _SummaryGrid(result: result),
        if (input.companyOfferAmount != null) ...[
          const SizedBox(height: AppSizes.gapLarge),
          _OfferComparison(input: input, result: result),
        ],
        const SizedBox(height: AppSizes.gapLarge),
        _Breakdown(result: result),
        const SizedBox(height: AppSizes.gapLarge),
        actions,
        const SizedBox(height: AppSizes.gapLarge),
        const _LegalNotice(),
      ],
    );
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.result});

  final LaborCalculationResult result;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resultado estimado',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.gapLarge),
          Text(
            CurrencyFormatter.mxn(result.netTotal),
            style: context.textTheme.displaySmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSizes.gapSmall),
          Text(
            'Calculo informativo basado en los datos ingresados',
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.result});

  final LaborCalculationResult result;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _MetricData(
        'Total bruto',
        result.grossTotal,
        Icons.account_balance_wallet,
      ),
      _MetricData('ISR estimado', result.estimatedTax, Icons.receipt_long),
      _MetricData('Total neto', result.netTotal, Icons.payments),
      _MetricData('Finiquito', result.settlementTotal, Icons.assignment),
      _MetricData(
        'Liquidacion / indemnizacion',
        result.severanceTotal,
        Icons.gavel,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 520 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 124,
            crossAxisSpacing: AppSizes.gap,
            mainAxisSpacing: AppSizes.gap,
          ),
          itemBuilder: (context, index) => _MetricCard(data: cards[index]),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: context.colors.primary),
          ),
          const SizedBox(width: AppSizes.gap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CurrencyFormatter.mxn(data.amount),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
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

class _OfferComparison extends StatelessWidget {
  const _OfferComparison({required this.input, required this.result});

  final LaborCalculationInput input;
  final LaborCalculationResult result;

  @override
  Widget build(BuildContext context) {
    final offer = input.companyOfferAmount!;
    final difference = result.companyOfferDifference ?? 0;
    final percentage = result.companyOfferDifferencePercentage ?? 0;
    final isLow = difference < 0;
    final color = isLow ? context.colors.error : context.colors.secondary;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLow ? Icons.warning_amber_rounded : Icons.check_circle,
                color: color,
              ),
              const SizedBox(width: AppSizes.gapSmall),
              Expanded(
                child: Text(
                  isLow
                      ? 'La oferta es menor al estimado'
                      : 'La oferta cubre o supera el estimado',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapLarge),
          _SummaryLine('Oferta de empresa', CurrencyFormatter.mxn(offer)),
          _SummaryLine('Diferencia', CurrencyFormatter.mxn(difference)),
          _SummaryLine('Porcentaje', '${percentage.toStringAsFixed(2)}%'),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.result});

  final LaborCalculationResult result;

  @override
  Widget build(BuildContext context) {
    final groups = [
      (BreakdownCategory.settlement, 'Finiquito'),
      (BreakdownCategory.severance, 'Liquidacion'),
      (BreakdownCategory.tax, 'Impuestos'),
      (BreakdownCategory.comparison, 'Comparacion'),
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Desglose detallado',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.gap),
          for (final group in groups)
            _BreakdownGroup(
              title: group.$2,
              items: result.breakdownItems
                  .where((item) => item.category == group.$1)
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _BreakdownGroup extends StatelessWidget {
  const _BreakdownGroup({required this.title, required this.items});

  final String title;
  final List<BreakdownItem> items;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: items.isNotEmpty,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      children: items.isEmpty
          ? [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.gap),
                  child: Text(
                    'Sin conceptos para este calculo.',
                    style: TextStyle(color: context.colors.onSurfaceVariant),
                  ),
                ),
              ),
            ]
          : [
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.gap),
                  child: _BreakdownRow(item: item),
                ),
            ],
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.item});

  final BreakdownItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: AppSizes.gap),
              Text(
                CurrencyFormatter.mxn(item.amount),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapSmall),
          Text(
            item.description,
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSizes.gapSmall),
          Text(
            item.formula,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultActions extends ConsumerWidget {
  const _ResultActions({required this.input, required this.result});

  final LaborCalculationInput input;
  final LaborCalculationResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      child: Column(
        children: [
          _ActionButton(
            icon: Icons.save_rounded,
            label: 'Guardar calculo',
            onPressed: () => _save(context, ref),
          ),
          const SizedBox(height: AppSizes.gap),
          _ActionButton(
            icon: Icons.picture_as_pdf_rounded,
            label: 'Vista previa PDF',
            onPressed: () => _previewPdf(context),
          ),
          const SizedBox(height: AppSizes.gap),
          _ActionButton(
            icon: Icons.save_alt_rounded,
            label: 'Guardar PDF temporal',
            onPressed: () => _savePdf(context),
          ),
          const SizedBox(height: AppSizes.gap),
          _ActionButton(
            icon: Icons.ios_share_rounded,
            label: 'Compartir PDF',
            onPressed: () => _sharePdf(context),
          ),
          const SizedBox(height: AppSizes.gap),
          _ActionButton(
            icon: Icons.add_circle_outline_rounded,
            label: 'Nuevo calculo',
            onPressed: () => context.goNamed(CalculatorScreen.routeName),
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final title = await _askTitle(context, _defaultTitle(input, now));
    if (title == null) return;

    try {
      await ref
          .read(historyControllerProvider.notifier)
          .save(
            SavedLaborCalculation(
              id: now.microsecondsSinceEpoch.toString(),
              title: title,
              createdAt: now,
              input: input,
              result: result,
              calculationType: input.calculationType,
              monthlySalary: input.monthlySalary,
              netTotal: result.netTotal,
              grossTotal: result.grossTotal,
            ),
          );
    } on HistoryRepositoryException catch (error) {
      if (!context.mounted) return;
      _snack(context, error.message);
      return;
    }
    if (!context.mounted) return;
    _snack(context, 'Calculo guardado en historial.');
  }

  void _previewPdf(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            PdfReportPreviewScreen(input: input, result: result),
      ),
    );
  }

  Future<void> _savePdf(BuildContext context) async {
    try {
      final file = await const PdfReportService().saveTemporary(
        input: input,
        result: result,
      );
      if (!context.mounted) return;
      _snack(context, 'PDF guardado temporalmente: ${file.path}');
    } catch (error) {
      if (!context.mounted) return;
      _snack(context, 'No se pudo guardar el PDF.');
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      await const PdfReportService().shareReport(input: input, result: result);
    } catch (error) {
      if (!context.mounted) return;
      _snack(context, 'No se pudo compartir el PDF.');
    }
  }

  Future<String?> _askTitle(BuildContext context, String suggestedTitle) {
    final controller = TextEditingController(text: suggestedTitle);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guardar calculo'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Titulo'),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _closeTitleDialog(context, controller),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => _closeTitleDialog(context, controller),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _closeTitleDialog(
    BuildContext context,
    TextEditingController controller,
  ) {
    final title = controller.text.trim();
    if (title.isEmpty) return;
    Navigator.of(context).pop(title);
  }

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

String _defaultTitle(LaborCalculationInput input, DateTime now) {
  final type = switch (input.calculationType) {
    CalculationType.resignation => 'Renuncia',
    CalculationType.unjustifiedDismissal => 'Despido',
    CalculationType.contractEnd => 'Fin de contrato',
    CalculationType.mutualAgreement => 'Mutuo acuerdo',
  };
  return '$type - ${_monthName(now.month)} ${now.year}';
}

String _monthName(int month) {
  const months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  return months[month - 1];
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class _LegalNotice extends StatelessWidget {
  const _LegalNotice();

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
              'Esta herramienta ofrece una estimacion informativa. Para casos '
              'especificos, consulta a PROFEDET, un abogado laboral o el '
              'Centro de Conciliacion correspondiente.',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.gapSmall),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: AppSizes.gap),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _MetricData {
  const _MetricData(this.label, this.amount, this.icon);

  final String label;
  final double amount;
  final IconData icon;
}
