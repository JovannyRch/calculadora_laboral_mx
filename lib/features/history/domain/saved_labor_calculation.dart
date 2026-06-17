import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_input.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_result.dart';
import 'package:calculadora_laboral_mx/features/calculator/domain/calculation_type.dart';

class SavedLaborCalculation {
  const SavedLaborCalculation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.input,
    required this.result,
    required this.calculationType,
    required this.monthlySalary,
    required this.netTotal,
    required this.grossTotal,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final LaborCalculationInput input;
  final LaborCalculationResult result;
  final CalculationType calculationType;
  final double monthlySalary;
  final double netTotal;
  final double grossTotal;

  SavedLaborCalculation copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    LaborCalculationInput? input,
    LaborCalculationResult? result,
  }) {
    final nextInput = input ?? this.input;
    final nextResult = result ?? this.result;
    return SavedLaborCalculation(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      input: nextInput,
      result: nextResult,
      calculationType: nextInput.calculationType,
      monthlySalary: nextInput.monthlySalary,
      netTotal: nextResult.netTotal,
      grossTotal: nextResult.grossTotal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'input': input.toMap(),
      'result': result.toMap(),
      'calculationType': calculationType.name,
      'monthlySalary': monthlySalary,
      'netTotal': netTotal,
      'grossTotal': grossTotal,
    };
  }

  factory SavedLaborCalculation.fromMap(Map<dynamic, dynamic> map) {
    final input = LaborCalculationInput.fromMap(
      map['input'] as Map<dynamic, dynamic>,
    );
    final result = LaborCalculationResult.fromMap(
      map['result'] as Map<dynamic, dynamic>,
    );
    return SavedLaborCalculation(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      input: input,
      result: result,
      calculationType: CalculationType.values.firstWhere(
        (type) => type.name == map['calculationType'],
        orElse: () => input.calculationType,
      ),
      monthlySalary: (map['monthlySalary'] as num).toDouble(),
      netTotal: (map['netTotal'] as num).toDouble(),
      grossTotal: (map['grossTotal'] as num).toDouble(),
    );
  }
}
