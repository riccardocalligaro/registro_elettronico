import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/documents_repository.dart';

import './bloc.dart';

class DocumentAttachmentBloc
    extends Bloc<DocumentAttachmentEvent, DocumentAttachmentState> {
  DocumentsRepository documentsRepository;

  DocumentAttachmentBloc(this.documentsRepository);

  @override
  DocumentAttachmentState get initialState => DocumentAttachmentInitial();

  @override
  Stream<DocumentAttachmentState> mapEventToState(
    DocumentAttachmentEvent event,
  ) async* {
    if (event is GetDocumentAttachment) {
      yield DocumentLoadInProgress();

      final fileDb =
          await documentsRepository.getDownloadedDocument(event.document.hash);

      if (fileDb != null) {
        yield DocumentLoadedLocally(path: fileDb.path);
      } else {
        final available = await documentsRepository.checkDocument(
          event.document.hash,
        );

        yield* available.fold((failure) async* {
          yield DocumentAttachmentError();
        }, (available) async* {
          if (available) {
            final path = await documentsRepository.readDocument(
              event.document.hash,
            );
            yield path.fold(
              (failure) => DocumentAttachmentError(),
              (path) => DocumentLoadSuccess(path: path),
            );
          } else {
            yield DocumentNotAvailable();
          }
        });
      }
    } else if (event is DeleteDocumentAttachment) {
      try {
        await documentsRepository.deleteDownloadedDocument(event.document.hash);
        yield DocumentAttachmentDeleteSuccess();
      } catch (e) {
        documentsRepository.deleteAllDownloadedDocuments();
        yield DocumentAttachmentDeleteError();
      }
    }
  }
}
