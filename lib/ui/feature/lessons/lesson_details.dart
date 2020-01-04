import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_event.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_state.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class LessonDetails extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const LessonDetails({
    Key key,
    @required this.subjectId,
    @required this.subjectName,
  }) : super(key: key);

  @override
  _LessonDetailsState createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";

  List<Lesson> lessons = List();
  List<Lesson> filteredLessons = List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = Text("padding");

  _LessonDetailsState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredLessons = lessons;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    _appBarTitle = Text(
      widget.subjectName,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LessonsBloc>(context)
        .add(GetLessonsForSubject(subjectId: widget.subjectId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: () {
              _searchPressed();
            },
          )
        ],
      ),
      body: Container(
        child: BlocBuilder<LessonsBloc, LessonsState>(
          builder: (context, state) {
            if (state is LessonsUpdateLoadInProgress ||
                state is LessonsLoadInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LessonsLoadSuccess) {
              return _buildLessonsList(state.lessons);
            } else if (state is LessonsLoadServerError ||
                state is LessonsLoadError) {
              return CustomPlaceHolder(
                text: AppLocalizations.of(context).translate('error'),
                icon: Icons.error,
                showUpdate: true,
                onTap: () {
                  BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());
                  BlocProvider.of<LessonsBloc>(context)
                      .add(GetLessonsForSubject(subjectId: widget.subjectId));
                },
              );
            }

            return Text(state.toString());
          },
        ),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "${AppLocalizations.of(context).translate('search')}...",
            border: InputBorder.none,
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(widget.subjectName);
        //filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildLessonsList(List<Lesson> lessons) {
    if (_searchText.isNotEmpty) {
      lessons = lessons
          .where((lesson) => lesson.lessonArg
              .toLowerCase()
              .contains(_searchText.toLowerCase()))
          .toList()
            ..sort((b, a) => a.date.compareTo(b.date));
    }
    if (lessons.length > 0) {
      return RefreshIndicator(
        onRefresh: _refreshLessons,
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: Text(DateUtils.convertDateLocale(lesson.date,
                      AppLocalizations.of(context).locale.toString())),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildDescription(lesson),
                  ),
                  isThreeLine: false,
                ),
              )),
            );
          },
        ),
      );
    }
    if (_searchText.isNotEmpty) {
      return CustomPlaceHolder(
        text: AppLocalizations.of(context).translate('no_lessons'),
        icon: Icons.assignment,
        showUpdate: false,
      );
    } else {
      return CustomPlaceHolder(
        text: AppLocalizations.of(context).translate('no_lessons'),
        icon: Icons.assignment,
        onTap: () {
          BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());
        },
        showUpdate: true,
      );
    }
  }

  /// With this method we can show the lesson argument if present otherwise we show only the lesson type
  List<Widget> _buildDescription(Lesson lesson) {
    List<Widget> textWidgets = [];
    if (lesson.lessonArg != "") {
      textWidgets.add(Text(lesson.lessonArg));
      textWidgets.add(Text(lesson.lessonType));
    } else {
      textWidgets.add(Text(lesson.lessonType));
    }

    return textWidgets;
  }

  Future _refreshLessons() async {
    BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());
    BlocProvider.of<LessonsBloc>(context)
        .add(GetLessonsForSubject(subjectId: widget.subjectId));
  }
}
