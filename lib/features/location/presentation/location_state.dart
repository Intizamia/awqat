import 'package:equatable/equatable.dart';
import 'package:times/features/location/domain/city_search_result.dart';

class LocationState extends Equatable {
  const LocationState({
    this.isAcquiringGps = false,
    this.isSearching = false,
    this.searchResults = const [],
    this.errorMessage,
  });

  final bool isAcquiringGps;
  final bool isSearching;
  final List<CitySearchResult> searchResults;
  final String? errorMessage;

  LocationState copyWith({
    bool? isAcquiringGps,
    bool? isSearching,
    List<CitySearchResult>? searchResults,
    String? errorMessage,
    bool clearError = false,
    bool clearResults = false,
  }) {
    return LocationState(
      isAcquiringGps: isAcquiringGps ?? this.isAcquiringGps,
      isSearching: isSearching ?? this.isSearching,
      searchResults:
          clearResults ? const [] : (searchResults ?? this.searchResults),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [isAcquiringGps, isSearching, searchResults, errorMessage];
}
