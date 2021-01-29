import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/core/data/remote/web/web_spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';

class ScrutiniRepositoryImpl implements ScrutiniRepository {
  final WebSpaggiariClient webSpaggiariClient;
  final AuthenticationRepository authenticationRepository;
  final FlutterSecureStorage flutterSecureStorage;
  final NetworkInfo networkInfo;

  ScrutiniRepositoryImpl(
    this.webSpaggiariClient,
    this.authenticationRepository,
    this.flutterSecureStorage,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, String>> getLoginToken({
    bool lastYear,
  }) async {
    if (await networkInfo.isConnected) {
      final profile = await authenticationRepository.getProfile();
      final password = await flutterSecureStorage.read(key: profile.ident);

      try {
        final resToken = await webSpaggiariClient.getPHPToken(
          username: profile.ident,
          password: password,
          lastYear: lastYear ?? false,
        );

        return Right(resToken);
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);
        Logger.e(
          exception: Exception(e.toString()),
          stacktrace: s,
          text: 'Error getting login token',
        );
        return Left(ServerFailure());
      }
    } else {
      throw NotConntectedException();
    }
  }
}
