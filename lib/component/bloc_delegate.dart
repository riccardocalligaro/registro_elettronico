import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
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
            i.getDependency(), i.getDependency(), i.getDependency()),
      ),
      BlocProvider<GradesBloc>(
        create: (ctx) =>
            GradesBloc(i.getDependency(), i.getDependency(), i.getDependency()),
      ),
      BlocProvider<SubjectsBloc>(
        create: (ctx) => SubjectsBloc(i.getDependency(), i.getDependency(),
            i.getDependency(), i.getDependency()),
      ),
      BlocProvider<AgendaBloc>(
        create: (ctx) => AgendaBloc(i.getDependency(), i.getDependency()),
      ),
      BlocProvider<PeriodsBloc>(
        create: (ctx) => PeriodsBloc(i.getDependency()),
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
