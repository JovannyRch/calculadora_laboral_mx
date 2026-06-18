import 'dart:math';

import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/core/formatters/currency_formatter.dart';
import 'package:calculadora_laboral_mx/features/tools/data/tools_repository.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AguinaldoToolScreen extends ConsumerStatefulWidget {
  const AguinaldoToolScreen({super.key});

  static const toolId = 'aguinaldo';
  static const routeName = 'tool-aguinaldo';
  static const routeSegment = 'aguinaldo';

  @override
  ConsumerState<AguinaldoToolScreen> createState() =>
      _AguinaldoToolScreenState();
}

class _AguinaldoToolScreenState extends ConsumerState<AguinaldoToolScreen> {
  double _monthlySalary = 15000;
  int _bonusDays = 15;
  int _workedDays = 365;

  @override
  void initState() {
    super.initState();
    _markUsed(AguinaldoToolScreen.toolId);
  }

  @override
  Widget build(BuildContext context) {
    final dailySalary = _monthlySalary / 30;
    final result = dailySalary * _bonusDays * (_workedDays / 365);
    return _ToolScaffold(
      title: 'Calculadora de aguinaldo',
      children: [
        _MoneyInput(
          label: 'Salario mensual',
          initialValue: _monthlySalary,
          onChanged: (value) => setState(() => _monthlySalary = value),
        ),
        _NumberInput(
          label: 'Dias de aguinaldo',
          initialValue: _bonusDays,
          onChanged: (value) => setState(() => _bonusDays = value),
        ),
        _NumberInput(
          label: 'Dias trabajados en el año',
          initialValue: _workedDays,
          onChanged: (value) => setState(() => _workedDays = value),
        ),
        _ResultCard(
          title: 'Aguinaldo proporcional',
          value: CurrencyFormatter.mxn(result),
          description: 'salario diario * dias de aguinaldo * proporcion anual',
        ),
      ],
    );
  }

  void _markUsed(String id) {
    Future.microtask(() => ref.read(recentToolsProvider.notifier).markUsed(id));
  }
}

class VacationsToolScreen extends ConsumerStatefulWidget {
  const VacationsToolScreen({super.key});

  static const toolId = 'vacaciones';
  static const routeName = 'tool-vacations';
  static const routeSegment = 'vacaciones';

  @override
  ConsumerState<VacationsToolScreen> createState() =>
      _VacationsToolScreenState();
}

class _VacationsToolScreenState extends ConsumerState<VacationsToolScreen> {
  DateTime _startDate = DateTime(DateTime.now().year - 1);
  DateTime _endDate = DateTime.now();
  double _monthlySalary = 15000;
  double _premiumPercentage = 25;

  @override
  void initState() {
    super.initState();
    _markUsed(VacationsToolScreen.toolId);
  }

