import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/repository/repository_impl_export.dart';
import 'package:registro_elettronico/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/ui/bloc/absences/absences_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/didactics/bloc.dart';
import 'package:registro_elettronico/ui/bloc/didactics/didactics_attachments/didactics_attachments_bloc.dart';
import 'package:registro_elettronico/ui/bloc/documents/document_attachment/bloc/bloc.dart';
import 'package:registro_elettronico/ui/bloc/documents/documents_bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/subject_grades/subjects_grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/intro/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
import 'package:registro_elettronico/ui/bloc/local_grades/local_grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/notes/note_attachments/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/attachment_download/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/attachments/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/notices_bloc.dart';
import 'package:registro_elettronico/ui/bloc/periods/periods_bloc.dart';
import 'package:registro_elettronico/ui/bloc/professors/bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/bloc/timetable/timetable_bloc.dart';
import 'package:registro_elettronico/ui/bloc/token/token_bloc.dart';

class AppBlocDelegate {
  static AppBlocDelegate _instance;

  List<BlocProvider> _blocProviders;
  List<RepositoryProvider> _repositoryProviders;

  AppBlocDelegate._(BuildContext context) {
    Injector i = Injector.appInstance;
    _repositoryProviders = [
      RepositoryProvider<ProfileRepository>(
        create: (ctx) => ProfileRepositoryImpl(
          i.getDependency(),
          i.getDependency(),
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
      )
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
