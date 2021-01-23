import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/data/repository/preferences_repository_impl.dart';
import 'package:registro_elettronico/core/domain/repository/preferences_repository.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/absences/presentation/bloc/absences_bloc.dart';
import 'package:registro_elettronico/feature/agenda/agenda_container.dart';
import 'package:registro_elettronico/feature/core_container.dart';
import 'package:registro_elettronico/feature/didactics/presentation/bloc/attachments/didactics_attachments_bloc.dart';
import 'package:registro_elettronico/feature/didactics/presentation/bloc/didactics_bloc.dart';
import 'package:registro_elettronico/feature/grades/grades_container.dart'
    hide sl;
import 'package:registro_elettronico/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:registro_elettronico/feature/notes/presentation/bloc/attachments/note_attachments_bloc.dart';
import 'package:registro_elettronico/feature/notes/presentation/bloc/notes_bloc.dart';

import 'package:registro_elettronico/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/feature/profile/presentation/token/token_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/document_attachment/document_attachment_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/documents_bloc.dart';
import 'package:registro_elettronico/feature/stats/presentation/bloc/stats_bloc.dart';
import 'package:registro_elettronico/feature/timetable/data/repository/timetable_repository_impl.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/feature/timetable/presentation/bloc/timetable_bloc.dart';

class AppBlocDelegate {
  static AppBlocDelegate _instance;

  List<BlocProvider> _blocProviders;
  List<RepositoryProvider> _repositoryProviders;

  AppBlocDelegate._(BuildContext context) {
    _repositoryProviders = [
      RepositoryProvider<ProfileRepository>(
        create: (ctx) => ProfileRepositoryImpl(
          sl(),
          sl(),
          sl(),
        ),
      ),
      RepositoryProvider<ScrutiniRepository>(
        create: (ctx) => ScrutiniRepositoryImpl(
          sl(),
          sl(),
          sl(),
          sl(),
        ),
      ),
      RepositoryProvider<TimetableRepository>(
        create: (ctx) => TimetableRepositoryImpl(
          lessonsLocalDatasource: sl(),
          timetableDao: sl(),
        ),
      ),
      RepositoryProvider<PreferencesRepository>(
        create: (ctx) => PreferencesRepositoryImpl(
          sl(),
        ),
      ),
    ];

    _blocProviders = [
      ...GradesContainer.getBlocProviders(),
      ...AgendaContainer.getBlocProviders(),
      ...CoreContainer.getBlocProviders(),
      BlocProvider<AuthBloc>(
        create: (bCtx) => AuthBloc(
          flutterSecureStorage: sl(),
          profileRepository: sl(),
          loginRepository: sl(),
          sharedPreferences: sl(),
        ),
      ),
      BlocProvider<AbsencesBloc>(
        create: (ctx) => AbsencesBloc(absencesRepository: sl()),
      ),
      BlocProvider<NotesBloc>(
        create: (ctx) => NotesBloc(notesRepository: sl()),
      ),
      BlocProvider<DidacticsBloc>(
        create: (ctx) => DidacticsBloc(didacticsRepository: sl()),
      ),
      BlocProvider<DidacticsAttachmentsBloc>(
        create: (ctx) => DidacticsAttachmentsBloc(didacticsRepository: sl()),
      ),
      BlocProvider<TimetableBloc>(
        create: (ctx) => TimetableBloc(
          timetableRepository: sl(),
          subjectsLocalDatasource: sl(),
        ),
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

  List<RepositoryProvider> get repositoryProviders => _repositoryProviders;
}
