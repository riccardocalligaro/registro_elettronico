import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/data/repository/preferences_repository_impl.dart';
import 'package:registro_elettronico/core/domain/repository/preferences_repository.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/agenda/agenda_container.dart';
import 'package:registro_elettronico/feature/authentication/presentation/token/token_bloc.dart';
import 'package:registro_elettronico/feature/core_container.dart';
import 'package:registro_elettronico/feature/didactics/presentation/bloc/attachments/didactics_attachments_bloc.dart';
import 'package:registro_elettronico/feature/didactics/presentation/bloc/didactics_bloc.dart';
import 'package:registro_elettronico/feature/grades/grades_container.dart'
    hide sl;
import 'package:registro_elettronico/feature/notes/presentation/bloc/attachments/note_attachments_bloc.dart';
import 'package:registro_elettronico/feature/notes/presentation/bloc/notes_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/document_attachment/document_attachment_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/documents_bloc.dart';
import 'package:registro_elettronico/feature/stats/presentation/bloc/stats_bloc.dart';

class AppBlocDelegate {
  static AppBlocDelegate _instance;

  List<BlocProvider> _blocProviders;

  AppBlocDelegate._(BuildContext context) {
    _blocProviders = [
      ...CoreContainer.getBlocProviders(),
      BlocProvider<NotesBloc>(
        create: (ctx) => NotesBloc(notesRepository: sl()),
      ),
      BlocProvider<DidacticsBloc>(
        create: (ctx) => DidacticsBloc(didacticsRepository: sl()),
      ),
      BlocProvider<DidacticsAttachmentsBloc>(
        create: (ctx) => DidacticsAttachmentsBloc(didacticsRepository: sl()),
      ),
      BlocProvider<NoteAttachmentsBloc>(
        create: (ctx) => NoteAttachmentsBloc(
          notesRepository: sl(),
        ),
      ),
      BlocProvider<DocumentsBloc>(
        create: (ctx) => DocumentsBloc(
          documentsRepository: sl(),
        ),
      ),
      BlocProvider<TokenBloc>(
        create: (ctx) => TokenBloc(
          scrutiniRepository: sl(),
        ),
      ),
      BlocProvider<DocumentAttachmentBloc>(
        create: (ctx) => DocumentAttachmentBloc(
          documentsRepository: sl(),
        ),
      ),
      BlocProvider<StatsBloc>(
        create: (ctx) => StatsBloc(
          statsRepository: sl(),
        ),
      ),
    ];
  }

  static AppBlocDelegate instance(BuildContext context) {
    if (_instance == null) {
      _instance = AppBlocDelegate._(context);
    }
    return _instance;
  }

  List<BlocProvider> get blocProviders => _blocProviders;
}
