import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/ui/bloc/absences/absences_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';
import 'package:registro_elettronico/ui/bloc/didactics/bloc.dart';
import 'package:registro_elettronico/ui/bloc/didactics/didactics_attachments/didactics_attachments_bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
import 'package:registro_elettronico/ui/bloc/local_grades/local_grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/attachment_download/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/attachments/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/notices_bloc.dart';
import 'package:registro_elettronico/ui/bloc/periods/periods_bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';

class AppBlocDelegate {
  static AppBlocDelegate _instance;

  List<BlocProvider> _blocProviders;
  List<RepositoryProvider> _repositoryProviders;

  AppBlocDelegate._(BuildContext context) {
    Injector i = Injector.appInstance;
    _repositoryProviders = [];

    _blocProviders = [
      BlocProvider<AuthBloc>(
        create: (bCtx) =>
            AuthBloc(i.getDependency(), i.getDependency(), i.getDependency()),
      ),
      BlocProvider<LessonsBloc>(
        create: (ctx) => LessonsBloc(
          i.getDependency(),
        ),
      ),
      BlocProvider<GradesBloc>(
        create: (ctx) => GradesBloc(i.getDependency(), i.getDependency()),
      ),
      BlocProvider<SubjectsBloc>(
        create: (ctx) => SubjectsBloc(
          i.getDependency(),
          i.getDependency(),
        ),
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
      )
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
