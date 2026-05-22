import 'package:equatable/equatable.dart';

class CitySearchResult extends Equatable {
  const CitySearchResult({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [label, latitude, longitude];
}
