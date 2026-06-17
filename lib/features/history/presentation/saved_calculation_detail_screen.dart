import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/features/calculator/data/pdf_report_service.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/labor_calculator_service.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_controller.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_screen.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/pdf_preview_screen.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/results_screen.dart';
import 'package:calculadora_laboral_mx/features/history/data/history_repository.dart';
import 'package:calculadora_laboral_mx/features/history/domain/saved_labor_calculation.dart';
import 'package:calculadora_laboral_mx/features/history/presentation/history_screen.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SavedCalculationDetailScreen extends ConsumerWidget {
  const SavedCalculationDetailScreen({required this.calculationId, super.key});

  static const routeName = 'saved-calculation-detail';
  static const routeSegment = ':calculationId';

  final String calculationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    final calculation = _find(state.calculations, calculationId);

    if (calculation == null) {
      return AppScaffold(
        title: 'Calculo guardado',
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: SectionCard(
            child: Text(
              'No se encontro este calculo guardado.',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    return AppScaffold(
      title: calculation.title,
      body: ResultDashboard(
        input: calculation.input,
        result: calculation.result,
        actions: _SavedDetailActions(calculation: calculation),
      ),
    );
  }

  SavedLaborCalculation? _find(
    List<SavedLaborCalculation> calculations,
    String id,
  ) {
    for (final calculation in calculations) {
      if (calculation.id == id) return calculation;
    }
    return null;
  }
}

class _SavedDetailActions extends ConsumerWidget {
  const _SavedDetailActions({required this.calculation});

  final SavedLaborCalculation calculation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      child: Column(
        children: [
          _ActionButton(
            icon: Icons.refresh_rounded,
            label: 'Recalcular',
            onPressed: () => _recalculate(context, ref),
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
            icon: Icons.copy_rounded,
            label: 'Duplicar como nuevo calculo',
            onPressed: () {
              ref
                  .read(calculatorInputProvider.notifier)
                  .setInput(calculation.input);
              context.goNamed(CalculatorScreen.routeName);
            },
          ),
          const SizedBox(height: AppSizes.gap),
          _ActionButton(
            icon: Icons.delete_outline_rounded,
            label: 'Eliminar',
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _recalculate(BuildContext context, WidgetRef ref) async {
    final result = const LaborCalculatorService().calculate(calculation.input);
    try {
      await ref
          .read(historyControllerProvider.notifier)
          .save(calculation.copyWith(result: result));
    } on HistoryRepositoryException catch (error) {
      if (!context.mounted) return;
      _snack(context, error.message);
      return;
    }
    if (!context.mounted) return;
    _snack(context, 'Calculo actualizado.');
  }

  void _previewPdf(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PdfReportPreviewScreen(
          input: calculation.input,
          result: calculation.result,
        ),
      ),
    );
  }

  Future<void> _savePdf(BuildContext context) async {
    try {
      final file = await const PdfReportService().saveTemporary(
        input: calculation.input,
        result: calculation.result,
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
      await const PdfReportService().shareReport(
        input: calculation.input,
        result: calculation.result,
      );
    } catch (error) {
      if (!context.mounted) return;
      _snack(context, 'No se pudo compartir el PDF.');
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar calculo'),
        content: const Text('Esta accion no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(historyControllerProvider.notifier).delete(calculation.id);
    } on HistoryRepositoryException catch (error) {
      if (!context.mounted) return;
      _snack(context, error.message);
      return;
    }
    if (!context.mounted) return;
    context.goNamed(HistoryScreen.routeName);
  }

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
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
