import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';

import './bloc.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  TimetableRepository timetableRepository;

  TimetableBloc(this.timetableRepository);

  @override
  TimetableState get initialState => TimetableInitial();

  @override
  Stream<TimetableState> mapEventToState(
    TimetableEvent event,
  ) async* {
    if (event is GetTimetable) {
      yield TimetableLoading();
      try {
        final timetable = await timetableRepository.getTimetableMap();
        yield TimetableLoaded(timetable: timetable);
      } catch (e) {
        yield TimetableError(e.toString());
      }
    }

    if (event is GetNewTimetable) {
      yield TimetableLoading();
      try {
        await timetableRepository.updateTimeTable(event.begin, event.end);
        final timetable = await timetableRepository.getTimetableMap();
        yield TimetableLoaded(timetable: timetable);
      } catch (e) {
        yield TimetableError(e.toString());
      }
    }
  }
}
