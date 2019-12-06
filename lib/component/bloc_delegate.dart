import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/ui/bloc/authentication/bloc.dart';
import 'package:registro_elettronico/ui/bloc/login/login_bloc.dart';

class AppBlocDelegate {
  static AppBlocDelegate _instance;

  List<BlocProvider> _blocProviders;
  List<RepositoryProvider> _repositoryProviders;

  AppBlocDelegate._(BuildContext context) {
    Injector injector = Injector.appInstance;
    _repositoryProviders = [];

    _blocProviders = [
      BlocProvider<AuthenticationBloc>(
        create: (bCtx) => AuthenticationBloc(injector.getDependency()),
      ),
      BlocProvider<LoginBloc>(
        create: (bCtx) => LoginBloc(
            loginRepository: injector.getDependency(),
            authenticationBloc: injector.getDependency()),
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
