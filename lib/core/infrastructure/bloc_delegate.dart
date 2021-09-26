import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/absences/presentation/bloc/absences_bloc.dart';
import 'package:registro_elettronico/feature/authentication/presentation/token/token_bloc.dart';
import 'package:registro_elettronico/feature/core_container.dart';
import 'package:registro_elettronico/feature/notes/presentation/bloc/attachments/note_attachments_bloc.dart';
import 'package:registro_elettronico/feature/notes/presentation/bloc/notes_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/document_attachment/document_attachment_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/documents_bloc.dart';
import 'package:registro_elettronico/feature/stats/presentation/bloc/stats_bloc.dart';

class AppBlocDelegate {
  static AppBlocDelegate? _instance;

  List<BlocProvider>? _blocProviders;

  AppBlocDelegate._(BuildContext context) {
    _blocProviders = [
      ...CoreContainer.getBlocProviders(),
      BlocProvider<AbsencesBloc>(
        create: (ctx) => AbsencesBloc(absencesRepository: sl()),
      ),
      BlocProvider<NotesBloc>(
        create: (ctx) => NotesBloc(notesRepository: sl()),
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

  static AppBlocDelegate? instance(BuildContext context) {
    if (_instance == null) {
      _instance = AppBlocDelegate._(context);
    }
    return _instance;
  }

  List<BlocProvider>? get blocProviders => _blocProviders;
}
