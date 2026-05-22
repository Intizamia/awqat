sealed class LocationException implements Exception {
  const LocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class LocationPermissionDenied extends LocationException {
  const LocationPermissionDenied()
      : super('Location permission was denied.');
}

final class LocationPermissionDeniedForever extends LocationException {
  const LocationPermissionDeniedForever()
      : super('Location permission is permanently denied. Enable it in system settings.');
}

final class LocationServiceDisabled extends LocationException {
  const LocationServiceDisabled()
      : super('Location services are disabled on this device.');
}

final class LocationSearchFailed extends LocationException {
  const LocationSearchFailed([String? detail])
      : super(detail ?? 'Could not find that place. Try a different search.');
}

final class LocationGpsFailed extends LocationException {
  const LocationGpsFailed([String? detail])
      : super(detail ?? 'Could not get your current location.');
}
