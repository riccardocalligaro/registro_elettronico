import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoggerBlocDelegate extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    Fimber.i('📟 [BLOC] $bloc Change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    Fimber.i('📟 [BLOC] $bloc Event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onClose(BlocBase bloc) {
    Fimber.i('📟 Close BLOC $bloc');
    super.onClose(bloc);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Fimber.i('📟 [BLOC] $bloc Transition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object e, StackTrace s) {
    Object? ex;
    if (e is Exception) {
    } else {
      ex = Exception(e.toString());
    }

    Fimber.e('📟❌ [BLOC] $bloc', ex: ex, stacktrace: s);

    super.onError(bloc, e, s);
  }
}
