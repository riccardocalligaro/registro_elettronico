import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/widgets/lesson_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

import '../../../bloc/lessons/bloc.dart';

class LastLessonsSection extends StatelessWidget {
  const LastLessonsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsBloc, LessonsState>(
      builder: (context, state) {
        if (state is LessonsLoadServerError || state is LessonsLoadError) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CustomPlaceHolder(
              icon: Icons.error,
              showUpdate: false,
              text: 'Erorr',
            ),
          );
        } else if (state is LessonsUpdateLoadInProgress) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return BlocBuilder<LessonsDashboardBloc, LessonsDashboardState>(
            builder: (context, state) {
              if (state is LessonsDashboardLoadSuccess) {
                return Container(
                  height: 140,
                  child: _buildLessonsCardsList(state.lessons, context),
                );
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildLessonsCardsList(List<Lesson> lessons, BuildContext context) {
    if (lessons.length > 0) {
      final lessonsGrouped = GlobalUtils.getGroupedLessonsMap(lessons);
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lessonsGrouped.keys.length,
        itemBuilder: (context, index) {
          final lessonKey = lessonsGrouped.keys.elementAt(index);
          final duration = lessonsGrouped[lessonKey];
          final lesson = lessons
              .where((l) =>
                  l.lessonArg == lessonKey.item2 &&
                  l.subjectId == lessonKey.item1)
              .elementAt(0);
          return LessonCard(
            lesson: lesson,
            duration: duration,
            position: index,
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.subject,
              size: 64,
            ),
            SizedBox(
              height: 10,
            ),
            Text(AppLocalizations.of(context).translate('no_lessons'))
          ],
        ),
      ),
    );
  }
}
