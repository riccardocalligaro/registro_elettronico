import 'package:get_it/get_it.dart';

import 'data/datasource/professors_local_datasource.dart';

final _sl = GetIt.instance;

class ProfessorsContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => ProfessorLocalDatasource(_sl()),
    );
  }
}
