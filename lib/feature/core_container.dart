import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/lessons/lessons_container.dart';
import 'package:registro_elettronico/feature/periods/periods_container.dart';
import 'package:registro_elettronico/feature/professors/professors_container.dart';
import 'package:registro_elettronico/feature/subjects/subjects_container.dart';

class CoreContainer {
  static Future<void> init() async {
    await ProfessorsContainer.init();
    await PeriodsContainer.init();
    await ProfessorsContainer.init();
    await SubjectsContainer.init();
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      ...LessonsContainer.getBlocProviders(),
      ...SubjectsContainer.getBlocProviders(),
    ];
  }
}
