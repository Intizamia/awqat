import 'package:equatable/equatable.dart';

/// Per-prayer minute adjustments (added on top of global offset).
class PrayerOffsets extends Equatable {
  const PrayerOffsets({
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
  });

  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  PrayerOffsets copyWith({
    int? fajr,
    int? sunrise,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) {
    return PrayerOffsets(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }

  Map<String, dynamic> toJson() => {
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  factory PrayerOffsets.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PrayerOffsets();
    return PrayerOffsets(
      fajr: json['fajr'] as int? ?? 0,
      sunrise: json['sunrise'] as int? ?? 0,
      dhuhr: json['dhuhr'] as int? ?? 0,
      asr: json['asr'] as int? ?? 0,
      maghrib: json['maghrib'] as int? ?? 0,
      isha: json['isha'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha];
}
