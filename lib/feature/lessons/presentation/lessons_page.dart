import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String _searchTextFilter = "";

  final TextEditingController _searchFilter = TextEditingController();

  List<LessonDomainModel> _lessons = List();
  List<LessonDomainModel> _filteredLessons = List();

  @override
  void initState() {
    BlocProvider.of<LessonsWatcherBloc>(context)
        .add(LessonsWatchAllStarted(subjectId: widget.subjectId));

    _searchFilter.addListener(() {
      if (_searchFilter.text.isEmpty) {
        setState(() {
          _searchTextFilter = "";
          _filteredLessons = _lessons;
        });
      } else {
        setState(() {
          _searchTextFilter = _searchFilter.text;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
    );
  }
}
