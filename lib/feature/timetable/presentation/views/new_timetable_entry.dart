import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/presentation/widgets/app_drawer.dart';
import 'package:registro_elettronico/feature/agenda/presentation/loaded/dialog/select_subject_dialog.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/feature/timetable/presentation/bloc/timetable_bloc.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class NewTimetableEntry extends StatefulWidget {
  final int startHour;
  final int dayOfWeek;

  NewTimetableEntry({
    Key key,
    this.startHour,
    this.dayOfWeek,
  }) : super(key: key);

  @override
  _NewTimetableEntryState createState() => _NewTimetableEntryState();
}

class _NewTimetableEntryState extends State<NewTimetableEntry> {
  Subject _selectedSubject;
  bool _missingSubject = false;

  TimeOfDay _start;

  int _durationHours = 1;

  DateTime _dayOfWeek;

  @override
  void initState() {
    super.initState();
    _start = TimeOfDay(hour: widget.startHour, minute: 0);

    _dayOfWeek =
        DateTime.utc(2000, 1, 2).add(Duration(days: widget.dayOfWeek - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(AppLocalizations.of(context).translate('new_entry')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _insertEntryInDb,
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            _buildSubjectCard(),
            _buildTimeCard(),
            _buildDurationCard(),
            _buildDayCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard() {
    return Card(
      child: ListTile(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(7, (index) {
                      final date = DateTime.utc(2000, 1, 2)
                          .add(Duration(days: index + 1));
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context, date);
                        },
                        title: Text(DateUtils.convertSingleDayForDisplay(date,
                            AppLocalizations.of(context).locale.toString())),
                      );
                    }),
                  ),
                );
              }).then((date) {
            if (date != null) {
              setState(() {
                _dayOfWeek = date;
              });
            }
          });
        },
        leading: Icon(Icons.calendar_today),
        title: Text(DateUtils.convertSingleDayForDisplay(
            _dayOfWeek, AppLocalizations.of(context).locale.toString())),
      ),
    );
  }

  Widget _buildDurationCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.timelapse,
        ),
        title: Text(AppLocalizations.of(context).translate('duration')),
        trailing: Text('$_durationHours H'),
        onTap: () {
          if (18 - _start.hour >= 1) {
            showDialog(
              context: context,
              builder: (context) {
                return NumberPickerDialog.integer(
                  initialIntegerValue: _durationHours,
                  minValue: 1,
                  maxValue: 18 - _start.hour + 1,
                  title:
                      Text(AppLocalizations.of(context).translate('duration')),
                  cancelWidget: Text(AppLocalizations.of(context)
                      .translate('delete')
                      .toUpperCase()),
                );
              },
            ).then((value) {
              if (value != null) {
                setState(() {
                  _durationHours = value;
                });
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildTimeCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.access_time,
        ),
        title: Text(AppLocalizations.of(context).translate('time')),
        trailing: Text(_start.format(context)),
        onTap: () {
          showTimePicker(
            context: context,
            initialTime: _start,
          ).then((time) {
            if (time != null) {
              setState(() {
                if (time.hour >= 7 && time.hour <= 18) {
                  _start = time;
                }
              });
            }
          });
        },
      ),
    );
  }

  Widget _buildSubjectCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.school,
          color: _getIconColorForMissingSubject(),
        ),
        title: Text(
          _selectedSubject != null
              ? _getReducedName(_selectedSubject.name)
              : AppLocalizations.of(context).translate('choose_subject'),
          style: TextStyle(
            color: _getColorForMissingSubject(),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SelectSubjectDialog(),
          ).then((value) {
            if (value != null) {
              setState(() {
                _missingSubject = false;
                _selectedSubject = value;
              });
            }
          });
        },
      ),
    );
  }

  void _insertEntryInDb() async {
    if (_selectedSubject != null) {
      for (var i = 0; i < _durationHours; i++) {
        final start = _start.hour + i - 7;
        await RepositoryProvider.of<TimetableRepository>(context)
            .deleteTimetableEntryWithDate(_dayOfWeek.weekday, start, start);
        BlocProvider.of<TimetableBloc>(context).add(GetTimetable());

        await RepositoryProvider.of<TimetableRepository>(context)
            .insertTimetableEntry(TimetableEntry(
                subject: _selectedSubject.id,
                dayOfWeek: _dayOfWeek.weekday,
                start: start,
                end: start,
                subjectName: _selectedSubject.name));
      }

      Logger.info(
          'Insert entry subject ${_selectedSubject.id}, dayOfWeek: ${_dayOfWeek.weekday} start ${_start.hour} duration $_durationHours');

      await BlocProvider.of<TimetableBloc>(context).add(GetTimetable());

      Navigator.pop(context);
    } else {
      setState(() {
        _missingSubject = true;
      });
    }
  }

  String _getReducedName(String subjectName) {
    try {
      if (subjectName.length > 25) {
        return '${StringUtils.titleCase(subjectName.substring(0, 24))}...';
      } else {
        return StringUtils.titleCase(subjectName);
      }
    } catch (e) {
      return subjectName.toLowerCase();
    }
  }

  Color _getColorForMissingSubject() {
    if (_missingSubject) {
      return Colors.red;
    } else {
      return null;
    }
  }

  Color _getIconColorForMissingSubject() {
    if (_missingSubject) {
      return Colors.red;
    } else {
      return null;
    }
  }
}
