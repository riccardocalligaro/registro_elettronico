import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/feature/briefing/components/lesson_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildLessonsCards(context),
    );
  }

  StreamBuilder<List<Lesson>> _buildLessonsCards(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<LessonsBloc>(context).relevantLessons,
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Lesson> lessons = snapshot.data ?? List();
        if (lessons.length == 0) {
          // todo: maybe a better placeholder?
          return Center(
            child: Text(
                '${AppLocalizations.of(context).translate('nothing_here')} 😶'),
          );
        } else {
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (_, index) {
              final lesson = lessons[index];
              return Text(lesson.lessonArg);
            },
          );
        }
      },
    );
  }
}
