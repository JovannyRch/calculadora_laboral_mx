import 'dart:math';

import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_result.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';

class LaborCalculatorService {
  const LaborCalculatorService({this.minimumDailyWage = 315.04});

  static const _salaryBasis =
      'LFT art. 89. Para indemnizaciones se toma como base el salario diario.';
  static const _bonusBasis =
      'LFT art. 87. Aguinaldo minimo de 15 dias y pago proporcional.';
  static const _vacationBasis =
      'LFT arts. 76 y 79. Dias de vacaciones por antiguedad y pago proporcional.';
  static const _vacationPremiumBasis =
      'LFT art. 80. Prima no menor de 25% sobre salarios de vacaciones.';
  static const _constitutionalBasis =
      'LFT arts. 48 y 50. Indemnizacion de tres meses de salario.';
  static const _twentyDaysBasis =
      'LFT art. 50. Veinte dias de salario por cada año de servicios.';
  static const _seniorityPremiumBasis =
      'LFT art. 162, relacionado con arts. 485 y 486. Doce dias por año con salario topado.';
  static const _taxBasis =
      'ISR no calculado en esta version. Campo preparado para integracion fiscal futura.';
  static const _comparisonBasis =
      'Comparacion aritmetica informativa; no es un concepto laboral legal.';

  final double minimumDailyWage;

