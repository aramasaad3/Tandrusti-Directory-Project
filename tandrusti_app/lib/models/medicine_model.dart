class Medicine {
  final String id;
  final String scientificName;
  final List<String> commonBrands;
  final String indications;
  final String sideEffects;
  final String usageInstructions;

  Medicine({
    required this.id,
    required this.scientificName,
    required this.commonBrands,
    required this.indications,
    required this.sideEffects,
    required this.usageInstructions,
  });
}
