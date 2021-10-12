import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';

part 'documents_event.dart';
part 'documents_state.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final DocumentsRepository? documentsRepository;

  DocumentsBloc({
    required this.documentsRepository,
  }) : super(DocumentsInitial());

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
      Fimber.i('Getting documents and school reports');
      final data = await documentsRepository!.getDocumentsAndSchoolReports();
      Fimber.i('Got documents and school reports');
      Fimber.i('BloC -> Got ${data.value1.length} school reports');
      Fimber.i('BloC -> Got ${data.value2.length} documents');

      yield DocumentsLoadSuccess(
        schoolReports: data.value1,
        documents: data.value2,
      );
    } catch (e) {
      yield DocumentsLoadError();
    }
  }

  Stream<DocumentsState> _mapUpdateDocumentsToState() async* {
    yield DocumentsUpdateLoadInProgress();
    try {
      Fimber.i('Updating documents and school reports');
      await documentsRepository!.updateDocuments();
      Fimber.i('Successfully updated documents and school reports');
      yield DocumentsUpdateLoadSuccess();
    } on NotConntectedException {
      yield DocumentsLoadNotConnected();
    } catch (e) {
      yield DocumentsUpdateLoadError();
    }
  }
}