  LaborCalculationResult calculate(LaborCalculationInput input) {
    final dailySalary = input.dailySalary ?? input.monthlySalary / 30;
    final integratedDailySalary = input.integratedDailySalary ?? dailySalary;
    final yearsWorked = _yearsWorked(input.startDate, input.endDate);
    final currentYearRatio = _currentYearRatio(input.startDate, input.endDate);
    final vacationDays = _vacationDaysForYears(yearsWorked);
    final vacationRatio = _vacationPeriodRatio(yearsWorked);
    final cappedDailySalary = min(integratedDailySalary, minimumDailyWage * 2);

    final items = <BreakdownItem>[
      BreakdownItem(
        title: 'Dias trabajados no pagados',
        description: '${input.unpaidWorkedDays} dias pendientes de pago.',
        amount: _round(dailySalary * input.unpaidWorkedDays),
        formula: 'salario diario * dias pendientes',
        category: BreakdownCategory.settlement,
        legalBasis: _salaryBasis,
        legalNote:
            'Corresponde a salario devengado pendiente de pago capturado por el usuario.',
      ),
      BreakdownItem(
        title: 'Aguinaldo proporcional',
        description: input.receivedCurrentYearBonus
            ? 'Ya fue pagado para el años actual.'
            : 'Parte proporcional del aguinaldo del años actual.',
        amount: input.receivedCurrentYearBonus
            ? 0
            : _round(dailySalary * input.annualBonusDays * currentYearRatio),
        formula: 'salario diario * dias de aguinaldo * proporcion anual',
        category: BreakdownCategory.settlement,
        legalBasis: _bonusBasis,
        legalNote:
            'Se usa la proporcion del año calendario trabajado hasta la fecha de salida.',
      ),
      BreakdownItem(
        title: 'Vacaciones proporcionales',
        description: input.receivedCurrentPeriodVacations
            ? 'Ya fueron pagadas para el periodo actual.'
            : '$vacationDays dias anuales por antiguedad.',
        amount: input.receivedCurrentPeriodVacations
            ? 0
            : _round(dailySalary * vacationDays * vacationRatio),
        formula: 'salario diario * dias de vacaciones * proporcion periodo',
        category: BreakdownCategory.settlement,
        legalBasis: _vacationBasis,
        legalNote:
            'Los dias anuales se toman de la tabla legal vigente por antiguedad.',
      ),
      BreakdownItem(
        title: 'Vacaciones pendientes',
        description: '${input.pendingVacationDays} dias capturados.',
        amount: _round(dailySalary * input.pendingVacationDays),
        formula: 'salario diario * dias de vacaciones pendientes',
        category: BreakdownCategory.settlement,
        legalBasis: _vacationBasis,
        legalNote:
            'Se calculan con los dias pendientes capturados por el usuario.',
      ),
    ];

    final vacationAmount = items
        .where((item) {
          return item.title == 'Vacaciones proporcionales' ||
              item.title == 'Vacaciones pendientes';
        })
        .fold(0.0, (total, item) => total + item.amount);

    items.add(
      BreakdownItem(
        title: 'Prima vacacional',
        description: '${input.vacationPremiumPercentage}% sobre vacaciones.',
        amount: _round(vacationAmount * input.vacationPremiumPercentage / 100),
        formula: 'vacaciones * porcentaje prima vacacional',
        category: BreakdownCategory.settlement,
        legalBasis: _vacationPremiumBasis,
        legalNote:
            'El porcentaje predeterminado es 25%, editable si el contrato otorga mas.',
      ),
    );

    if (input.calculationType == CalculationType.unjustifiedDismissal) {
      items.addAll([
        BreakdownItem(
          title: 'Indemnizacion constitucional',
          description: 'Tres meses de salario diario integrado.',
          amount: _round(integratedDailySalary * 90),
          formula: 'salario diario integrado * 90 dias',
          category: BreakdownCategory.severance,
          legalBasis: _constitutionalBasis,
          legalNote:
              'Estimacion general para despido injustificado; la procedencia depende del caso.',
        ),
        BreakdownItem(
          title: 'Prima de antiguedad',
          description: 'Salario diario integrado topado a 2 salarios minimos.',
          amount: _round(cappedDailySalary * 12 * yearsWorked),
          formula:
              'min(sdi, salario minimo diario * 2) * 12 dias * años trabajados',
          category: BreakdownCategory.severance,
          legalBasis: _seniorityPremiumBasis,
          legalNote:
              'Se usa el tope de dos salarios minimos diarios para el salario base.',
        ),
        BreakdownItem(
          title: '20 dias por año',
          description: 'Indemnizacion adicional por años trabajados.',
          amount: _round(integratedDailySalary * 20 * yearsWorked),
          formula: 'salario diario integrado * 20 dias * años trabajados',
          category: BreakdownCategory.severance,
          legalBasis: _twentyDaysBasis,
          legalNote:
              'Concepto sujeto a supuestos legales y a la accion laboral ejercida.',
        ),
      ]);
    }

    const estimatedTax = 0.0;
    final settlementTotal = _sum(items, BreakdownCategory.settlement);
    final severanceTotal = _sum(items, BreakdownCategory.severance);
    final grossTotal = _round(settlementTotal + severanceTotal);
    final netTotal = _round(grossTotal - estimatedTax);
    final offer = input.companyOfferAmount;
    final offerDifference = offer == null ? null : _round(offer - netTotal);
    final offerDifferencePercentage = offer == null || netTotal == 0
        ? null
        : _round((offer - netTotal) / netTotal * 100);

    items.add(
      const BreakdownItem(
        title: 'ISR estimado',
        description: 'Pendiente de integrar tabla fiscal.',
        amount: estimatedTax,
        formula: 'ISR estimado = 0 por ahora',
        category: BreakdownCategory.tax,
        legalBasis: _taxBasis,
        legalNote:
            'No sustituye una determinacion fiscal; se mantiene en cero temporalmente.',
      ),
    );

    if (offer != null) {
      items.add(
        BreakdownItem(
          title: 'Comparacion contra oferta',
          description: 'Diferencia entre oferta de empresa y total neto.',
          amount: offerDifference ?? 0,
          formula: 'oferta de empresa - total neto estimado',
          category: BreakdownCategory.comparison,
          legalBasis: _comparisonBasis,
          legalNote:
              'Sirve solo para contrastar la oferta contra el total neto estimado.',
        ),
      );
    }

    return LaborCalculationResult(
      grossTotal: grossTotal,
      estimatedTax: estimatedTax,
      netTotal: netTotal,
      severanceTotal: severanceTotal,
      settlementTotal: settlementTotal,
      companyOfferDifference: offerDifference,
      companyOfferDifferencePercentage: offerDifferencePercentage,
      breakdownItems: List.unmodifiable(items),
    );
  }

  static double _sum(List<BreakdownItem> items, BreakdownCategory category) {
    return _round(
      items
          .where((item) => item.category == category)
          .fold(0.0, (total, item) => total + item.amount),
    );
  }

  static double _yearsWorked(DateTime start, DateTime end) {
    if (end.isBefore(start)) return 0;
    return end.difference(start).inDays / 365;
  }

  static double _currentYearRatio(DateTime start, DateTime end) {
    if (end.isBefore(start)) return 0;
    final yearStart = DateTime(end.year);
    final workedFrom = start.isAfter(yearStart) ? start : yearStart;
    final daysInYear = DateTime(end.year + 1).difference(yearStart).inDays;
    final workedDays = end.difference(workedFrom).inDays + 1;
    return workedDays.clamp(0, daysInYear) / daysInYear;
  }

  static int _vacationDaysForYears(double yearsWorked) {
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

  static double _vacationPeriodRatio(double yearsWorked) {
    if (yearsWorked <= 0) return 0;
    if (yearsWorked < 1) return yearsWorked;
    final fraction = yearsWorked - yearsWorked.floor();
    return fraction == 0 ? 1 : fraction;
  }

  static double _round(double value) {
    return (value * 100).roundToDouble() / 100;
  }
}
