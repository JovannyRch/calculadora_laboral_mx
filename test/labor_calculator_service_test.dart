import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/labor_calculator_service.dart';
import 'package:calculadora_laboral_mx/features/calculator/data/pdf_report_service.dart';
import 'package:calculadora_laboral_mx/features/history/domain/saved_labor_calculation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = LaborCalculatorService();

  test('renuncia simple calcula dias no pagados', () {
    final result = service.calculate(
      _input(
        calculationType: CalculationType.resignation,
        unpaidWorkedDays: 2,
        receivedCurrentYearBonus: true,
        receivedCurrentPeriodVacations: true,
      ),
    );

    expect(result.settlementTotal, 2000);
    expect(result.severanceTotal, 0);
    expect(result.grossTotal, 2000);
    expect(result.netTotal, 2000);
  });

  test('despido injustificado agrega indemnizaciones', () {
    final result = service.calculate(
      _input(
        calculationType: CalculationType.unjustifiedDismissal,
        startDate: DateTime(2024, 3),
        endDate: DateTime(2026, 3),
        monthlySalary: 30000,
        integratedDailySalary: 1200,
        receivedCurrentYearBonus: true,
        receivedCurrentPeriodVacations: true,
      ),
    );

    expect(result.severanceTotal, 171121.92);
    expect(
      result.breakdownItems.any(
        (item) => item.title == 'Indemnizacion constitucional',
      ),
      isTrue,
    );
  });

  test('prima de antiguedad usa salario topado', () {
    final result = service.calculate(
      _input(
        calculationType: CalculationType.unjustifiedDismissal,
        startDate: DateTime(2024, 3),
        endDate: DateTime(2026, 3),
        monthlySalary: 90000,
        integratedDailySalary: 5000,
        receivedCurrentYearBonus: true,
        receivedCurrentPeriodVacations: true,
      ),
    );

    final seniorityPremium = result.breakdownItems.singleWhere(
      (item) => item.title == 'Prima de antiguedad',
    );

    expect(seniorityPremium.amount, 15121.92);
    expect(seniorityPremium.formula, contains('min(sdi'));
  });

  test('vacaciones proporcionales siguen tabla por antiguedad', () {
    final result = service.calculate(
      _input(
        calculationType: CalculationType.resignation,
        startDate: DateTime(2025),
        endDate: DateTime(2025, 7, 2),
        receivedCurrentYearBonus: true,
      ),
    );

    final vacations = result.breakdownItems.singleWhere(
      (item) => item.title == 'Vacaciones proporcionales',
    );

    expect(vacations.amount, 5983.56);
    expect(vacations.description, contains('12 dias'));
  });

  test('compara contra oferta de empresa', () {
    final result = service.calculate(
      _input(
        calculationType: CalculationType.resignation,
        unpaidWorkedDays: 2,
        receivedCurrentYearBonus: true,
        receivedCurrentPeriodVacations: true,
        companyOfferAmount: 1500,
      ),
    );

    expect(result.netTotal, 2000);
    expect(result.companyOfferDifference, -500);
    expect(result.companyOfferDifferencePercentage, -25);
  });

  test('calculo guardado serializa input y resultado', () {
    final input = _input(
      calculationType: CalculationType.resignation,
      companyOfferAmount: 1500,
    );
    final result = service.calculate(input);
    final saved = SavedLaborCalculation(
      id: 'saved-1',
      title: 'Renuncia - Junio 2026',
      createdAt: DateTime(2026, 6),
      input: input,
      result: result,
      calculationType: input.calculationType,
      monthlySalary: input.monthlySalary,
      netTotal: result.netTotal,
      grossTotal: result.grossTotal,
    );

    final restored = SavedLaborCalculation.fromMap(saved.toMap());

    expect(restored.id, 'saved-1');
    expect(restored.title, 'Renuncia - Junio 2026');
    expect(restored.input.companyOfferAmount, 1500);
    expect(restored.result.netTotal, result.netTotal);
  });

  test('reporte PDF genera bytes validos', () async {
    final input = _input(
      calculationType: CalculationType.resignation,
      companyOfferAmount: 1500,
    );
    final result = service.calculate(input);

    final bytes = await const PdfReportService().buildReport(
      input: input,
      result: result,
      generatedAt: DateTime(2026, 6),
    );

    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}

LaborCalculationInput _input({
  required CalculationType calculationType,
  DateTime? startDate,
  DateTime? endDate,
  double monthlySalary = 30000,
  double? dailySalary,
  double? integratedDailySalary,
  int unpaidWorkedDays = 0,
  int annualBonusDays = 15,
  double vacationPremiumPercentage = 25,
  int pendingVacationDays = 0,
  bool receivedCurrentYearBonus = false,
  bool receivedCurrentPeriodVacations = false,
  double? companyOfferAmount,
}) {
  return LaborCalculationInput(
    calculationType: calculationType,
    startDate: startDate ?? DateTime(2026),
    endDate: endDate ?? DateTime(2026, 2),
    monthlySalary: monthlySalary,
    dailySalary: dailySalary,
    integratedDailySalary: integratedDailySalary,
    unpaidWorkedDays: unpaidWorkedDays,
    annualBonusDays: annualBonusDays,
    vacationPremiumPercentage: vacationPremiumPercentage,
    pendingVacationDays: pendingVacationDays,
    receivedCurrentYearBonus: receivedCurrentYearBonus,
    receivedCurrentPeriodVacations: receivedCurrentPeriodVacations,
    companyOfferAmount: companyOfferAmount,
  );
}
