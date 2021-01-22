import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class NextEventsPage extends StatelessWidget {
  final List<AgendaEventDomainModel> events;
  const NextEventsPage({
    Key key,
    @required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentMonth = -1;
    bool showMonth;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('next_events'),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          if (event.begin.month != currentMonth) {
            showMonth = true;
          } else {
            showMonth = false;
          }

          currentMonth = event.begin.month;

          if (showMonth) {
            var convertMonthLocale = DateUtils.convertMonthLocale(
                event.begin, AppLocalizations.of(context).locale.toString());
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
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                _buildEventCard(event, context)
              ],
            );
          } else {
            return _buildEventCard(event, context);
          }
        },
      ),
    );
  }

  Widget _buildEventCard(AgendaEventDomainModel e, BuildContext context) {
    if (e.isLocal) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (e.title != '')
                  Text(
                    '${e.title}',
                    style: TextStyle(fontSize: 15.0),
                  ),
                if (e.title != '')
                  const SizedBox(
                    height: 2.5,
                  ),
                Text(
                  '${e.notes} - ${GlobalUtils.getEventDateMessage(context, e.begin, e.isFullDay)}',
                  style: TextStyle(fontSize: e.title != '' ? 12.0 : 15),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (e.title != '')
                Text(
                  '${e.title}',
                  style: TextStyle(fontSize: 15.0),
                ),
              if (e.title != '')
                const SizedBox(
                  height: 2.5,
                ),
              Text(
                '${StringUtils.titleCase(e.author)} - ${GlobalUtils.getEventDateMessage(context, e.begin, e.isFullDay)}',
                style: TextStyle(fontSize: e.title != '' ? 12.0 : 15),
              ),
              if (e.notes != '')
                Text(
                  '${e.notes}',
                  style: TextStyle(fontSize: 13.0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
