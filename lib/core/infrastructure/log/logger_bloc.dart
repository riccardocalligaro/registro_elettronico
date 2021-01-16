import 'package:flutter_bloc/flutter_bloc.dart';

import 'logger.dart';

class LoggerBlocDelegate extends BlocObserver {
  @override
  void onEvent(Cubit bloc, Object event) {
    Logger.info('📟 [BLOC] $bloc Event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Cubit bloc, Transition transition) {
    Logger.info('📟 [BLOC] $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit bloc, Object error, StackTrace stacktrace) {
    Logger.error(
      '📟❌ [BLOC] $bloc',
      Exception(error.toString()),
      stacktrace,
    );
    super.onError(bloc, error, stacktrace);
  }
}
