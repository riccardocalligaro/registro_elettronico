import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/feature/authentication/data/model/login/parent_response_remote_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/login_request_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({
    @required this.authenticationRepository,
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is SignIn) {
      yield AuthenticationLoading();

      final response = await authenticationRepository.loginUser(
        loginRequestDomainModel: event.loginRequestDomainModel,
      );

      yield* response.fold(
        (failure) async* {
          yield AuthenticationFailure(failure: failure);
        },
        (r) async* {
          yield* r.response.fold(
            (parent) async* {
              yield AuthenticationNeedsAccountSelection(
                parentLoginResponseRemoteModel: parent,
              );
            },
            (normal) async* {
              yield AuthenticationSuccess();
            },
          );
        },
      );
    }
  }
}
