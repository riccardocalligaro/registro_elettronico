import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';

part 'document_attachment_event.dart';
part 'document_attachment_state.dart';

class DocumentAttachmentBloc
    extends Bloc<DocumentAttachmentEvent, DocumentAttachmentState> {
  final DocumentsRepository? documentsRepository;

  DocumentAttachmentBloc({
    required this.documentsRepository,
  }) : super(DocumentAttachmentInitial());

  @override
  Stream<DocumentAttachmentState> mapEventToState(
    DocumentAttachmentEvent event,
  ) async* {
    if (event is GetDocumentAttachment) {
      yield DocumentLoadInProgress();

      try {
        final fileDb = await documentsRepository!
            .getDownloadedDocument(event.document.hash);

        if (fileDb != null) {
          Fimber.i('Got file in database ${fileDb.hash}');
          yield DocumentLoadedLocally(path: fileDb.path);
        } else {
          final available = await documentsRepository!.checkDocument(
            event.document.hash!,
          );

          Fimber.i('File available: ${available.toString()}');

          yield* available.fold((failure) async* {
            Fimber.i('File available failure');
            yield DocumentAttachmentError();
          }, (available) async* {
            if (available) {
              Fimber.i('Reading document from repository');
              final path = await documentsRepository!.readDocument(
                event.document.hash!,
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
      } on NotConntectedException {
        yield DocumentLoadNotConnected();
      }
    } else if (event is DeleteDocumentAttachment) {
      try {
        await documentsRepository!
            .deleteDownloadedDocument(event.document.hash);
        Fimber.i('Deleted file hash: ${event.document.hash}');
        yield DocumentAttachmentDeleteSuccess();
      } catch (e) {
        await documentsRepository!.deleteAllDownloadedDocuments();
        yield DocumentAttachmentDeleteError();
      }
    }
  }
}
