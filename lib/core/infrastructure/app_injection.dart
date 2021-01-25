import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/core_container.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/notes/data/repository/notes_repository_impl.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/feature/scrutini/data/dao/document_dao.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/documents_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/stats/data/repository/stats_repository_impl.dart';
import 'package:registro_elettronico/feature/stats/domain/repository/stats_repository.dart';

final sl = GetIt.instance;

class AppInjector {
  static Future<void> init() async {
    await CoreContainer.init();

    // Inject all the daos
    injectDaos();

    // Inject all the repositories
    injectRepository();
  }

  // All the DAOS (Data Access Objects)
  static void injectDaos() {
    sl.registerLazySingleton(() => NoteDao(sl()));
    sl.registerLazySingleton(() => DocumentsDao(sl()));
  }

  static void injectRepository() {
    sl.registerLazySingleton<NotesRepository>(
        () => NotesRepositoryImpl(sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<DocumentsRepository>(
      () => DocumentsRepositoryImpl(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );

    sl.registerLazySingleton<ScrutiniRepository>(
      () => ScrutiniRepositoryImpl(
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );

    sl.registerLazySingleton<StatsRepository>(
      () => StatsRepositoryImpl(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );
  }
}
