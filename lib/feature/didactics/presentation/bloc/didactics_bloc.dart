import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';

part 'didactics_event.dart';
part 'didactics_state.dart';

class DidacticsBloc extends Bloc<DidacticsEvent, DidacticsState> {
  final DidacticsRepository didacticsRepository;

  DidacticsBloc({
    @required this.didacticsRepository,
  }) : super(DidacticsInitial());

  @override
  Stream<DidacticsState> mapEventToState(
    DidacticsEvent event,
  ) async* {
    if (event is GetDidactics) {
      yield DidacticsLoading();
      try {
        final teachers = await didacticsRepository.getTeachersGrouped();
        final folders = await didacticsRepository.getFolders();
        final contents = await didacticsRepository.getContents();
        FLog.info(
          text:
              'BloC -> Got ${teachers.length} teachers, ${folders.length} folders, ${contents.length} contents',
        );

        yield DidacticsLoaded(
          teachers: teachers,
          folders: folders,
          contents: contents,
        );
      } catch (e) {
        yield DidacticsError(e.toString());
      }
    }

    if (event is UpdateDidactics) {
      yield DidacticsUpdateLoading();
      try {
        await didacticsRepository.updateDidactics();

        yield DidacticsUpdateLoaded();
      } on NotConntectedException catch (_) {
        yield DidacticsErrorNotConnected();
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);

        yield DidacticsError(e.toString());
      }
    }
  }
}