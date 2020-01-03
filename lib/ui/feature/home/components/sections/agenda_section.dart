import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/components/widgets/event_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class AgendaSection extends StatelessWidget {
  const AgendaSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildAgenda(context);
  }

  StreamBuilder<List<db.AgendaEvent>> _buildAgenda(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<AgendaBloc>(context).watchAllEvents(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<db.AgendaEvent> events =
            snapshot.data.toSet().toList() ?? List();
        if (events.length == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 64,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(AppLocalizations.of(context).translate('no_events'))
                ],
              ),
            ),
          );
        } else {
          return Container(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                return AgendaCardEvent(
                  agendaEvent: events[index],
                );
              },
            ),
          );
        }
      },
    );
  }
}
