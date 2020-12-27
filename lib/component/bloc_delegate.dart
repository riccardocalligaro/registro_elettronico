import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/core/data/repository/preferences_repository_impl.dart';
import 'package:registro_elettronico/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/timetable/data/repository/timetable_repository_impl.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/core/domain/repository/preferences_repository.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';

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
        ),
      ),
      RepositoryProvider<ScrutiniRepository>(
        create: (ctx) => ScrutiniRepositoryImpl(
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
        ),
      ),
      RepositoryProvider<GradesRepository>(
        create: (ctx) => GradesRepositoryImpl(
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
        ),
      ),
      RepositoryProvider<AgendaRepository>(
        create: (ctx) => AgendaRepositoryImpl(
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
        ),
      ),
      RepositoryProvider<TimetableRepository>(
        create: (ctx) => TimetableRepositoryImpl(
          i.getDependency(),
          i.getDependency(),
        ),
      ),
      RepositoryProvider<PreferencesRepository>(
        create: (ctx) => PreferencesRepositoryImpl(
          i.getDependency(),
        ),
      ),
      RepositoryProvider<SubjectsRepository>(
        create: (ctx) => SubjectsRepositoryImpl(
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
        ),
      ),
    ];

    _blocProviders = [
      BlocProvider<AuthBloc>(
        create: (bCtx) =>
            AuthBloc(i.getDependency(), i.getDependency(), i.getDependency()),
      ),
      BlocProvider<IntroBloc>(
        create: (ctx) => IntroBloc(
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
        ),
      ),
      BlocProvider<LessonsBloc>(
        create: (ctx) => LessonsBloc(i.getDependency()),
      ),
      BlocProvider<GradesBloc>(
        create: (ctx) => GradesBloc(i.getDependency(), i.getDependency()),
      ),
      BlocProvider<SubjectsBloc>(
        create: (ctx) => SubjectsBloc(i.getDependency(), i.getDependency()),
      ),
      BlocProvider<AgendaBloc>(
        create: (ctx) => AgendaBloc(i.getDependency()),
      ),
      BlocProvider<PeriodsBloc>(
        create: (ctx) => PeriodsBloc(i.getDependency()),
      ),
      BlocProvider<AbsencesBloc>(
        create: (ctx) => AbsencesBloc(i.getDependency()),
      ),
      BlocProvider<NoticesBloc>(
        create: (ctx) => NoticesBloc(i.getDependency()),
      ),
      BlocProvider<AttachmentDownloadBloc>(
        create: (ctx) => AttachmentDownloadBloc(i.getDependency()),
      ),
      BlocProvider<AttachmentsBloc>(
        create: (ctx) => AttachmentsBloc(i.getDependency()),
      ),
      BlocProvider<NotesBloc>(
        create: (ctx) => NotesBloc(i.getDependency()),
      ),
      BlocProvider<DidacticsBloc>(
        create: (ctx) => DidacticsBloc(i.getDependency()),
      ),
      BlocProvider<DidacticsAttachmentsBloc>(
        create: (ctx) => DidacticsAttachmentsBloc(i.getDependency()),
      ),
      BlocProvider<LocalGradesBloc>(
        create: (ctx) => LocalGradesBloc(i.getDependency()),
      ),
      BlocProvider<TimetableBloc>(
        create: (ctx) => TimetableBloc(i.getDependency(), i.getDependency()),
      ),
      BlocProvider<SubjectsGradesBloc>(
        create: (ctx) => SubjectsGradesBloc(
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
        ),
      ),
      BlocProvider<NoteAttachmentsBloc>(
        create: (ctx) => NoteAttachmentsBloc(i.getDependency()),
      ),
      BlocProvider<LessonsDashboardBloc>(
        create: (ctx) => LessonsDashboardBloc(i.getDependency()),
      ),
      BlocProvider<AgendaDashboardBloc>(
        create: (ctx) => AgendaDashboardBloc(i.getDependency()),
      ),
      BlocProvider<ProfessorsBloc>(
        create: (ctx) => ProfessorsBloc(i.getDependency()),
      ),
      BlocProvider<DocumentsBloc>(
        create: (ctx) => DocumentsBloc(i.getDependency()),
      ),
      BlocProvider<TokenBloc>(
        create: (ctx) => TokenBloc(i.getDependency()),
      ),
      BlocProvider<DocumentAttachmentBloc>(
        create: (ctx) => DocumentAttachmentBloc(i.getDependency()),
      ),
      BlocProvider<GradesDashboardBloc>(
        create: (ctx) => GradesDashboardBloc(i.getDependency()),
      ),
      BlocProvider<StatsBloc>(
        create: (ctx) => StatsBloc(i.getDependency()),
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
