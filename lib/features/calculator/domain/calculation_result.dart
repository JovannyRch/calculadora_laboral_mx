class LaborCalculationResult {
  const LaborCalculationResult({
    required this.grossTotal,
    required this.estimatedTax,
    required this.netTotal,
    required this.severanceTotal,
    required this.settlementTotal,
    required this.companyOfferDifference,
    required this.companyOfferDifferencePercentage,
    required this.breakdownItems,
  });

  final double grossTotal;
  final double estimatedTax;
  final double netTotal;
  final double severanceTotal;
  final double settlementTotal;
  final double? companyOfferDifference;
  final double? companyOfferDifferencePercentage;
  final List<BreakdownItem> breakdownItems;

  Map<String, dynamic> toMap() {
    return {
      'grossTotal': grossTotal,
      'estimatedTax': estimatedTax,
      'netTotal': netTotal,
      'severanceTotal': severanceTotal,
      'settlementTotal': settlementTotal,
      'companyOfferDifference': companyOfferDifference,
      'companyOfferDifferencePercentage': companyOfferDifferencePercentage,
      'breakdownItems': breakdownItems.map((item) => item.toMap()).toList(),
    };
  }

  factory LaborCalculationResult.fromMap(Map<dynamic, dynamic> map) {
    return LaborCalculationResult(
      grossTotal: (map['grossTotal'] as num).toDouble(),
      estimatedTax: (map['estimatedTax'] as num).toDouble(),
      netTotal: (map['netTotal'] as num).toDouble(),
      severanceTotal: (map['severanceTotal'] as num).toDouble(),
      settlementTotal: (map['settlementTotal'] as num).toDouble(),
      companyOfferDifference: (map['companyOfferDifference'] as num?)
          ?.toDouble(),
      companyOfferDifferencePercentage:
          (map['companyOfferDifferencePercentage'] as num?)?.toDouble(),
      breakdownItems: (map['breakdownItems'] as List<dynamic>)
          .map((item) => BreakdownItem.fromMap(item as Map<dynamic, dynamic>))
          .toList(),
    );
  }
}

class BreakdownItem {
  const BreakdownItem({
    required this.title,
    required this.description,
    required this.amount,
    required this.formula,
    required this.category,
    this.legalBasis = '',
    this.legalNote = '',
  });

  final String title;
  final String description;
  final double amount;
  final String formula;
  final BreakdownCategory category;
  final String legalBasis;
  final String legalNote;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'formula': formula,
      'category': category.name,
      'legalBasis': legalBasis,
      'legalNote': legalNote,
    };
  }

  factory BreakdownItem.fromMap(Map<dynamic, dynamic> map) {
    return BreakdownItem(
      title: map['title'] as String,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      formula: map['formula'] as String,
      category: BreakdownCategory.values.firstWhere(
        (category) => category.name == map['category'],
        orElse: () => BreakdownCategory.settlement,
      ),
      legalBasis: map['legalBasis'] as String? ?? '',
      legalNote: map['legalNote'] as String? ?? '',
    );
  }
}

enum BreakdownCategory { settlement, severance, tax, comparison }