  @override
  Widget build(BuildContext context) {
    final years = _yearsWorked(_startDate, _endDate);
    final vacationDays = _vacationDaysForYears(years);
    final ratio = _vacationPeriodRatio(years);
    final proportionalDays = vacationDays * ratio;
    final dailySalary = _monthlySalary / 30;
    final vacationAmount = dailySalary * proportionalDays;
    final premium = vacationAmount * _premiumPercentage / 100;

    return _ToolScaffold(
      title: 'Calculadora de vacaciones',
      children: [
        _DateButton(
          label: 'Fecha de ingreso',
          value: _formatDate(_startDate),
          onPressed: () => _pickDate(true),
        ),
        _DateButton(
          label: 'Fecha actual o salida',
          value: _formatDate(_endDate),
          onPressed: () => _pickDate(false),
        ),
        _MoneyInput(
          label: 'Salario mensual',
          initialValue: _monthlySalary,
          onChanged: (value) => setState(() => _monthlySalary = value),
        ),
        _DecimalInput(
          label: 'Prima vacacional',
          initialValue: _premiumPercentage,
          suffixText: '%',
          onChanged: (value) => setState(() => _premiumPercentage = value),
        ),
        _InfoGrid(
          rows: [
            ('Antiguedad', '${years.toStringAsFixed(2)} años'),
            ('Dias correspondientes', vacationDays.toString()),
            ('Vacaciones proporcionales', proportionalDays.toStringAsFixed(2)),
            ('Prima vacacional', CurrencyFormatter.mxn(premium)),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate(bool start) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: start ? _startDate : _endDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  void _markUsed(String id) {
    Future.microtask(() => ref.read(recentToolsProvider.notifier).markUsed(id));
  }
}

class DailySalaryToolScreen extends ConsumerStatefulWidget {
  const DailySalaryToolScreen({super.key});

  static const toolId = 'sueldo-diario';
  static const routeName = 'tool-daily-salary';
  static const routeSegment = 'sueldo-diario';

  @override
  ConsumerState<DailySalaryToolScreen> createState() =>
      _DailySalaryToolScreenState();
}

class _DailySalaryToolScreenState extends ConsumerState<DailySalaryToolScreen> {
  double _monthlySalary = 15000;
  double _dailySalary = 500;
  double? _integratedDailySalary;

  @override
  void initState() {
    super.initState();
    _markUsed(DailySalaryToolScreen.toolId);
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: 'Calculadora de sueldo diario',
      children: [
        _MoneyInput(
          label: 'Salario mensual',
          initialValue: _monthlySalary,
          onChanged: (value) => setState(() {
            _monthlySalary = value;
            _dailySalary = value / 30;
          }),
        ),
        _MoneyInput(
          label: 'Salario diario',
          initialValue: _dailySalary,
          onChanged: (value) => setState(() {
            _dailySalary = value;
            _monthlySalary = value * 30;
          }),
        ),
        _OptionalMoneyInput(
          label: 'Salario diario integrado opcional',
          initialValue: _integratedDailySalary,
          onChanged: (value) => setState(() => _integratedDailySalary = value),
        ),
        _InfoGrid(
          rows: [
            ('Mensual estimado', CurrencyFormatter.mxn(_monthlySalary)),
            ('Diario estimado', CurrencyFormatter.mxn(_dailySalary)),
            (
              'SDI',
              _integratedDailySalary == null
                  ? 'No capturado'
                  : CurrencyFormatter.mxn(_integratedDailySalary!),
            ),
          ],
        ),
      ],
    );
  }

  void _markUsed(String id) {
    Future.microtask(() => ref.read(recentToolsProvider.notifier).markUsed(id));
  }
}

class OfferComparatorToolScreen extends ConsumerStatefulWidget {
  const OfferComparatorToolScreen({super.key});

  static const toolId = 'comparador-oferta';
  static const routeName = 'tool-offer-comparator';
  static const routeSegment = 'comparador-oferta';

  @override
  ConsumerState<OfferComparatorToolScreen> createState() =>
      _OfferComparatorToolScreenState();
}

class _OfferComparatorToolScreenState
    extends ConsumerState<OfferComparatorToolScreen> {
  double _estimatedTotal = 25000;
  double _companyOffer = 20000;

  @override
  void initState() {
    super.initState();
    _markUsed(OfferComparatorToolScreen.toolId);
  }

  @override
  Widget build(BuildContext context) {
    final difference = _companyOffer - _estimatedTotal;
    final percentage = _estimatedTotal == 0
        ? 0
        : difference / _estimatedTotal * 100;
    final low = difference < 0;
    return _ToolScaffold(
      title: 'Comparador de oferta',
      children: [
        _MoneyInput(
          label: 'Total estimado',
          initialValue: _estimatedTotal,
          onChanged: (value) => setState(() => _estimatedTotal = value),
        ),
        _MoneyInput(
          label: 'Oferta de empresa',
          initialValue: _companyOffer,
          onChanged: (value) => setState(() => _companyOffer = value),
        ),
        _ResultCard(
          title: low ? 'Oferta menor al estimado' : 'Oferta igual o mayor',
          value: CurrencyFormatter.mxn(difference),
          description:
              'Diferencia de ${percentage.toStringAsFixed(2)}% contra el estimado.',
          icon: low ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
        ),
      ],
    );
  }

  void _markUsed(String id) {
    Future.microtask(() => ref.read(recentToolsProvider.notifier).markUsed(id));
  }
}

class ExitChecklistToolScreen extends ConsumerStatefulWidget {
  const ExitChecklistToolScreen({super.key});

  static const toolId = 'checklist-salida';
  static const routeName = 'tool-exit-checklist';
  static const routeSegment = 'checklist-salida';

  @override
  ConsumerState<ExitChecklistToolScreen> createState() =>
      _ExitChecklistToolScreenState();
}

class _ExitChecklistToolScreenState
    extends ConsumerState<ExitChecklistToolScreen> {
  final _checked = <String>{};

  static const _items = [
    'Recibo de nomina',
    'Contrato',
    'Carta renuncia, si aplica',
    'Convenio',
    'Identificacion',
    'Estado de cuenta',
    'Comprobantes de pagos pendientes',
  ];

  @override
  void initState() {
    super.initState();
    _markUsed(ExitChecklistToolScreen.toolId);
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: 'Checklist de salida laboral',
      children: [
        SectionCard(
          child: Column(
            children: [
              for (final item in _items)
                CheckboxListTile(
                  value: _checked.contains(item),
                  onChanged: (value) {
                    setState(() {
                      if (value ?? false) {
                        _checked.add(item);
                      } else {
                        _checked.remove(item);
                      }
                    });
                  },
                  title: Text(item),
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _markUsed(String id) {
    Future.microtask(() => ref.read(recentToolsProvider.notifier).markUsed(id));
  }
}

class _ToolScaffold extends StatelessWidget {
  const _ToolScaffold({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSizes.gap),
        itemCount: children.length,
      ),
    );
  }
}

class _MoneyInput extends StatelessWidget {
  const _MoneyInput({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final double initialValue;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue.toStringAsFixed(0),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        prefixText: r'$ ',
        suffixText: 'MXN',
      ),
      onChanged: (value) => onChanged(double.tryParse(value) ?? 0),
    );
  }
}

class _OptionalMoneyInput extends StatelessWidget {
  const _OptionalMoneyInput({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final double? initialValue;
  final ValueChanged<double?> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue?.toStringAsFixed(0),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        prefixText: r'$ ',
        suffixText: 'MXN',
      ),
      onChanged: (value) {
        onChanged(value.trim().isEmpty ? null : double.tryParse(value));
      },
    );
  }
}

class _NumberInput extends StatelessWidget {
  const _NumberInput({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final int initialValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label),
      onChanged: (value) => onChanged(int.tryParse(value) ?? 0),
    );
  }
}

class _DecimalInput extends StatelessWidget {
  const _DecimalInput({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.suffixText,
  });

  final String label;
  final double initialValue;
  final String? suffixText;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue.toStringAsFixed(0),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label, suffixText: suffixText),
      onChanged: (value) => onChanged(double.tryParse(value) ?? 0),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calendar_month_rounded),
      label: SizedBox(width: double.infinity, child: Text('$label: $value')),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.value,
    required this.description,
    this.icon = Icons.payments_rounded,
  });

  final String title;
  final String value;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary),
          const SizedBox(width: AppSizes.gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSizes.gapSmall),
                Text(
                  value,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSizes.gapSmall),
                Text(
                  description,
                  style: TextStyle(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.gapSmall),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: TextStyle(color: context.colors.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: AppSizes.gap),
                  Text(
                    row.$2,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

double _yearsWorked(DateTime start, DateTime end) {
  if (end.isBefore(start)) return 0;
  return end.difference(start).inDays / 365;
}

int _vacationDaysForYears(double yearsWorked) {
  final year = max(1, yearsWorked.ceil());
  if (year == 1) return 12;
  if (year == 2) return 14;
  if (year == 3) return 16;
  if (year == 4) return 18;
  if (year == 5) return 20;
  if (year <= 10) return 22;
  if (year <= 15) return 24;
  if (year <= 20) return 26;
  if (year <= 25) return 28;
  return 30;
}

double _vacationPeriodRatio(double yearsWorked) {
  if (yearsWorked <= 0) return 0;
  if (yearsWorked < 1) return yearsWorked;
  final fraction = yearsWorked - yearsWorked.floor();
  return fraction == 0 ? 1 : fraction;
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
