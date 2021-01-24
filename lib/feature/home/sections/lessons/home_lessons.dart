import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/feature/home/sections/lessons/lesson_card.dart';
import 'package:registro_elettronico/feature/home/sections/lessons/old_lesson_card.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/last_lessons_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/presentation/latest_watcher/latest_lessons_watcher_bloc.dart';

class HomeLessons extends StatelessWidget {
  const HomeLessons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestLessonsWatcherBloc, LatestLessonsWatcherState>(
      builder: (context, state) {
        if (state is LatestLessonsWatcherLoadSuccess) {
          if (state.lessons.isEmpty) {
            return _LatestLessonsEmpty();
          }

          return _LatestLessonsLoaded(
            lessons: state.lessons,
          );
        } else if (state is LatestLessonsWatcherFailure) {
          return SRFailureView(
            failure: state.failure,
          );
        }

        return _LatestLessonsEmpty();
      },
    );
  }
}

class HomeLessonsHeader extends StatelessWidget {
  const HomeLessonsHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(AppLocalizations.of(context).translate('last_lessons')),
    );
  }
}

class _LatestLessonsLoaded extends StatelessWidget {
  final List<LessonWithDurationDomainModel> lessons;

  const _LatestLessonsLoaded({
    Key key,
    @required this.lessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return OldLessonCard(
            lesson: lessons[index].lesson, position: index, duration: 1);
        return Padding(
          padding: index == 0
              ? EdgeInsets.only(left: 16)
              : EdgeInsets.symmetric(horizontal: 8),
          child: LessonCard(
            lesson: lessons[index],
          ),
        );
      },
    );
  }
}

class _LatestLessonsEmpty extends StatelessWidget {
  const _LatestLessonsEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 23.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.subject,
              size: 64,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(AppLocalizations.of(context).translate('no_lessons'))
          ],
        ),
      ),
    );
  }
}
