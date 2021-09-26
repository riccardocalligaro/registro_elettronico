import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/text_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/url_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/content_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/didactics_file.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';

part 'didactics_attachment_event.dart';
part 'didactics_attachment_state.dart';

class DidacticsAttachmentBloc
    extends Bloc<DidacticsAttachmentEvent, DidacticsAttachmentState> {
  final DidacticsRepository? didacticsRepository;

  late StreamSubscription _downloadSubscription;

  DidacticsAttachmentBloc({
    required this.didacticsRepository,
  }) : super(DidacticsAttachmentInitial());

  @override
  Stream<DidacticsAttachmentState> mapEventToState(
    DidacticsAttachmentEvent event,
  ) async* {
    if (event is DidacticsAttachmentErrorEvent) {
      yield DidacticsAttachmentDownloadFailure(failure: event.failure);
    } else if (event is DidacticsAttachmentFinishedEvent) {
      yield DidacticsAttachmentFileDownloadSuccess(didacticsFile: event.file);
    } else if (event is DidacticsAttachmentProgressTickedEvent) {
      yield DidacticsAttachmentDownloadInProgress(percentage: event.value);
    } else if (event is DownloadContentAttachment) {
      // se non è un file mostriamo la circular progress bar 'infinita'
      if (event.contentDomainModel.type != ContentType.file) {
        yield DidacticsAttachmentDownloadInProgress(percentage: -1);
      }

      if (event.contentDomainModel.type == ContentType.file) {
        _downloadSubscription = didacticsRepository!
            .downloadFile(contentDomainModel: event.contentDomainModel)
            .listen(
          (resource) {
            if (resource.status == Status.failed) {
              add(DidacticsAttachmentErrorEvent(failure: resource.failure));
            } else if (resource.status == Status.success) {
              add(DidacticsAttachmentFinishedEvent(file: resource.data));
            } else if (resource.status == Status.loading) {
              add(
                DidacticsAttachmentProgressTickedEvent(
                    value: resource.progress),
              );
            }
          },
        );
      } else if (event.contentDomainModel.type == ContentType.text) {
        final response = await didacticsRepository!.downloadText(
          contentDomainModel: event.contentDomainModel,
        );

        yield* response.fold((failure) async* {
          yield DidacticsAttachmentDownloadFailure(failure: failure);
        }, (text) async* {
          yield DidacticsAttachmentTextDownloadSuccess(
            textContentRemoteModel: text,
          );
        });
      } else if (event.contentDomainModel.type == ContentType.url) {
        final response = await didacticsRepository!.downloadURL(
          contentDomainModel: event.contentDomainModel,
        );

        yield* response.fold((failure) async* {
          yield DidacticsAttachmentDownloadFailure(failure: failure);
        }, (url) async* {
          yield DidacticsAttachmentURLDownloadSuccess(
            urlContentRemoteModel: url,
          );
        });
      }
    }
  }

  @override
  Future<void> close() {
    _downloadSubscription.cancel();
    return super.close();
  }
}
