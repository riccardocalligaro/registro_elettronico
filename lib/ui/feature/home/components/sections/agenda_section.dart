import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/components/widgets/event_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class AgendaSection extends StatelessWidget {
  const AgendaSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AgendaBloc>(context)
        .add(GetNextEvents(dateTime: DateTime.now(), numberOfevents: 3));
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        if (state is AgendaUpdateLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AgendaLoadSuccess) {
          return _buildAgenda(context, state.events);
        } else if (state is AgendaLoadError) {
          return CustomPlaceHolder(
            text: AppLocalizations.of(context).translate('erorr'),
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
  }
}
