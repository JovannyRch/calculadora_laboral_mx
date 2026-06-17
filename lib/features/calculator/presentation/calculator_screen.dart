import 'package:calculadora_laboral_mx/core/constants/app_sizes.dart';
import 'package:calculadora_laboral_mx/core/formatters/currency_formatter.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_controller.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/results_screen.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_scaffold.dart';
import 'package:calculadora_laboral_mx/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  static const routeName = 'calculator';
  static const routeSegment = 'calculator';

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  var _step = 0;
  String? _dateError;

  static const _steps = [
    'Tipo',
    'Fechas',
    'Salario',
    'Prestaciones',
    'Oferta',
    'Confirmacion',
  ];

  @override
  Widget build(BuildContext context) {
    final input = ref.watch(calculatorInputProvider);

    return AppScaffold(
      title: 'Calculadora guiada',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.screenPadding,
              AppSizes.screenPadding,
              AppSizes.gap,
            ),
            child: _StepHeader(step: _step, steps: _steps),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenPadding,
                  0,
                  AppSizes.screenPadding,
                  AppSizes.gapLarge,
                ),
                children: [
                  _StepBody(
                    step: _step,
                    input: input,
                    dateError: _dateError,
                    onPickDate: _pickDate,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _step == 0 ? null : _previous,
                      child: const Text('Atras'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.gap),
                  Expanded(
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(
                        _step == _steps.length - 1
                            ? 'Confirmar datos'
                            : 'Siguiente',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(bool isStartDate) async {
    final input = ref.read(calculatorInputProvider);
    final controller = ref.read(calculatorInputProvider.notifier);
    final initial = isStartDate ? input.startDate : input.endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1970),
      lastDate: DateTime.now().add(const Duration(days: 366)),
      helpText: isStartDate ? 'Fecha de ingreso' : 'Fecha de salida',
    );

    if (picked == null) return;
    if (isStartDate) {
      controller.setStartDate(picked);
    } else {
      controller.setEndDate(picked);
    }
    setState(() => _dateError = null);
  }

  void _previous() {
    setState(() {
      _dateError = null;
      _step--;
    });
  }

  void _next() {
    if (!_validateStep()) return;
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      return;
    }

    context.goNamed(ResultsScreen.routeName);
  }

  bool _validateStep() {
    final validForm = _formKey.currentState?.validate() ?? true;
    final input = ref.read(calculatorInputProvider);

    if (_step == 1 && input.endDate.isBefore(input.startDate)) {
      setState(() {
        _dateError = 'La fecha de salida no puede ser anterior al ingreso.';
      });
      return false;
    }

    setState(() => _dateError = null);
    return validForm;
  }
}

class _StepBody extends ConsumerWidget {
  const _StepBody({
    required this.step,
    required this.input,
    required this.onPickDate,
    this.dateError,
  });

  final int step;
  final LaborCalculationInput input;
  final String? dateError;
  final ValueChanged<bool> onPickDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(calculatorInputProvider.notifier);

    return switch (step) {
      0 => _TypeStep(input: input, onChanged: controller.setType),
      1 => _DatesStep(
        input: input,
        dateError: dateError,
        onPickDate: onPickDate,
        onDaysChanged: controller.setUnpaidWorkedDays,
      ),
      2 => _SalaryStep(
        input: input,
        onMonthlyChanged: controller.setMonthlySalary,
        onDailyChanged: controller.setDailySalary,
        onIntegratedChanged: controller.setIntegratedDailySalary,
      ),
      3 => _BenefitsStep(
        input: input,
        onBonusDaysChanged: controller.setYearlyChristmasBonusDays,
        onVacationBonusChanged: controller.setVacationBonusPercentage,
        onPendingVacationChanged: controller.setPendingVacationDays,
        onReceivedBonusChanged: controller.setReceivedCurrentYearBonus,
        onReceivedVacationChanged: controller.setReceivedCurrentPeriodVacation,
      ),
      4 => _OfferStep(input: input, onChanged: controller.setCompanyOffer),
      _ => _ConfirmationStep(input: input),
    };
  }
}

class _TypeStep extends StatelessWidget {
  const _TypeStep({required this.input, required this.onChanged});

