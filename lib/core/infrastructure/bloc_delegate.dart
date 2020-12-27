import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/data/repository/preferences_repository_impl.dart';
import 'package:registro_elettronico/core/domain/repository/preferences_repository.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/absences/presentation/bloc/absences_bloc.dart';
import 'package:registro_elettronico/feature/agenda/data/repository/agenda_repository_impl.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/agenda/presentation/bloc/agenda_bloc.dart';
import 'package:registro_elettronico/feature/didactics/presentation/bloc/attachments/didactics_attachments_bloc.dart';
import 'package:registro_elettronico/feature/didactics/presentation/bloc/didactics_bloc.dart';
import 'package:registro_elettronico/feature/grades/data/repository/grades_repository_impl.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/grades_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/local_grades/local_grades_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/bloc/subjects_grades/subjects_grades_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/blocs/agenda/agenda_dashboard_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/blocs/grades/grades_dashboard_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/blocs/lessons/lessons_dashboard_bloc.dart';
import 'package:registro_elettronico/feature/lessons/presentation/bloc/lessons_bloc.dart';
import 'package:registro_elettronico/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:registro_elettronico/feature/notes/presentation/bloc/attachments/note_attachments_bloc.dart';
import 'package:registro_elettronico/feature/notes/presentation/bloc/notes_bloc.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/bloc/attachment_download/attachment_download_bloc.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/bloc/attachments/attachments_bloc.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/bloc/notices_bloc.dart';
import 'package:registro_elettronico/feature/periods/presentation/bloc/periods_bloc.dart';
import 'package:registro_elettronico/feature/professors/presentation/bloc/professors_bloc.dart';
import 'package:registro_elettronico/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/feature/profile/presentation/token/token_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/document_attachment/document_attachment_bloc.dart';
import 'package:registro_elettronico/feature/scrutini/presentation/bloc/documents_bloc.dart';
import 'package:registro_elettronico/feature/stats/presentation/bloc/stats_bloc.dart';
import 'package:registro_elettronico/feature/subjects/data/repository/subjects_respository_impl.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/subjects/presentation/bloc/subjects_bloc.dart';
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
      RepositoryProvider<GradesRepository>(
        create: (ctx) => GradesRepositoryImpl(
          sl(),
          sl(),
          sl(),
          sl(),
        ),
      ),
      RepositoryProvider<AgendaRepository>(
        create: (ctx) => AgendaRepositoryImpl(
          sl(),
          sl(),
          sl(),
          sl(),
        ),
      ),
      RepositoryProvider<TimetableRepository>(
        create: (ctx) => TimetableRepositoryImpl(
          sl(),
          sl(),
        ),
      ),
      RepositoryProvider<PreferencesRepository>(
        create: (ctx) => PreferencesRepositoryImpl(
          sl(),
        ),
      ),
      RepositoryProvider<SubjectsRepository>(
        create: (ctx) => SubjectsRepositoryImpl(
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
        ),
      ),
    ];

    _blocProviders = [
      BlocProvider<AuthBloc>(
        create: (bCtx) => AuthBloc(
          flutterSecureStorage: sl(),
          profileRepository: sl(),
          loginRepository: sl(),
        ),
      ),
      BlocProvider<LessonsBloc>(
        create: (ctx) => LessonsBloc(
          lessonsRepository: sl(),
        ),
      ),
      BlocProvider<GradesBloc>(
        create: (ctx) => GradesBloc(gradesRepository: sl()),
      ),
      BlocProvider<SubjectsBloc>(
        create: (ctx) => SubjectsBloc(
          subjectsRepository: sl(),
          profileRepository: sl(),
        ),
      ),
      BlocProvider<AgendaBloc>(
        create: (ctx) => AgendaBloc(agendaRepository: sl()),
      ),
      BlocProvider<PeriodsBloc>(
        create: (ctx) => PeriodsBloc(periodsRepository: sl()),
      ),
      BlocProvider<AbsencesBloc>(
        create: (ctx) => AbsencesBloc(absencesRepository: sl()),
      ),
      BlocProvider<NoticesBloc>(
        create: (ctx) => NoticesBloc(noticesRepository: sl()),
      ),
      BlocProvider<AttachmentDownloadBloc>(
        create: (ctx) => AttachmentDownloadBloc(noticesRepository: sl()),
      ),
      BlocProvider<AttachmentsBloc>(
        create: (ctx) => AttachmentsBloc(noticesRepository: sl()),
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
      BlocProvider<LocalGradesBloc>(
        create: (ctx) => LocalGradesBloc(gradesRepository: sl()),
      ),
      BlocProvider<TimetableBloc>(
        create: (ctx) => TimetableBloc(
          timetableRepository: sl(),
          subjectsRepository: sl(),
        ),
      ),
      BlocProvider<SubjectsGradesBloc>(
        create: (ctx) => SubjectsGradesBloc(
          subjectsRepository: sl(),
          gradesRepository: sl(),
          periodsRepository: sl(),
        ),
      ),
      BlocProvider<NoteAttachmentsBloc>(
        create: (ctx) => NoteAttachmentsBloc(
          notesRepository: sl(),
        ),
      ),
      BlocProvider<LessonsDashboardBloc>(
        create: (ctx) => LessonsDashboardBloc(
          lessonsRepository: sl(),
        ),
      ),
      BlocProvider<AgendaDashboardBloc>(
        create: (ctx) => AgendaDashboardBloc(
          agendaRepository: sl(),
        ),
      ),
      BlocProvider<ProfessorsBloc>(
        create: (ctx) => ProfessorsBloc(
          subjectsRepository: sl(),
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
      BlocProvider<GradesDashboardBloc>(
        create: (ctx) => GradesDashboardBloc(
          gradesRepository: sl(),
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
