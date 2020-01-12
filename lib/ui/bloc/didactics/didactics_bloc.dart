import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

class DidacticsBloc extends Bloc<DidacticsEvent, DidacticsState> {
  DidacticsRepository didacticsRepository;

  DidacticsBloc(this.didacticsRepository);

  @override
  DidacticsState get initialState => DidacticsInitial();

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
        await didacticsRepository.deleteAllDidactics();
        await didacticsRepository.updateDidactics();

        final prefs = await SharedPreferences.getInstance();

        prefs.setInt(PrefsConstants.LAST_UPDATE_SCHOOL_MATERIAL,
            DateTime.now().millisecondsSinceEpoch);

        yield DidacticsUpdateLoaded();
      } catch (e) {
        yield DidacticsError(e.toString());
      }
    }
  }
}
