import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/home/home_page.dart';
import 'package:registro_elettronico/feature/home/sections/lessons/lesson_card.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/last_lessons_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/presentation/latest_watcher/latest_lessons_watcher_bloc.dart';

class HomeLessons extends StatelessWidget {
  const HomeLessons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestLessonsWatcherBloc, LatestLessonsWatcherState>(
      builder: (context, state) {
        if (state is LatestLessonsWatcherLoadSuccess) {
          if (state.lessons!.isEmpty) {
            return _LatestLessonsEmpty();
          }

          return _LatestLessonsLoaded(
            lessons: state.lessons,
          );
        } else if (state is LatestLessonsWatcherFailure) {
          return _LatestLessonsEmpty(
            error: true,
          );
        }

        return _LatestLessonsEmpty(
          showUpdate: false,
        );
      },
    );
  }
}

class HomeLessonsHeader extends StatelessWidget {
  const HomeLessonsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(AppLocalizations.of(context)!.translate('last_lessons')!),
    );
  }
}

class _LatestLessonsLoaded extends StatelessWidget {
  final List<LessonWithDurationDomainModel>? lessons;

  const _LatestLessonsLoaded({
    Key? key,
    required this.lessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: lessons!.length,
      itemBuilder: (context, index) {
        return LessonCard(
          lesson: lessons![index].lesson,
          position: index,
          duration: 1,
        );
      },
    );
  }
}

class _LatestLessonsEmpty extends StatelessWidget {
  final bool error;
  final bool showUpdate;

  const _LatestLessonsEmpty({
    Key? key,
    this.error = false,
    this.showUpdate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Center(
        child: Column(
          children: <Widget>[
            if (!showUpdate)
              SizedBox(
                height: 23,
              ),
            Icon(
              error ? Icons.error : Icons.subject,
              size: 80,
              color: Colors.grey,
            ),
            if (error)
              SizedBox(
                height: 4,
              ),
            if (error)
              Text(
                AppLocalizations.of(context)!.translate('error')!,
              ),
            if (!error)
              Text(
                AppLocalizations.of(context)!.translate('no_lessons')!,
              ),
            if (showUpdate)
              TextButton(
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  homeRefresherKey.currentState!.show();
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('sync')!,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
