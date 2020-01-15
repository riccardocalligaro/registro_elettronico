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
  }
}
