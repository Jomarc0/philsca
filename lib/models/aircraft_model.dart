class AircraftModel {
  final String name;
  final String imageAsset;
  final double maxWeightKg;
  final double emptyWeightKg;
  final double usefulLoadKg;
  final double forwardCgLimitIn;
  final double aftCgLimitIn;
  final String datum;

  const AircraftModel({
    required this.name,
    this.imageAsset = 'assets/images/cessna_172.png',
    required this.maxWeightKg,
    required this.emptyWeightKg,
    required this.usefulLoadKg,
    required this.forwardCgLimitIn,
    required this.aftCgLimitIn,
    this.datum = 'Leading Edge',
  });

  static const cessna172 = AircraftModel(
    name: 'Cessna 172',
    maxWeightKg: 1111,
    emptyWeightKg: 757,
    usefulLoadKg: 354,
    forwardCgLimitIn: 31.0,
    aftCgLimitIn: 36.0,
  );
}
