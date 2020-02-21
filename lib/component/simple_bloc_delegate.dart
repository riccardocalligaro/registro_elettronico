import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    FLog.info(text: 'BLoC $bloc Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    FLog.info(text: '$transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    FLog.info(
        text: '$bloc',
        exception: Exception(error.toString()),
        stacktrace: stacktrace);
  }
}
