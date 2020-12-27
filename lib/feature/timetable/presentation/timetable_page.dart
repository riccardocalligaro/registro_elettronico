import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/domain/repository/preferences_repository.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/feature/timetable/presentation/views/new_timetable_entry.dart';
import 'package:registro_elettronico/feature/timetable/presentation/widgets/timetable_card.dart';
import 'package:registro_elettronico/utils/constants/general_constants.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:tuple/tuple.dart';

import 'bloc/timetable_bloc.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  // static double cellHeight = 80.0;

  PageController pageController = PageController(viewportFraction: 0.85);

  bool _defaultGridView = true;
  IconData _timetableIcon = Icons.view_agenda;

  @override
  void initState() {
    _defaultGridView = RepositoryProvider.of<PreferencesRepository>(context)
            .getBool(PrefsConstants.DEFAULT_GRID_VIEW) ??
        true;
    BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(
          AppLocalizations.of(context).translate('timetable'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              BlocProvider.of<TimetableBloc>(context).add(GetNewTimetable());
              BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
            },
          ),
          IconButton(
            icon: Icon(_timetableIcon),
            onPressed: () {
              setState(() {
                _defaultGridView = !_defaultGridView;
                if (_defaultGridView) {
                  _timetableIcon = Icons.view_agenda;
                } else {
                  _timetableIcon = Icons.grid_on;
                }
              });
              RepositoryProvider.of<PreferencesRepository>(context)
                  .setBool(PrefsConstants.DEFAULT_GRID_VIEW, _defaultGridView);
            },
          ),
        ],
      ),
      body: Container(
        child: BlocBuilder<TimetableBloc, TimetableState>(
          builder: (context, state) {
            if (state is TimetableLoading) {
              return _buildTimetableLoading();
            }

            if (state is TimetableError) {
              return _buildTimetableError(state.error);
            }

            if (state is TimetableLoaded) {
              if (state.timetableEntries.length > 0) {
                if (_defaultGridView) {
                  return _buildTimetableGridView(
                      state.timetableEntries, state.subjects);
                } else {
                  return _buildTimetableList(
                      state.timetableEntries, state.subjects);
                }
              }

              return CustomPlaceHolder(
                icon: Icons.access_time,
                text:
                    """${AppLocalizations.of(context).translate('no_timetable')}
${AppLocalizations.of(context).translate('no_timetable_message')}""",
                showUpdate: true,
                updateMessage:
                    AppLocalizations.of(context).translate('generate'),
                onTap: () {
                  BlocProvider.of<TimetableBloc>(context).add(
                    GetNewTimetable(),
                  );
                  BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  // Future<String> _getTimetableSummaryMessage() async {
  //   final List<TimetableEntry> entries =
  //       await RepositoryProvider.of<TimetableRepository>(context)
  //           .getTimetable();
  // }

  Widget _buildTimetableGridView(
      List<TimetableEntry> timetable, List<Subject> subjects) {
    final Map<int, Tuple2<String, Color>> subjectsMap =
        Map.fromIterable(subjects,
            key: (e) => e.id,
            value: (e) {
              final subject = subjects.where((s) => s.id == e.id);
              return Tuple2(subject.elementAt(0).name,
                  Color(int.parse(subject.elementAt(0).color)));
            });

    final Map<int, List<TimetableEntry>> timetableMap = Map.fromIterable(
        timetable,
        key: (e) => e.start,
        value: (e) => timetable.where((s) => s.start == e.start).toList());

    return Scrollbar(
      child: ListView(
        // controller: _controller,
        children: <Widget>[
          SingleChildScrollView(
            //controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                defaultColumnWidth: IntrinsicColumnWidth(),
                children: List.generate(12, (start) {
                  if (start == 0) {
                    return TableRow(
                        children: List.generate(8, (index) {
                      if (index == 0) return Container();
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          DateUtils.convertSingleDayShortForDisplay(
                              DateTime.utc(2000, 1, 2)
                                  .add(Duration(days: index)),
                              AppLocalizations.of(context).locale.toString()),
                        ),
                      );
                    }));
                  }
                  return TableRow(
                    children: List.generate(8, (day) {
                      if (day == 0)
                        return Text(
                            (start + GeneralConstants.PADDING_DATE).toString());
                      final entriesMap = timetableMap[start];

                      if (entriesMap != null) {
                        final entry = entriesMap
                            .where((t) => t.dayOfWeek == day)
                            .toList();
                        if (entry.length > 0) {
                          return Column(
                            children: <Widget>[
                              _getSubjectBox(
                                entry[0],
                                subjectsMap,
                                dayOfWeek: day + 1,
                                begin: start,
                                end: start + 1,
                              ),
                              Divider()
                            ],
                          );
                        }
                      }
                      return Column(
                        children: <Widget>[
                          _getSubjectBox(null, subjectsMap,
                              dayOfWeek: day + 1, begin: start, end: start + 1),
                          Divider()
                        ],
                      );
                    }),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getSubjectBox(
    TimetableEntry timetableEntry,
    Map<int, Tuple2<String, Color>> subjectsMap, {
    int dayOfWeek,
    int begin,
    int end,
  }) {
    if (timetableEntry == null) {
      return TimetableCard(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewTimetableEntry(
              startHour: begin + GeneralConstants.PADDING_DATE,
              dayOfWeek: dayOfWeek,
            ),
          ));
        },
      );
    }

    final subject = subjectsMap[timetableEntry?.subject];

    if (subject == null) {
      return TimetableCard(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewTimetableEntry(
              startHour: begin + GeneralConstants.PADDING_DATE,
              dayOfWeek: dayOfWeek,
            ),
          ));
        },
      );
    }

    return TimetableCard(
      timetableEntry: timetableEntry,
      subject: subject?.item1,
      color: subject?.item2,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(subject.item1),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(
                    DateUtils.convertSingleDayForDisplay(
                        DateTime.utc(2000, 1, 2)
                            .add(Duration(days: dayOfWeek - 1)),
                        AppLocalizations.of(context).locale.toString()),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text(
                      '${begin + GeneralConstants.PADDING_DATE}:00-${end + GeneralConstants.PADDING_DATE}:00'),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  await RepositoryProvider.of<TimetableRepository>(context)
                      .deleteTimetableEntry(timetableEntry);
                  BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)
                    .translate('delete')
                    .toUpperCase()),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                    AppLocalizations.of(context).translate('ok').toUpperCase()),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimetableList(
      List<TimetableEntry> timetable, List<Subject> subjects) {
    return ListView.builder(
      itemCount: 7,
      shrinkWrap: true,
      //scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index != 0) {
          final List<TimetableEntry> entries =
              timetable.where((t) => t.dayOfWeek == index).toList();
          entries.sort((a, b) => a.start.compareTo(b.start));
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  DateUtils.convertSingleDayForDisplay(
                      DateTime.utc(2000, 1, 2).add(Duration(days: index)),
                      AppLocalizations.of(context).locale.toString()),
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                shrinkWrap: true,
                itemBuilder: (context, index2) {
                  final entry = entries[index2];
                  final subjectsList =
                      subjects.where((s) => s.id == entry.subject).toList();
                  String subject;
                  if (subjectsList.length > 0) {
                    subject = subjectsList[0].name;
                  } else {
                    FLog.info(
                        text: 'Unknown subject: ' + entry.subject.toString());
                    subject = AppLocalizations.of(context)
                        .translate('unknown_subject')
                        .toUpperCase();
                  }
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text('${entry.start}H'),
                        title: Text(
                          subject,
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  // void _navigateToCurrentDay() {
  //   int currentDay = DateTime.now().weekday;
  //   if (currentDay > 6) {
  //     currentDay = 1;
  //   }

  //   pageController.animateToPage(
  //     currentDay - 1,
  //     duration: Duration(milliseconds: 400),
  //     curve: Curves.ease,
  //   );
  // }

  Widget _buildTimetableLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTimetableError(String error) {
    return CustomPlaceHolder(
      text: error ??
          AppLocalizations.of(context).translate('unexcepted_error_single'),
      icon: Icons.error,
      showUpdate: true,
      onTap: () {
        BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
      },
    );
  }
}
