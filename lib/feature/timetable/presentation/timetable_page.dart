import 'package:collection/src/iterable_extensions.dart';
import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/states/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/states/sr_loading_view.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/domain/model/timetable_entry_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/feature/timetable/presentation/timetable_event.dart';
import 'package:registro_elettronico/feature/timetable/presentation/watcher/timetable_watcher_bloc.dart';
import 'package:supercharged_dart/supercharged_dart.dart';
import 'package:timetable/timetable.dart';

import 'model/timetable_entry_presentation_model.dart';

class TimetablePage extends StatefulWidget {
  TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
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
          AppLocalizations.of(context)!.translate('timetable')!,
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
            // we display the timetable wisget
            return _TimetableLoaded(
              entriesMap: state.timetableData.entriesMap,
              subjects: state.timetableData.subjects,
              entires: state.timetableData.entries,
              entriesMapForDragging: state.timetableData.entriesMapForDragging,
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

  Future<void> _refresh() {
    final TimetableRepository timetableRepository = sl();
    return timetableRepository.regenerateTimetable();
  }
}

class _TimetableLoaded extends StatefulWidget {
  final List<TimetableEntryPresentationModel> entires;
  final List<SubjectDomainModel> subjects;
  final Map<DateTime, List<TimetableEntryPresentationModel>> entriesMap;
  final Map<Tuple2, List<TimetableEntryPresentationModel>>
      entriesMapForDragging;

  const _TimetableLoaded({
    Key? key,
    required this.entriesMap,
    required this.subjects,
    required this.entires,
    required this.entriesMapForDragging,
  }) : super(key: key);

  @override
  State<_TimetableLoaded> createState() => _TimetableLoadedState();
}

class _TimetableLoadedState extends State<_TimetableLoaded> {
  TimeController? _timeController;
  DateController? _dateController;

  /// Here are temporarely stored the dragged events that will be later saved
  final _draggedEvents = <TimetableEntryPresentationModel>[];
  final roundedTo = 15.minutes;

