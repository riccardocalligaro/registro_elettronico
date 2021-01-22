import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/presentation/watcher/agenda_watcher_bloc.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

import 'agenda_timeline.dart';

class HomeEvents extends StatelessWidget {
  const HomeEvents({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaWatcherBloc, AgendaWatcherState>(
      builder: (context, state) {
        if (state is AgendaWatcherLoadSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _AgendaLoaded(events: state.agendaDataDomainModel.events),
          );
        } else if (state is AgendaWatcherFailure) {
          return SRFailureView(failure: state.failure);
        }

        return _AgendaEmpty();
      },
    );
  }
}

class HomeAgendaHeader extends StatelessWidget {
  const HomeAgendaHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(AppLocalizations.of(context).translate('next_events')),
    );
  }
}

class _AgendaLoaded extends StatelessWidget {
  final List<AgendaEventDomainModel> events;

  const _AgendaLoaded({
    Key key,
    @required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AgendaTimeline(
          itemCount: events.length > 3 ? 3 : events.length,
          children: events.map((e) {
            if (e.isLocal) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (e.title != '')
                        Text(
                          '${e.title ?? ''}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      if (e.title != '')
                        const SizedBox(
                          height: 2.5,
                        ),
                      Text(
                        '${e.notes ?? ''} - ${GlobalUtils.getEventDateMessage(context, e.begin, e.isFullDay)}',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (e.title != '')
                      Text(
                        '${e.notes ?? ''}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    if (e.title != '')
                      const SizedBox(
                        height: 2.5,
                      ),
                    // Text(
                    //   '${StringUtils.titleCase(GlobalUtils.getMockupName())} - ${_getDateMessage(e, context)}',
                    //   style: TextStyle(fontSize: 12.0),
                    // ),
                    Text(
                      '${StringUtils.titleCase(e.author)} - ${_getDateMessage(e, context)}',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          indicators: events.map((e) {
            if (GlobalUtils.isCompito(e.notes)) {
              return Icon(
                Icons.assignment,
                color: Colors.grey[700],
              );
            }
            if (GlobalUtils.isVerificaOrInterrogazione(e.notes)) {
              return Icon(
                Icons.assignment_late,
                color: Colors.grey[700],
              );
            }
            return Icon(
              Icons.calendar_today,
              color: Colors.grey[700],
            );
          }).toList(),
        ),
        events.length > 3
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => NextEventsPage(
                      //       events: events,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text(AppLocalizations.of(context)
                        .translate('show_others')
                        .toUpperCase()),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  String _getDateMessage(
      AgendaEventDomainModel agendaEvent, BuildContext context) {
    return GlobalUtils.getEventDateMessage(
        context, agendaEvent.begin, agendaEvent.isFullDay);
  }
}

class _AgendaEmpty extends StatelessWidget {
  const _AgendaEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 54.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.calendar_today,
              size: 64,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(AppLocalizations.of(context).translate('no_events'))
          ],
        ),
      ),
    );
  }
}
