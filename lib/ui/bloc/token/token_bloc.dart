import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/domain/repository/scrutini_repository.dart';

import './bloc.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  ScrutiniRepository scrutiniRepository;

  TokenBloc(this.scrutiniRepository);

  @override
  TokenState get initialState => TokenInitial();

  @override
  Stream<TokenState> mapEventToState(
    TokenEvent event,
  ) async* {
    if (event is GetLoginToken) {
      FLog.info(text: 'Getting token from Spaggiari');
      yield TokenLoadInProgress();

      final tokenResponse = await scrutiniRepository.getLoginToken();
      FLog.info(text: 'Got token from Spaggiari');
      yield tokenResponse.fold(
        (failure) => TokenLoadError(),
        (token) => TokenLoadSuccess(
          token: token.split(';')[0],
          schoolReport: event.schoolReport,
        ),
      );
    }
  }
}
