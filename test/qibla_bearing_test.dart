import 'package:flutter_test/flutter_test.dart';
import 'package:awqat/core/utils/qibla_bearing.dart';

void main() {
  group('qiblaBearingFromNorth', () {
    test('Karachi bearing is roughly west-northwest', () {
      final bearing = qiblaBearingFromNorth(
        latitude: 24.8607,
        longitude: 67.0011,
      );
      expect(bearing, greaterThan(260));
      expect(bearing, lessThan(290));
    });

    test('London bearing is roughly southeast', () {
      final bearing = qiblaBearingFromNorth(
        latitude: 51.5074,
        longitude: -0.1278,
      );
      expect(bearing, greaterThan(110));
      expect(bearing, lessThan(130));
    });
  });

  group('qiblaPointerDegrees', () {
    test('wraps heading with bearing offset', () {
      expect(qiblaPointerDegrees(deviceHeading: 0, bearingFromNorth: 90), 270);
    });
  });
}
