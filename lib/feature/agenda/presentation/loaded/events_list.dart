import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/presentation_constants.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';
import 'package:share/share.dart';

import 'event/edit_event_page.dart';

class AgendaEventsList extends StatelessWidget {
  final List<AgendaEventDomainModel>? events;

  const AgendaEventsList({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events == null || events!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 64.0, bottom: 32),
        child: CustomPlaceHolder(
          icon: Icons.event,
          text: AppLocalizations.of(context)!.translate('empty_events'),
          showUpdate: false,
        ),
      );
    }
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events!.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: events![index],
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final AgendaEventDomainModel event;
  final String additionalTitle;

  const EventCard({
    Key? key,
    required this.event,
    this.additionalTitle = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (event.isLocal!) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
        child: Card(
          color: Color(int.tryParse(event.labelColor!)!),
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
                  AppLocalizations.of(context)!
                      .translate('hour')!
                      .toLowerCase(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  SRDateUtils.convertTimeForDisplay(event.begin,
                      AppLocalizations.of(context)!.locale.toString()),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
              child: Text(
                '$additionalTitle${event.title!.trim()} ${event.subjectName!.isNotEmpty ? '-' : ''} ${event.subjectName!.toLowerCase()}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            subtitle: event.notes != ''
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: Text(
                      '${event.notes} ${event.isFullDay! ? AppLocalizations.of(context)!.translate('all_day')!.toLowerCase() : ""}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : null,
          ),
        ),
      );
    } else {
      if (event.notes!.isEmpty) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
          child: Card(
            color: Color(int.tryParse(event.labelColor ?? '-1') ??
                Colors.red.shade50.value),
            child: ListTile(
              onTap: () async {
                await _showBottomSheet(
                  agendaEventDomainModel: event,
                  context: context,
                );
              },
              leading: _buildEventLeading(event: event, context: context),
              title: Text(
                '$additionalTitle${event.author!.isNotEmpty ? StringUtils.titleCase(event.author!) : AppLocalizations.of(context)!.translate('no_name_author')}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }

      final colorCode = int.tryParse(event.labelColor ?? '-1');
      Color color;

      // we check if the conversion has worked
      if (colorCode != null) {
        color = Color(colorCode);
      } else {
        color = Colors.red;
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
        child: Card(
          color: color,
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
                '$additionalTitle${PresentationConstants.isForPresentation ? GlobalUtils.getMockupName() : event.author!.isNotEmpty ? StringUtils.titleCase(event.author!) : AppLocalizations.of(context)!.translate('no_name_author')}',
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
    required AgendaEventDomainModel agendaEventDomainModel,
    required BuildContext context,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context)!.translate('delete')!),
              onTap: () async {
                final AgendaRepository agendaRepository = sl();
                await agendaRepository.deleteEvent(event: event);

                FlutterLocalNotificationsPlugin
                    flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();

                await flutterLocalNotificationsPlugin.cancel(event.id!);

                Navigator.pop(context);
              },
            ),
            if (event.isLocal!)
              ListTile(
                leading: Icon(Icons.edit),
                title: Text(AppLocalizations.of(context)!.translate('modify')!),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditEventPage(
                        event: event,
                        type: event.subjectId != -1
                            ? AgendaEventType.assigment
                            : AgendaEventType.memo,
                      ),
                    ),
                  );
                },
              ),
            ListTile(
              onTap: () {
                final trans = AppLocalizations.of(context)!;

                String message = "";
                message +=
                    '${trans.translate('event')}: ${event.title != '' ? event.title : event.notes}';

                if (event.notes != '') {
                  message += '\n';
                  message += trans
                      .translate('notes_event')!
                      .replaceAll('{name}', event.notes!);
                }

                if (event.begin != null) {
                  message += '\n';

                  message += trans.translate('date_event')!.replaceAll(
                        '{date}',
                        SRDateUtils.convertDateLocaleDashboard(
                          event.begin,
                          AppLocalizations.of(context)!.locale.toString(),
                        ),
                      );
                }

                if (event.subjectId != -1) {
                  message += '\n';

                  message += trans.translate('subject_event')!.replaceAll(
                      '{subject}', StringUtils.titleCase(event.subjectName!));
                }
                Navigator.pop(context);

                Share.share(message);
              },
              leading: Icon(Icons.share),
              title: Text(AppLocalizations.of(context)!.translate('share')!),
            )
          ],
        );
      },
    );
  }

  Widget _buildEventLeading({
    required AgendaEventDomainModel event,
    required BuildContext context,
  }) {
    if (event.isFullDay!) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.translate('all_day_card')!,
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
          AppLocalizations.of(context)!.translate('hour')!.toLowerCase(),
          style: TextStyle(color: Colors.white),
        ),
        Text(
          '${event.begin!.hour.toString()} - ${event.end!.hour.toString()}',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