  final LaborCalculationInput input;
  final ValueChanged<CalculationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Tipo de calculo',
      child: Column(
        children: [
          for (final type in CalculationType.values)
            ListTile(
              onTap: () => onChanged(type),
              leading: Icon(
                input.calculationType == type
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
              title: Text(type.label),
              contentPadding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}

class _DatesStep extends StatelessWidget {
  const _DatesStep({
    required this.input,
    required this.onPickDate,
    required this.onDaysChanged,
    this.dateError,
  });

  final LaborCalculationInput input;
  final String? dateError;
  final ValueChanged<bool> onPickDate;
  final ValueChanged<int> onDaysChanged;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Fechas laborales',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateButton(
            label: 'Fecha de ingreso',
            value: _formatDate(input.startDate),
            onPressed: () => onPickDate(true),
          ),
          const SizedBox(height: AppSizes.gap),
          _DateButton(
            label: 'Fecha de salida',
            value: _formatDate(input.endDate),
            onPressed: () => onPickDate(false),
          ),
          if (dateError != null) ...[
            const SizedBox(height: AppSizes.gapSmall),
            Text(dateError!, style: TextStyle(color: context.colors.error)),
          ],
          const SizedBox(height: AppSizes.gap),
          TextFormField(
            initialValue: input.unpaidWorkedDays.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Dias trabajados no pagados',
              hintText: '0',
            ),
            validator: _wholeNumberValidator,
            onChanged: (value) => onDaysChanged(int.tryParse(value) ?? 0),
          ),
        ],
      ),
    );
  }
}

class _SalaryStep extends StatelessWidget {
  const _SalaryStep({
    required this.input,
    required this.onMonthlyChanged,
    required this.onDailyChanged,
    required this.onIntegratedChanged,
  });

  final LaborCalculationInput input;
  final ValueChanged<double> onMonthlyChanged;
  final ValueChanged<double?> onDailyChanged;
  final ValueChanged<double?> onIntegratedChanged;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Salario',
      child: Column(
        children: [
          _MoneyField(
            label: 'Salario mensual',
            value: input.monthlySalary,
            requiredField: true,
            onChanged: (value) => onMonthlyChanged(value ?? 0),
          ),
          const SizedBox(height: AppSizes.gap),
          _MoneyField(
            label: 'Salario diario opcional',
            value: input.dailySalary,
            onChanged: onDailyChanged,
          ),
          const SizedBox(height: AppSizes.gap),
          _MoneyField(
            label: 'Salario diario integrado opcional',
            value: input.integratedDailySalary,
            onChanged: onIntegratedChanged,
          ),
        ],
      ),
    );
  }
}

class _BenefitsStep extends StatelessWidget {
  const _BenefitsStep({
    required this.input,
    required this.onBonusDaysChanged,
    required this.onVacationBonusChanged,
    required this.onPendingVacationChanged,
    required this.onReceivedBonusChanged,
    required this.onReceivedVacationChanged,
  });

