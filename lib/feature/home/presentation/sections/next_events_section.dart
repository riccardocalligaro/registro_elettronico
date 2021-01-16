import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/agenda/presentation/bloc/agenda_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/blocs/agenda/agenda_dashboard_bloc.dart';
import 'package:registro_elettronico/feature/home/presentation/pages/next_events_page.dart';
import 'package:registro_elettronico/feature/home/presentation/widgets/timeline.dart';
import 'package:registro_elettronico/feature/home/presentation/widgets/week_summary_chart.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class NextEventsSection extends StatelessWidget {
  const NextEventsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaDashboardBloc, AgendaDashboardState>(
      builder: (context, state) {
        if (state is AgendaDashboardLoadSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WeekSummaryChart(
                events: state.events.toList(),
              ),
              Text(AppLocalizations.of(context).translate('next_events')),
              _buildAgenda(context, state.events),
            ],
          );
        } else if (state is AgendaDashboardLoadError) {
          return CustomPlaceHolder(
            text: AppLocalizations.of(context)
                .translate('unexcepted_error_single'),
            icon: Icons.error,
            showUpdate: true,
            onTap: () {
              BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildAgenda(
    BuildContext context,
    List<db.AgendaEvent> events,
  ) {
    events = events.toList()..sort((a, b) => a.begin.compareTo(b.begin));

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
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
    } else {
      return Column(
        children: <Widget>[
          Timeline(
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
                        '${StringUtils.titleCase(e.authorName)} - ${_getDateMessage(e, context)}',
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NextEventsPage(
                              events: events,
                            ),
                          ),
                        );
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
  }

  String _getDateMessage(db.AgendaEvent agendaEvent, BuildContext context) {
    return GlobalUtils.getEventDateMessage(
        context, agendaEvent.begin, agendaEvent.isFullDay);
  }
}
