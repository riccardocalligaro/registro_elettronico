import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/professors/professors_container.dart';
import 'package:registro_elettronico/feature/subjects/subjects_container.dart';

final _sl = GetIt.instance;

class CoreContainer {
  static Future<void> init() async {
    // Professors
    await ProfessorsContainer.init();

    // Subjects
    await SubjectsContainer.init();
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      ...SubjectsContainer.getBlocProviders(),
    ];
  }
}
