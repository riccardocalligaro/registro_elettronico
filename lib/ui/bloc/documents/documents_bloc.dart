import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsRepository documentsRepository;

  DocumentsBloc(this.documentsRepository);

  @override
  DocumentsState get initialState => DocumentsInitial();

  @override
  Stream<DocumentsState> mapEventToState(
    DocumentsEvent event,
  ) async* {
    if (event is GetDocuments) {
      yield* _mapGetDocumentsToState();
    } else if (event is UpdateDocuments) {
      yield* _mapUpdateDocumentsToState();
    }
  }

  Stream<DocumentsState> _mapGetDocumentsToState() async* {
    yield DocumentsLoadInProgress();
    try {
      FLog.info(text: 'Getting documents and school reports');
      final data = await documentsRepository.getDocumentsAndSchoolReports();
      FLog.info(text: 'Got documents and school reports');
      FLog.info(text: 'BloC -> Got ${data.value1.length} school reports');
      FLog.info(text: 'BloC -> Got ${data.value2.length} documents');
      SharedPreferences sharedPreferences =
          Injector.appInstance.getDependency();
      await sharedPreferences.setInt(
        PrefsConstants.LAST_UPDATE_SCRUTINI,
        DateTime.now().millisecondsSinceEpoch,
      );
      yield DocumentsLoadSuccess(
        schoolReports: data.value1,
        documents: data.value2,
      );
    } catch (e, s) {
      FLog.error(
          text: 'Got error while getting documents',
          exception: e,
          stacktrace: s);
      Crashlytics.instance.recordError(e, s);
      yield DocumentsLoadError();
    }
  }

  Stream<DocumentsState> _mapUpdateDocumentsToState() async* {
    yield DocumentsUpdateLoadInProgress();
    try {
      FLog.info(text: 'Updating documents and school reports');
      await documentsRepository.updateDocuments();
      FLog.info(text: 'Successfully updated documents and school reports');
      yield DocumentsUpdateLoadSuccess();
    } on NotConntectedException {
      yield DocumentsLoadNotConnected();
    } catch (e, s) {
      FLog.error(
          text: 'Got erorr updating documents', exception: e, stacktrace: s);
      Crashlytics.instance.recordError(e, s);
      yield DocumentsUpdateLoadError();
    }
  }
}