  final LaborCalculationInput input;
  final ValueChanged<int> onBonusDaysChanged;
  final ValueChanged<double> onVacationBonusChanged;
  final ValueChanged<int> onPendingVacationChanged;
  final ValueChanged<bool> onReceivedBonusChanged;
  final ValueChanged<bool> onReceivedVacationChanged;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Prestaciones',
      child: Column(
        children: [
          TextFormField(
            initialValue: input.annualBonusDays.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Dias de aguinaldo al año',
              hintText: '15',
            ),
            validator: _positiveWholeNumberValidator,
            onChanged: (value) {
              onBonusDaysChanged(int.tryParse(value) ?? 15);
            },
          ),
          const SizedBox(height: AppSizes.gap),
          TextFormField(
            initialValue: input.vacationPremiumPercentage.toStringAsFixed(0),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Porcentaje prima vacacional',
              suffixText: '%',
              hintText: '25',
            ),
            validator: _positiveNumberValidator,
            onChanged: (value) {
              onVacationBonusChanged(double.tryParse(value) ?? 25);
            },
          ),
          const SizedBox(height: AppSizes.gap),
          TextFormField(
            initialValue: input.pendingVacationDays.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Dias de vacaciones pendientes',
              hintText: '0',
            ),
            validator: _wholeNumberValidator,
            onChanged: (value) {
              onPendingVacationChanged(int.tryParse(value) ?? 0);
            },
          ),
          const SizedBox(height: AppSizes.gap),
          SwitchListTile(
            value: input.receivedCurrentYearBonus,
            onChanged: onReceivedBonusChanged,
            title: const Text('Recibio aguinaldo del año actual'),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: input.receivedCurrentPeriodVacations,
            onChanged: onReceivedVacationChanged,
            title: const Text('Recibio vacaciones del periodo actual'),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _OfferStep extends StatelessWidget {
  const _OfferStep({required this.input, required this.onChanged});

  final LaborCalculationInput input;
  final ValueChanged<double?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Oferta de la empresa',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MoneyField(
            label: 'Cantidad ofrecida por la empresa',
            value: input.companyOfferAmount,
            onChanged: onChanged,
          ),
          const SizedBox(height: AppSizes.gapSmall),
          Text(
            'Este dato se usara para comparar contra el calculo estimado.',
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationStep extends StatelessWidget {
  const _ConfirmationStep({required this.input});

  final LaborCalculationInput input;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Confirmacion',
      child: Column(
        children: [
          _SummaryLine('Tipo', input.calculationType.label),
          _SummaryLine('Ingreso', _formatDate(input.startDate)),
          _SummaryLine('Salida', _formatDate(input.endDate)),
          _SummaryLine('Dias no pagados', input.unpaidWorkedDays.toString()),
          _SummaryLine(
            'Salario mensual',
            CurrencyFormatter.mxn(input.monthlySalary),
          ),
          _SummaryLine('Salario diario', _moneyOrDash(input.dailySalary)),
          _SummaryLine('SDI', _moneyOrDash(input.integratedDailySalary)),
          _SummaryLine('Aguinaldo', '${input.annualBonusDays} dias'),
          _SummaryLine(
            'Prima vacacional',
            '${input.vacationPremiumPercentage.toStringAsFixed(0)}%',
          ),
          _SummaryLine(
            'Vacaciones pendientes',
            '${input.pendingVacationDays} dias',
          ),
          _SummaryLine(
            'Aguinaldo recibido',
            input.receivedCurrentYearBonus ? 'Si' : 'No',
          ),
          _SummaryLine(
            'Vacaciones recibidas',
            input.receivedCurrentPeriodVacations ? 'Si' : 'No',
          ),
          _SummaryLine(
            'Oferta empresa',
            _moneyOrDash(input.companyOfferAmount),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step, required this.steps});

  final int step;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paso ${step + 1} de ${steps.length}',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSizes.gap),
        LinearProgressIndicator(value: (step + 1) / steps.length),
        const SizedBox(height: AppSizes.gapSmall),
        Text(
          steps[step],
          style: TextStyle(color: context.colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.gapLarge),
          child,
        ],
      ),
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
      label: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            Text(
              value,
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoneyField extends StatelessWidget {
  const _MoneyField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.requiredField = false,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(label),
      initialValue: value == null || value == 0 ? '' : _moneyInput(value!),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _MxnInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixText: r'$ ',
        suffixText: 'MXN',
        hintText: '15,000',
      ),
      validator: (value) {
        final parsed = _parseMoney(value);
        if (requiredField && parsed == null) {
          return 'Ingresa una cantidad mayor a cero.';
        }
        if (parsed != null && parsed <= 0) {
          return 'La cantidad debe ser mayor a cero.';
        }
        return null;
      },
      onChanged: (value) => onChanged(_parseMoney(value)),
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
      padding: const EdgeInsets.only(bottom: AppSizes.gap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: AppSizes.gap),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _MxnInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    final formatted = _formatWholeMoney(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

String? _wholeNumberValidator(String? value) {
  final parsed = int.tryParse(value ?? '');
  if (parsed == null || parsed < 0) {
    return 'Ingresa un numero de dias valido.';
  }
  return null;
}

String? _positiveWholeNumberValidator(String? value) {
  final parsed = int.tryParse(value ?? '');
  if (parsed == null || parsed <= 0) {
    return 'Ingresa un numero mayor a cero.';
  }
  return null;
}

String? _positiveNumberValidator(String? value) {
  final parsed = double.tryParse(value ?? '');
  if (parsed == null || parsed <= 0) {
    return 'Ingresa un porcentaje mayor a cero.';
  }
  return null;
}

String _moneyOrDash(double? value) {
  if (value == null) return '-';
  return CurrencyFormatter.mxn(value);
}

String _moneyInput(double value) {
  return _formatWholeMoney(value.round().toString());
}

double? _parseMoney(String? value) {
  final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
  if (digits.isEmpty) return null;
  return double.tryParse(digits);
}

String _formatWholeMoney(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
