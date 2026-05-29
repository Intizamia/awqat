import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/qada_repository.dart';
import '../domain/qada_data.dart';

class QadaCubit extends Cubit<QadaData> {
  QadaCubit(this._repo) : super(QadaData.empty());

  final QadaRepository _repo;

  Future<void> load() async {
    emit(await _repo.load());
  }

  Future<void> increment(QadaPrayer prayer) async {
    final entry = state.entryFor(prayer);
    if (entry.count >= 99) return;
    final updated = entry.copyWith(
      count: entry.count + 1,
      updatedAt: DateTime.now(),
    );
    final next = state.withUpdated(updated);
    emit(next);
    await _repo.save(next);
  }

  Future<void> decrement(QadaPrayer prayer) async {
    final entry = state.entryFor(prayer);
    if (entry.count <= 0) return;
    final updated = entry.copyWith(
      count: entry.count - 1,
      updatedAt: DateTime.now(),
    );
    final next = state.withUpdated(updated);
    emit(next);
    await _repo.save(next);
  }
}
