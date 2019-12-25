import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class AgendaCardEvent extends StatelessWidget {
  final AgendaEvent agendaEvent;

  const AgendaCardEvent({Key key, this.agendaEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 38,
            top: 0,
            bottom: 0,
            width: 2,
            child: Container(color: Colors.red), // replace with your image
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          agendaEvent.begin.day.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                        Text(
                          DateFormat.MMM(AppLocalizations.of(context).locale.toString()).format(agendaEvent.begin),
                          style: TextStyle(fontSize: 13.0),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          agendaEvent.authorName,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          agendaEvent.notes,
                          style: TextStyle(fontSize: 13.0),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
