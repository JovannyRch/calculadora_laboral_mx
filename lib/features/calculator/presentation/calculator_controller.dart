import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calculatorInputProvider =
    NotifierProvider<CalculatorInputController, LaborCalculationInput>(
      CalculatorInputController.new,
    );

class CalculatorInputController extends Notifier<LaborCalculationInput> {
  @override
  LaborCalculationInput build() {
    final now = DateTime.now();
    return LaborCalculationInput(
      calculationType: CalculationType.resignation,
      monthlySalary: 15000,
      startDate: DateTime(now.year - 1, now.month, now.day),
      endDate: now,
      unpaidWorkedDays: 0,
      dailySalary: null,
      integratedDailySalary: null,
      annualBonusDays: 15,
      vacationPremiumPercentage: 25,
      pendingVacationDays: 0,
      receivedCurrentYearBonus: false,
      receivedCurrentPeriodVacations: false,
      companyOfferAmount: null,
    );
  }

  void setType(CalculationType type) {
    state = state.copyWith(calculationType: type);
  }

  void setInput(LaborCalculationInput input) {
    state = input;
  }

  void setMonthlySalary(double salary) {
    state = state.copyWith(monthlySalary: salary);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void setUnpaidWorkedDays(int days) {
    state = state.copyWith(unpaidWorkedDays: days);
  }

  void setDailySalary(double? salary) {
    state = state.copyWith(
      dailySalary: salary,
      clearDailySalary: salary == null,
    );
  }

  void setIntegratedDailySalary(double? salary) {
    state = state.copyWith(
      integratedDailySalary: salary,
      clearIntegratedDailySalary: salary == null,
    );
  }

  void setYearlyChristmasBonusDays(int days) {
    state = state.copyWith(annualBonusDays: days);
  }

  void setVacationBonusPercentage(double percentage) {
    state = state.copyWith(vacationPremiumPercentage: percentage);
  }

  void setPendingVacationDays(int days) {
    state = state.copyWith(pendingVacationDays: days);
  }

  void setReceivedCurrentYearBonus(bool value) {
    state = state.copyWith(receivedCurrentYearBonus: value);
  }

  void setReceivedCurrentPeriodVacation(bool value) {
    state = state.copyWith(receivedCurrentPeriodVacations: value);
  }

  void setCompanyOffer(double? offer) {
    state = state.copyWith(
      companyOfferAmount: offer,
      clearCompanyOffer: offer == null,
    );
  }
}
