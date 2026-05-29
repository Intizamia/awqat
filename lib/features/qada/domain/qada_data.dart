import 'package:equatable/equatable.dart';

enum QadaPrayer { fajr, dhuhr, asr, maghrib, isha }

extension QadaPrayerLabel on QadaPrayer {
  String get label => switch (this) {
        QadaPrayer.fajr => 'Fajr',
        QadaPrayer.dhuhr => 'Dhuhr',
        QadaPrayer.asr => 'Asr',
        QadaPrayer.maghrib => 'Maghrib',
        QadaPrayer.isha => 'Isha',
      };
}

class QadaEntry extends Equatable {
  const QadaEntry({required this.prayer, required this.count, this.updatedAt});

  final QadaPrayer prayer;
  final int count;
  final DateTime? updatedAt;

  QadaEntry copyWith({int? count, DateTime? updatedAt}) => QadaEntry(
        prayer: prayer,
        count: count ?? this.count,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [prayer, count, updatedAt];
}

class QadaData extends Equatable {
  const QadaData({required this.entries});

  factory QadaData.empty() => QadaData(
        entries: QadaPrayer.values
            .map((p) => QadaEntry(prayer: p, count: 0))
            .toList(),
      );

  final List<QadaEntry> entries;

  QadaEntry entryFor(QadaPrayer prayer) =>
      entries.firstWhere((e) => e.prayer == prayer);

  QadaData withUpdated(QadaEntry updated) => QadaData(
        entries: entries.map((e) => e.prayer == updated.prayer ? updated : e).toList(),
      );

  @override
  List<Object?> get props => [entries];
}
