import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/feature/timetable/domain/model/timetable_entry_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/feature/timetable/presentation/timetable_event.dart';
import 'package:registro_elettronico/feature/timetable/presentation/watcher/timetable_watcher_bloc.dart';
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
            final _timetableProvider = EventProvider.list(state.timetable);
            DateTime _initialDay;
            final today = DateTime.now();
            if (today.weekday == DateTime.sunday ||
                today.weekday == DateTime.saturday) {
              _initialDay = DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1));
            } else {
              _initialDay = today;
            }

            _timetableController =
                TimetableController<TimetableEntryPresentationModel>(
              eventProvider: _timetableProvider,
              initialTimeRange: InitialTimeRange.zoom(4),
              initialDate: LocalDate.dateTime(_initialDay),
              visibleRange: VisibleRange.days(3),
              firstDayOfWeek: DayOfWeek.monday,
            );

            return _TimetableLoaded(
              entires: state.timetable,
              timetableController: _timetableController,
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

class _TimetableLoaded extends StatelessWidget {
  final List<TimetableEntryPresentationModel> entires;
  final TimetableController<TimetableEntryPresentationModel>
      timetableController;

  const _TimetableLoaded({
    Key key,
    @required this.entires,
    @required this.timetableController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Timetable<TimetableEntryPresentationModel>(
      controller: timetableController,
      eventBuilder: (event) => TimetableEventWidget(
        event,
        onTap: () {
          print('Heòòp');
        },
      ),
      onEventBackgroundTap: (time, value) {
        print('$time $value');
      },
    );
  }
}
