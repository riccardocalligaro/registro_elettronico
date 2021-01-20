import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/core/data/model/event_type.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

import 'event/edit_event_page.dart';

class AgendaEventsList extends StatelessWidget {
  final List<AgendaEventDomainModel> events;

  const AgendaEventsList({
    Key key,
    @required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events == null || events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 64.0),
        child: CustomPlaceHolder(
          icon: Icons.event,
          text: AppLocalizations.of(context).translate('empty_events'),
          showUpdate: false,
        ),
      );
    }
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _EventCard(
          event: events[index],
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  final AgendaEventDomainModel event;

  const _EventCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (event.isLocal) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
        child: Card(
          color: Color(int.parse(event.labelColor)),
          child: ListTile(
            onTap: () async {
              await _showBottomSheet(
                agendaEventDomainModel: event,
                context: context,
              );
            },
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('hour').toLowerCase(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  DateUtils.convertTimeForDisplay(event.begin,
                      AppLocalizations.of(context).locale.toString()),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
              child: Text(
                '${event.title.trim()} - ${event.subjectName.toLowerCase()}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            subtitle: event.notes != ''
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: Text(
                      '${event.notes} ${event.isFullDay ? AppLocalizations.of(context).translate('all_day').toLowerCase() : ""}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : null,
          ),
        ),
      );
    } else {
      if (event.notes.isEmpty) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
          child: Card(
            color: Color(int.parse(event.labelColor)) ?? Colors.red,
            child: ListTile(
              onTap: () {
                _showBottomSheet(
                  agendaEventDomainModel: event,
                  context: context,
                );
              },
              leading: _buildEventLeading(event: event, context: context),
              title: Text(
                '${event.author.isNotEmpty ? StringUtils.titleCase(event.author) : AppLocalizations.of(context).translate('no_name_author')}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
        child: Card(
          color: Color(int.parse(event.labelColor)) ?? Colors.red,
          child: ListTile(
            onTap: () async {
              await _showBottomSheet(
                agendaEventDomainModel: event,
                context: context,
              );
            },
            leading: _buildEventLeading(event: event, context: context),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                '${event.author.isNotEmpty ? StringUtils.titleCase(event.author) : AppLocalizations.of(context).translate('no_name_author')}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
              child: Text(
                '${event.notes}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future _showBottomSheet({
    @required AgendaEventDomainModel agendaEventDomainModel,
    @required BuildContext context,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).translate('delete')),
              onTap: () async {
                final AgendaRepository agendaRepository = sl();
                await agendaRepository.deleteEvent(event: event);

                FlutterLocalNotificationsPlugin
                    flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();

                await flutterLocalNotificationsPlugin.cancel(event.id);

                Navigator.pop(context);
              },
            ),
            if (event.isLocal)
              ListTile(
                leading: Icon(Icons.edit),
                title: Text(AppLocalizations.of(context).translate('modify')),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditEventPage(
                        event: event,
                        type: event.subjectId != -1
                            ? EventType.assigment
                            : EventType.memo,
                      ),
                    ),
                  );
                },
              ),
            ListTile(
              onTap: () {
                final trans = AppLocalizations.of(context);

                String message = "";
                message +=
                    '${trans.translate('event')}: ${event.title != '' ? event.title : event.notes}';

                if (event.notes != '') {
                  message += '\n';
                  message += trans
                      .translate('notes_event')
                      .replaceAll('{name}', event.notes);
                }

                if (event.begin != null) {
                  message += '\n';

                  message += trans.translate('date_event').replaceAll(
                        '{date}',
                        DateUtils.convertDateLocaleDashboard(
                          event.begin,
                          AppLocalizations.of(context).locale.toString(),
                        ),
                      );
                }

                if (event.subjectId != -1) {
                  message += '\n';

                  message += trans.translate('subject_event').replaceAll(
                      '{subject}', StringUtils.titleCase(event.subjectName));
                }
                Navigator.pop(context);

                Share.text(AppLocalizations.of(context).translate('share'),
                    message, 'text/plain');
              },
              leading: Icon(Icons.share),
              title: Text(AppLocalizations.of(context).translate('share')),
            )
          ],
        );
      },
    );
  }

  Widget _buildEventLeading({
    @required AgendaEventDomainModel event,
    @required BuildContext context,
  }) {
    if (event.isFullDay) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('all_day_card'),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('hour').toLowerCase(),
          style: TextStyle(color: Colors.white),
        ),
        Text(
          '${event.begin.hour.toString()} - ${event.end.hour.toString()}',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