  @override
  void initState() {
    setState(() {
      _timeController = TimeController(
        initialRange: TimeRange(
          Duration(hours: 7, minutes: 45),
          Duration(hours: 14, minutes: 45),
        ),
      );

      _dateController = DateController(
        visibleRange: VisibleDateRange.days(3),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TimetableConfig<TimetableEntryPresentationModel>(
      timeController: _timeController,
      dateController: _dateController,
      timeOverlayProvider: mergeTimeOverlayProviders([
        positioningOverlayProvider,
        (context, date) => _draggedEvents
            .map((it) =>
                it.toTimeOverlay(date: date, widget: TimetableEventWidget(it)))
            .whereNotNull()
            .toList(),
      ]),
      eventBuilder: (context, event) => PartDayDraggableEvent(
        child: TimetableEventWidget(event),
        // The user started dragging this event.
        onDragStart: () => setState(() {
          _draggedEvents.add(event);
        }),
        // The user has moved this event
        onDragUpdate: (dateTime) => setState(() {
          dateTime = dateTime.roundTimeToMultipleOf(roundedTo);
          final index = _draggedEvents.indexWhere((it) => it.id == event.id);
          final oldEvent = _draggedEvents[index];
          _draggedEvents[index] = oldEvent.copyWith(
            start: dateTime,
            end: dateTime + oldEvent.duration,
          );
        }),
        // The user is no longer moving this event
        onDragEnd: (dateTime) {
          dateTime = (dateTime ?? event.start).roundTimeToMultipleOf(roundedTo);

          final index = _draggedEvents.indexWhere((it) => it.id == event.id);
          final oldEvent = _draggedEvents[index];
          final newEvent = oldEvent.copyWith(
            start: dateTime,
            end: dateTime + oldEvent.duration,
          );

          final day = Tuple2(
              DateTime(
                newEvent.start.year,
                newEvent.start.month,
                newEvent.start.day,
                newEvent.start.hour,
              ),
              DateTime(
                newEvent.end.year,
                newEvent.end.month,
                newEvent.end.day,
                newEvent.end.hour,
              ));

          final TimetableRepository timetableRepository = sl();

          // this checks if the new position is overlaying something
          if (widget.entriesMapForDragging[day] == null) {
            timetableRepository.updateTimetableEntry(
                entry: TimetableEntryDomainModel(
              id: event.id,
              start: newEvent.start.hour - 7,
              end: (newEvent.start + oldEvent.duration).hour - 8,
              dayOfWeek: newEvent.start.weekday - 1,
              subject: newEvent.subjectId,
              subjectName: newEvent.subjectName,
            ));
          } else {
            // swap them
            // TODO: swap on timetable
          }

          setState(() => _draggedEvents.removeWhere((it) => it.id == event.id));
        },
      ),
      child: RecurringMultiDateTimetable<TimetableEntryPresentationModel>(),
      eventProvider: (interval) {
        // we need to find the day that corresponds to the interval
        final day = DateTime(
            interval.start.year, interval.start.month, interval.start.day);

        return widget.entriesMap[day] ?? [];
      },
      callbacks: TimetableCallbacks(
        onDateTimeBackgroundTap: (date) {
          _showAddEntryDialog(start: date, context: context);
        },
      ),
      theme: TimetableThemeData(
        context,
        startOfWeek: DateTime.monday,
        dateEventsStyleProvider: (date) {
          return DateEventsStyle(context, date);
        },
      ),
    );
  }

  List<TimeOverlay> positioningOverlayProvider(
    BuildContext context,
    DateTime date,
  ) {
    assert(date.isValidTimetableDate);

    if (DateTime.monday <= date.weekday && date.weekday <= DateTime.friday) {
      return [
        TimeOverlay(start: 0.hours, end: 8.hours, widget: Container()),
        TimeOverlay(start: 20.hours, end: 24.hours, widget: Container()),
      ];
    } else {
      return [TimeOverlay(start: 0.hours, end: 24.hours, widget: Container())];
    }
  }

  void _showAddEntryDialog({
    required BuildContext context,
    required DateTime start,
  }) {
    final startHour = start.hour;
    showDialog<TimetableEntryDomainModel>(
      context: context,
      builder: (context) {
        return _AddEntryDialog(
          subjects: widget.subjects,
          start: startHour,
          dayOfWeek: start.weekday,
        );
      },
    ).then((entry) async {
      if (entry != null) {
        final TimetableRepository timetableRepository = sl();
        await timetableRepository.insertTimetableEntry(entry: entry);
      }
    });
  }
}

// class _TimetableLoaded extends StatelessWidget {
//   final List<TimetableEntryPresentationModel> entires;
//   final List<SubjectDomainModel> subjects;

//   final TimetableController<TimetableEntryPresentationModel>
//       timetableController;

//   const _TimetableLoaded({
//     Key key,
//     @required this.entires,
//     @required this.timetableController,
//     @required this.subjects,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Timetable<TimetableEntryPresentationModel>(
//       controller: timetableController,
//       dateHeaderBuilder: (context, date) {
//         return Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             SRDateUtils.convertSingleDayForDisplay(
//               date.toDateTimeUnspecified(),
//               AppLocalizations.of(context).locale.toString(),
//             ),
//             style: TextStyle(
//               color: date == LocalDate.today()
//                   ? Theme.of(context).colorScheme.secondary
//                   : null,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       },
//       eventBuilder: (event) => TimetableEventWidget(
//         event,
//       ),
//       onEventBackgroundTap: (start, isAllDay) {
//         _showAddEntryDialog(context: context, start: start);
//       },
//     );
//   }

class _AddEntryDialog extends StatefulWidget {
  final List<SubjectDomainModel> subjects;
  final int start;
  final int dayOfWeek;

  _AddEntryDialog({
    Key? key,
    required this.subjects,
    required this.start,
    required this.dayOfWeek,
  }) : super(key: key);

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<_AddEntryDialog> {
  int? _hourValue;
  int? _durationValue;
  SubjectDomainModel? _selectedSubject;
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
                start: (_hourValue! - 7),
                end: (_hourValue! + _durationValue!) - 8,
                dayOfWeek: widget.dayOfWeek - 1,
                subject: _selectedSubject?.id,
                subjectName: _selectedSubject?.name,
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
    return Container();
    // return NumberPicker.integer(
    //   key: UniqueKey(),
    //   initialValue: _hourValue,
    //   minValue: 0,
    //   maxValue: 22,
    //   onChanged: (value) {
    //     setState(() {
    //       _hourValue = value;
    //     });
    //   },
    // );
  }

  Widget _buildSelectDuration() {
    return Container();
    // return NumberPicker.integer(
    //   key: UniqueKey(),
    //   initialValue: _durationValue,
    //   minValue: 1,
    //   maxValue: 5,
    //   onChanged: (value) {
    //     setState(() {
    //       _durationValue = value;
    //     });
    //   },
    // );
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
                activeColor: Theme.of(context).colorScheme.secondary,
                title: Text(
                  // TODO:
                  'das',
                  // GlobalUtils.reduceSubjectTitle(widget.subjects[index].name),
                  style: TextStyle(fontSize: 13),
                ),
                value: widget.subjects[index],
                groupValue: _selectedSubject,
                onChanged: (SubjectDomainModel? subj) {
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
