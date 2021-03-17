import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/domain/model/timetable_entry_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/feature/timetable/presentation/timetable_event.dart';
import 'package:registro_elettronico/feature/timetable/presentation/watcher/timetable_watcher_bloc.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

import 'model/timetable_entry_presentation_model.dart';

class TimetablePage extends StatefulWidget {
  TimetablePage({Key key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  TimetableController _timetableController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TimetableWatcherBloc>(context)
        .add(TimetableStartWatcherIfNeeded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('timetable'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              TimetableRepository timetableRepository = sl();
              timetableRepository.regenerateTimetable();
            },
          )
        ],
      ),
      body: BlocBuilder<TimetableWatcherBloc, TimetableWatcherState>(
        builder: (context, state) {
          if (state is TimetableWatcherLoadSuccess) {
            final _timetableProvider =
                EventProvider.list(state.timetableData.entries);

            _timetableController =
                TimetableController<TimetableEntryPresentationModel>(
              eventProvider: _timetableProvider,
              initialTimeRange: InitialTimeRange.zoom(4),
              initialDate: LocalDate.dateTime(_findFirstDateOfTheWeek(
                DateTime.now(),
              )),
              visibleRange: VisibleRange.days(3),
              firstDayOfWeek: DayOfWeek.monday,
            );

            return _TimetableLoaded(
              entires: state.timetableData.entries,
              timetableController: _timetableController,
              subjects: state.timetableData.subjects,
            );
          } else if (state is TimetableWatcherFailure) {
            return SRFailureView(
              failure: state.failure,
              refresh: _refresh,
            );
          }
          return SRLoadingView();
        },
      ),
    );
  }

  DateTime _findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  Future<void> _refresh() {
    final TimetableRepository timetableRepository = sl();
    return timetableRepository.regenerateTimetable();
  }
}

class _TimetableLoaded extends StatelessWidget {
  final List<TimetableEntryPresentationModel> entires;
  final List<SubjectDomainModel> subjects;

  final TimetableController<TimetableEntryPresentationModel>
      timetableController;

  const _TimetableLoaded({
    Key key,
    @required this.entires,
    @required this.timetableController,
    @required this.subjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Timetable<TimetableEntryPresentationModel>(
      controller: timetableController,
      dateHeaderBuilder: (context, date) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            SRDateUtils.convertSingleDayForDisplay(
              date.toDateTimeUnspecified(),
              AppLocalizations.of(context).locale.toString(),
            ),
            style: TextStyle(
              color: date == LocalDate.today()
                  ? Theme.of(context).accentColor
                  : null,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
      eventBuilder: (event) => TimetableEventWidget(
        event,
      ),
      onEventBackgroundTap: (start, isAllDay) {
        _showAddEntryDialog(context: context, start: start);
      },
    );
  }

  void _showAddEntryDialog({
    @required BuildContext context,
    @required LocalDateTime start,
  }) {
    final startHour = start.hourOfDay;
    showDialog<TimetableEntryDomainModel>(
      context: context,
      builder: (context) {
        return _AddEntryDialog(
          subjects: subjects,
          start: startHour,
          dayOfWeek: start.dayOfWeek.value,
        );
      },
    ).then((TimetableEntryDomainModel entry) async {
      if (entry != null) {
        final TimetableRepository timetableRepository = sl();
        await timetableRepository.insertTimetableEntry(entry: entry);
      }
    });
  }
}

class _AddEntryDialog extends StatefulWidget {
  final List<SubjectDomainModel> subjects;
  final int start;
  final int dayOfWeek;

  _AddEntryDialog({
    Key key,
    @required this.subjects,
    @required this.start,
    @required this.dayOfWeek,
  }) : super(key: key);

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<_AddEntryDialog> {
  int _hourValue;
  int _durationValue;
  SubjectDomainModel _selectedSubject;
  AddEntryStatus status = AddEntryStatus.start;

  @override
  void initState() {
    super.initState();
    setState(() {
      _hourValue = widget.start;
      _durationValue = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(),
      actions: [
        TextButton(
          onPressed: () {
            if (status == AddEntryStatus.start) {
              Navigator.pop(context);
            } else if (status == AddEntryStatus.duration) {
              setState(() {
                status = AddEntryStatus.start;
              });
            } else {
              setState(() {
                status = AddEntryStatus.duration;
              });
            }
          },
          child: Text(status == AddEntryStatus.start
              ? 'Annulla'.toUpperCase()
              : 'Indietro'.toUpperCase()),
        ),
        if (status == AddEntryStatus.start)
          TextButton(
            onPressed: () {
              setState(() {
                status = AddEntryStatus.duration;
              });
            },
            child: Text('Avanti'.toUpperCase()),
          ),
        if (status == AddEntryStatus.duration)
          TextButton(
            onPressed: () {
              setState(() {
                status = AddEntryStatus.subject;
              });
            },
            child: Text('Avanti'.toUpperCase()),
          ),
        if (status == AddEntryStatus.subject)
          TextButton(
            onPressed: () async {
              final entry = TimetableEntryDomainModel(
                id: null,
                start: (_hourValue - 7),
                end: (_hourValue + _durationValue) - 8,
                dayOfWeek: widget.dayOfWeek - 1,
                subject: _selectedSubject.id,
                subjectName: _selectedSubject.name,
              );

              Navigator.pop(context, entry);
            },
            child: Text('Fine'.toUpperCase()),
          ),
      ],
    );
  }

  Widget _buildTitle() {
    if (status == AddEntryStatus.start) {
      return Text('Ora');
    } else if (status == AddEntryStatus.duration) {
      return Text('Durata');
    } else {
      return Text('Seleziona materia');
    }
  }

  Widget _buildContent() {
    if (status == AddEntryStatus.start) {
      return _buildSelectHour();
    } else if (status == AddEntryStatus.duration) {
      return _buildSelectDuration();
    } else {
      return _buildSubjects();
    }
  }

  Widget _buildSelectHour() {
    return NumberPicker.integer(
      key: UniqueKey(),
      initialValue: _hourValue,
      minValue: 0,
      maxValue: 22,
      onChanged: (value) {
        setState(() {
          _hourValue = value;
        });
      },
    );
  }

  Widget _buildSelectDuration() {
    return NumberPicker.integer(
      key: UniqueKey(),
      initialValue: _durationValue,
      minValue: 1,
      maxValue: 5,
      onChanged: (value) {
        setState(() {
          _durationValue = value;
        });
      },
    );
  }

  Widget _buildSubjects() {
    return Container(
      height: 350,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            widget.subjects.length,
            (int index) {
              return RadioListTile<SubjectDomainModel>(
                activeColor: Theme.of(context).accentColor,
                title: Text(
                  GlobalUtils.reduceSubjectTitle(widget.subjects[index].name),
                  style: TextStyle(fontSize: 13),
                ),
                value: widget.subjects[index],
                groupValue: _selectedSubject,
                onChanged: (SubjectDomainModel subj) {
                  setState(() {
                    _selectedSubject = subj;
                  });
                },
                //groupValue: 312,
              );
            },
          ),
        ),
      ),
    );
  }
}

enum AddEntryStatus { start, duration, subject }
