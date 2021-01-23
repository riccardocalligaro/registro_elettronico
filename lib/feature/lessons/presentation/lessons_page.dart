import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/presentation/watcher/lessons_watcher_bloc.dart';

class LessonsPage extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  LessonsPage({
    Key key,
    @required this.subjectId,
    @required this.subjectName,
  }) : super(key: key);

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  SearchBar _searchBar;
  String _searchQuery = '';

  @override
  void initState() {
    BlocProvider.of<LessonsWatcherBloc>(context)
        .add(LessonsWatchAllStarted(subjectId: widget.subjectId));

    _searchBar = SearchBar(
      setState: setState,
      onChanged: (query) {
        if (query.isNotEmpty) {
          setState(() => _searchQuery = query);
        }
      },
      buildDefaultAppBar: buildAppBar,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      body: BlocBuilder<LessonsWatcherBloc, LessonsWatcherState>(
        builder: (context, state) {
          if (state is LessonsWatcherLoadSuccess) {
            return _LessonsLoaded(
              lessons: state.lessons,
              query: _searchQuery,
            );
          } else if (state is LessonsWatcherFailure) {
            return SRFailureView(failure: state.failure);
          }

          return SRLoadingView();
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.subjectName),
      actions: [
        _searchBar.getSearchAction(context),
      ],
    );
  }
}

class _LessonsLoaded extends StatelessWidget {
  final List<LessonDomainModel> lessons;
  final String query;

  const _LessonsLoaded({
    Key key,
    @required this.lessons,
    @required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LessonDomainModel> lessonsToShow;

    if (query.isNotEmpty) {
      lessonsToShow = lessons.where((l) => _showResult(query, l)).toList();
    } else {
      lessonsToShow = lessons;
    }

    return ListView.builder(
      itemCount: lessonsToShow.length,
      itemBuilder: (context, index) {
        return Text(lessonsToShow[index].lessonArgoment);
      },
    );
  }

  bool _showResult(String query, LessonDomainModel lesson) {
    final lQuery = query.toLowerCase().replaceAll(' ', '');
    return lesson.author.toLowerCase().replaceAll(' ', '').contains(lQuery) ||
        lesson.lessonArgoment
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(lQuery);
  }
}
