import 'package:f_logs/f_logs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logger.dart';

class LoggerBlocDelegate extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    Logger.info('📟 [BLOC] $bloc Change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    Logger.info('📟 [BLOC] $bloc Event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onClose(BlocBase bloc) {
    Logger.info('📟 Close BLOC $bloc');
    super.onClose(bloc);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Logger.info('📟 [BLOC] $bloc Transition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object e, StackTrace s) {
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
