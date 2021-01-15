import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/core/presentation/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/lessons_bloc.dart';

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
  int _lastUpdate;

  List<Lesson> lessons = List();
  List<Lesson> filteredLessons = List();
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('padding');
  RefreshController _refreshController = RefreshController();

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
    restore();
    _appBarTitle = Text(
      widget.subjectName,
    );
    BlocProvider.of<LessonsBloc>(context)
        .add(GetLessonsForSubject(subjectId: widget.subjectId));
    super.initState();
  }

  void restore() async {
    SharedPreferences prefs = sl();
    setState(() {
      _lastUpdate = prefs.getInt(PrefsConstants.lastUpdateLessons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Theme.of(context).brightness,
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
        bottomSheet: LastUpdateBottomSheet(
          millisecondsSinceEpoch: _lastUpdate,
        ),
        floatingActionButton: const SizedBox(height: 1),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocListener<LessonsBloc, LessonsState>(
          listener: (context, state) {
            if (state is LessonsUpdateLoadSuccess) {
              setState(() {
                _lastUpdate = DateTime.now().millisecondsSinceEpoch;
              });
            }

            if (state is LessonsLoadErrorNotConnected) {
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    AppNavigator.instance.getNetworkErrorSnackBar(context));
            }
          },
          child: Container(
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
                      BlocProvider.of<LessonsBloc>(context)
                          .add(UpdateAllLessons());
                      BlocProvider.of<LessonsBloc>(context).add(
                          GetLessonsForSubject(subjectId: widget.subjectId));
                    },
                  );
                }

                return Text(state.toString());
              },
            ),
          ),
        ));
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "${AppLocalizations.of(context).translate('search')}...",
            border: InputBorder.none,
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text(widget.subjectName);
        //filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildLessonsList(List<Lesson> lessons) {
    int currentMonth = -1;
    bool showMonth;

    if (_searchText.isNotEmpty) {
      lessons = lessons
          .where((lesson) => lesson.lessonArg
              .toLowerCase()
              .contains(_searchText.toLowerCase()))
          .toList()
            ..sort((b, a) => a.date.compareTo(b.date));
    }
    if (lessons.isNotEmpty) {
      return SmartRefresher(
        controller: RefreshController(),
        header: MaterialClassicHeader(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.white,
          color: Theme.of(context).accentColor,
        ),
        onRefresh: _refreshLessons,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 21),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];

            if (lesson.date.month != currentMonth) {
              showMonth = true;
            } else {
              showMonth = false;
            }
            currentMonth = lesson.date.month;

            if (showMonth) {
              var convertMonthLocale = DateUtils.convertMonthLocale(
                  lesson.date, AppLocalizations.of(context).locale.toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      convertMonthLocale,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                  _buildLessonCard(lesson)
                ],
              );
            } else {
              return _buildLessonCard(lesson);
            }
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
          BlocProvider.of<LessonsBloc>(context).add(GetLessons());
        },
        showUpdate: true,
      );
    }
  }

  Widget _buildLessonCard(Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          title: Text(DateUtils.convertDateLocale(
              lesson.date, AppLocalizations.of(context).locale.toString())),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDescription(lesson),
          ),
          isThreeLine: false,
        ),
      )),
    );
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
    _refreshController.loadComplete();
  }
}