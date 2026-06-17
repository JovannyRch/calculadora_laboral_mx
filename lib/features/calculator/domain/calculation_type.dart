enum CalculationType {
  resignation,
  unjustifiedDismissal,
  contractEnd,
  mutualAgreement;

  String get label {
    return switch (this) {
      CalculationType.resignation => 'Renuncia voluntaria',
      CalculationType.unjustifiedDismissal => 'Despido injustificado',
      CalculationType.contractEnd => 'Fin de contrato',
      CalculationType.mutualAgreement => 'Mutuo acuerdo',
    };
  }
}
