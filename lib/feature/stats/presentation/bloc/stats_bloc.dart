import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/feature/stats/data/model/student_report.dart';
import 'package:registro_elettronico/feature/stats/domain/repository/stats_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final StatsRepository statsRepository;

  StatsBloc({
    @required this.statsRepository,
  }) : super(StatsInitial());

  @override
  Stream<StatsState> mapEventToState(
    StatsEvent event,
  ) async* {
    if (event is UpdateStudentStats) {
      yield* _mapUpdateStudentsEventToState();
    } else if (event is GetStudentStats) {
      yield* _mapGetStudentsStatsEventToState();
    }
  }

  Stream<StatsState> _mapUpdateStudentsEventToState() async* {}

  Stream<StatsState> _mapGetStudentsStatsEventToState() async* {
    yield StatsLoadInProgress();
    try {
      final stats = await statsRepository.getStudentReport();
      yield stats.fold(
        (failure) {
          FLog.error(text: 'Error getting student report');
          return StatsLoadError();
        },
        (report) => StatsLoadSuccess(studentReport: report),
      );
    } catch (e, s) {
      FLog.error(exception: e, stacktrace: s, text: 'Error getting user stats');
    }
  }
}