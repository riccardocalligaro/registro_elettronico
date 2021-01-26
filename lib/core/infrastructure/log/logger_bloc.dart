import 'package:f_logs/f_logs.dart';
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
  void onError(Cubit bloc, Object e, StackTrace s) {
    Object ex;
    if (e is Exception) {
    } else {
      ex = Exception(e.toString());
    }

    FLog.error(
      text: '📟❌ [BLOC] $bloc',
      exception: ex,
      stacktrace: s,
      methodName: '',
      className: '',
    );

    super.onError(bloc, e, s);
  }
}
