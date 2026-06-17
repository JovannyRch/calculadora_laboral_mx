import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';

class LaborCalculationInput {
  const LaborCalculationInput({
    required this.calculationType,
    required this.startDate,
    required this.endDate,
    required this.unpaidWorkedDays,
    required this.monthlySalary,
    required this.dailySalary,
    required this.integratedDailySalary,
    required this.annualBonusDays,
    required this.vacationPremiumPercentage,
    required this.pendingVacationDays,
    required this.receivedCurrentYearBonus,
    required this.receivedCurrentPeriodVacations,
    required this.companyOfferAmount,
  });

  final CalculationType calculationType;
  final DateTime startDate;
  final DateTime endDate;
  final int unpaidWorkedDays;
  final double monthlySalary;
  final double? dailySalary;
  final double? integratedDailySalary;
  final int annualBonusDays;
  final double vacationPremiumPercentage;
  final int pendingVacationDays;
  final bool receivedCurrentYearBonus;
  final bool receivedCurrentPeriodVacations;
  final double? companyOfferAmount;

  Map<String, dynamic> toMap() {
    return {
      'calculationType': calculationType.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'unpaidWorkedDays': unpaidWorkedDays,
      'monthlySalary': monthlySalary,
      'dailySalary': dailySalary,
      'integratedDailySalary': integratedDailySalary,
      'annualBonusDays': annualBonusDays,
      'vacationPremiumPercentage': vacationPremiumPercentage,
      'pendingVacationDays': pendingVacationDays,
      'receivedCurrentYearBonus': receivedCurrentYearBonus,
      'receivedCurrentPeriodVacations': receivedCurrentPeriodVacations,
      'companyOfferAmount': companyOfferAmount,
    };
  }

  factory LaborCalculationInput.fromMap(Map<dynamic, dynamic> map) {
    return LaborCalculationInput(
      calculationType: CalculationType.values.firstWhere(
        (type) => type.name == map['calculationType'],
        orElse: () => CalculationType.resignation,
      ),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      unpaidWorkedDays: (map['unpaidWorkedDays'] as num).toInt(),
      monthlySalary: (map['monthlySalary'] as num).toDouble(),
      dailySalary: (map['dailySalary'] as num?)?.toDouble(),
      integratedDailySalary: (map['integratedDailySalary'] as num?)?.toDouble(),
      annualBonusDays: (map['annualBonusDays'] as num).toInt(),
      vacationPremiumPercentage: (map['vacationPremiumPercentage'] as num)
          .toDouble(),
      pendingVacationDays: (map['pendingVacationDays'] as num).toInt(),
      receivedCurrentYearBonus: map['receivedCurrentYearBonus'] as bool,
      receivedCurrentPeriodVacations:
          map['receivedCurrentPeriodVacations'] as bool,
      companyOfferAmount: (map['companyOfferAmount'] as num?)?.toDouble(),
    );
  }

  LaborCalculationInput copyWith({
    CalculationType? calculationType,
    DateTime? startDate,
    DateTime? endDate,
    int? unpaidWorkedDays,
    double? monthlySalary,
    double? dailySalary,
    bool clearDailySalary = false,
    double? integratedDailySalary,
    bool clearIntegratedDailySalary = false,
    int? annualBonusDays,
    double? vacationPremiumPercentage,
    int? pendingVacationDays,
    bool? receivedCurrentYearBonus,
    bool? receivedCurrentPeriodVacations,
    double? companyOfferAmount,
    bool clearCompanyOffer = false,
  }) {
    return LaborCalculationInput(
      calculationType: calculationType ?? this.calculationType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      unpaidWorkedDays: unpaidWorkedDays ?? this.unpaidWorkedDays,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      dailySalary: clearDailySalary ? null : dailySalary ?? this.dailySalary,
      integratedDailySalary: clearIntegratedDailySalary
          ? null
          : integratedDailySalary ?? this.integratedDailySalary,
      annualBonusDays: annualBonusDays ?? this.annualBonusDays,
      vacationPremiumPercentage:
          vacationPremiumPercentage ?? this.vacationPremiumPercentage,
      pendingVacationDays: pendingVacationDays ?? this.pendingVacationDays,
      receivedCurrentYearBonus:
          receivedCurrentYearBonus ?? this.receivedCurrentYearBonus,
      receivedCurrentPeriodVacations:
          receivedCurrentPeriodVacations ?? this.receivedCurrentPeriodVacations,
      companyOfferAmount: clearCompanyOffer
          ? null
          : companyOfferAmount ?? this.companyOfferAmount,
    );
  }
}
