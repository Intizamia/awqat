import 'package:equatable/equatable.dart';
import '../domain/city_search_result.dart';

class LocationState extends Equatable {
  const LocationState({
    this.isAcquiringGps = false,
    this.isResolvingName = false,
    this.isSearching = false,
    this.searchResults = const [],
    this.searchReturnedEmpty = false,
    this.errorMessage,
  });

  final bool isAcquiringGps;
  final bool isResolvingName;
  final bool isSearching;
  final List<CitySearchResult> searchResults;
  final bool searchReturnedEmpty;
  final String? errorMessage;

  LocationState copyWith({
    bool? isAcquiringGps,
    bool? isResolvingName,
    bool? isSearching,
    List<CitySearchResult>? searchResults,
    bool? searchReturnedEmpty,
    String? errorMessage,
    bool clearError = false,
    bool clearResults = false,
  }) {
    return LocationState(
      isAcquiringGps: isAcquiringGps ?? this.isAcquiringGps,
      isResolvingName: isResolvingName ?? this.isResolvingName,
      isSearching: isSearching ?? this.isSearching,
      searchResults: clearResults ? const [] : (searchResults ?? this.searchResults),
      searchReturnedEmpty: searchReturnedEmpty ?? this.searchReturnedEmpty,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isAcquiringGps,
    isResolvingName,
    isSearching,
    searchResults,
    searchReturnedEmpty,
    errorMessage,
  ];
}
