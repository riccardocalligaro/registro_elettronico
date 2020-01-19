import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/agenda/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/widgets/timeline.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class NextEventsSection extends StatelessWidget {
  const NextEventsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        if (state is AgendaUpdateLoadInProgress) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AgendaLoadError) {
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: CustomPlaceHolder(
              icon: Icons.error,
              showUpdate: false,
              text: 'Erorr',
            ),
          );
        } else {
          return BlocBuilder<AgendaDashboardBloc, AgendaDashboardState>(
            builder: (context, state) {
              if (state is AgendaDashboardLoadSuccess) {
                return _buildAgenda(context, state.events);
              } else if (state is AgendaDashboardLoadError) {
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
      },
    );
  }

  Widget _buildAgenda(
    BuildContext context,
    List<db.AgendaEvent> events,
  ) {
    events = events.toSet().toList();

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
      return Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Timeline(
          children: events.map((e) {
            return Card(
              child: ListTile(
                title: Text('${e.notes ?? ''}'),
                subtitle: Text(
                    '${StringUtils.titleCase(e.authorName)} - ${GlobalUtils.getEventDateMessage(context, e.begin)}'),
              ),
            );
          }).toList(),
          indicators: events.map((e) {
            if (GlobalUtils.isCompito(e.notes))
              return Icon(
                Icons.assignment,
                color: Colors.grey[700],
              );
            if (GlobalUtils.isVerificaOrInterrogazione(e.notes))
              return Icon(
                Icons.assignment_late,
                color: Colors.grey[700],
              );
            return Icon(
              Icons.calendar_today,
              color: Colors.grey[700],
            );
          }).toList(),
        ),
      );
    }
  }

  // Widget _buildPoint(bool isLast) {
  //   return Stack(
  //     children: <Widget>[
  //       Container(
  //         width: 5,
  //         height: 100,
  //         color: Colors.green,
  //       ),
  //       Positioned(
  //         top: 25,
  //         child: Container(
  //           height: 20,
  //           width: 30,
  //           color: Colors.red,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
